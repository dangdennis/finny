package budget

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_client"
	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/google/uuid"
)

type NetworkError struct {
	Message string
}

func (e * NetworkError) Error() string {
	return fmt.Sprintf("Network error: %s", e.Message)
}

type NotFoundError struct {
	Message string
}

func (e *NotFoundError) Error() string {
	return fmt.Sprintf("No data found Error: %s", e.Message)
}

type BudgetService struct {
	ynabAuthService    *ynab_auth.YNABAuthService
	ynabClient ynab_client.YNAB
	budgetID uuid.UUID
}

func NewBudgetService(ynabAuthService *ynab_auth.YNABAuthService, ynabClient ynab_client.YNAB) (*BudgetService, error) {
	budgetResponse, err := ynabClient.GetLatestBudget(context.Background())
	if err != nil {
		if _, ok:= err.(*NetworkError); ok {
			return nil, &NetworkError{Message: err.Error()}
		}
		return nil, &NotFoundError{Message: err.Error()}
	}

    return &BudgetService{
        ynabAuthService: ynabAuthService,
        ynabClient:      ynabClient,
		budgetID: budgetResponse.Data.Budget.Id,
    }, nil
}

func (b *BudgetService) GetAnnualAverageExpenseFromYNAB() (int64, error) {
	monthBudgets, err := b.FetchLast12MonthsDetails(b.ynabClient)
	if err != nil {
		if _, ok:= err.(*NetworkError); ok {
			return 0, &NetworkError{Message: err.Error()}
		}

		return 0, &NotFoundError{Message: err.Error()}
	}

	var avgAnnualExpense int64
	for _, budget := range monthBudgets {
		expenseForTheMonth := b.CalculateExpenseFromCategories(budget.Budget.Categories)
		avgAnnualExpense += expenseForTheMonth
	}

	return avgAnnualExpense / int64(len(monthBudgets)), nil
}

func (b *BudgetService) CalculateExpenseFromCategories(categories []ynab_openapi.Category) int64 {
	var totalExpense int64

	for _, c := range categories {
		if c.Name == "Credit Card Payments" {
			continue
		}

		if c.Name == "Hidden Categories" {
			continue
		}

		if *c.CategoryGroupName == "Internal Master Category" && c.Name != "Uncategorized" {
			continue
		}

		totalExpense += c.Activity
	}

	return (totalExpense / 1000) * -1
}

type MonthBudget struct {
	Month  time.Time
	Budget *ynab_openapi.MonthDetail
	Error  error
}

func (b *BudgetService) FetchLast12MonthsDetails(ynab ynab_client.YNAB) ([]MonthBudget, error) {
	ctx := context.Background()

	var wg sync.WaitGroup
	results := make([]MonthBudget, 12)
	budgetChan := make(chan MonthBudget, 12)

	now := time.Now().UTC()
	now = time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, time.UTC)

	for i := 0; i < 12; i++ {
		wg.Add(1)

		go func(monthsAgo int) {
			defer wg.Done()

			targetMonth := now.AddDate(0, -monthsAgo, 0)
			budget, err := ynab.GetMonthDetail(ctx, b.budgetID.String(), targetMonth)
			result := MonthBudget{
				Month:  targetMonth,
				Budget: budget,
				Error:  err,
			}
			budgetChan <- result
		}(i)
	}

	wg.Wait()
	close(budgetChan)

	for result := range budgetChan {
		if result.Error != nil {

			if _, ok := result.Error.(*NetworkError); ok{
				return []MonthBudget{}, &NetworkError{Message: result.Error.Error()}
			}
			return []MonthBudget{}, &NotFoundError{Message: "No data found for the specified month"}
		}

		monthIndex := int(now.Sub(result.Month).Hours() / 24 / 30)
		results[monthIndex] = result
	}

	return results, nil
}
