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

type BudgetService struct {
	ynabAuthService    ynab_auth.YNABAuth
	ynabClientProvider func(accessToken string) (ynab_client.YNAB, error)
}

func NewBudgetService(
	ynabAuthService ynab_auth.YNABAuth,
	ynabClientProvider func(accessToken string) (ynab_client.YNAB, error),
) (*BudgetService, error) {
	if ynabAuthService == nil {
		return nil, fmt.Errorf("ynabAuthService is nil")
	}

	return &BudgetService{
		ynabAuthService:    ynabAuthService,
		ynabClientProvider: ynabClientProvider,
	}, nil
}

func (b *BudgetService) GetAnnualAverageExpenseFromYNAB(userID uuid.UUID) (int64, error) {
	accessToken, err := b.ynabAuthService.GetAccessToken(userID)
	if err != nil {
		return 0, err
	}

	ynabClient, err := b.ynabClientProvider(accessToken.AccessToken)
	if err != nil {
		return 0, err
	}

	monthBudgets, err := b.FetchLast12MonthsDetails(ynabClient)
	if err != nil {
		return 0, err
	}

	var totalExpense int64
	if len(monthBudgets) == 0 {
		return totalExpense, nil
	}

	for _, budget := range monthBudgets {
		if budget.Budget == nil {
			continue
		}
		expenseForTheMonth := b.CalculateExpenseFromCategories(budget.Budget.Categories)

		totalExpense += expenseForTheMonth
	}

	return totalExpense / int64(len(monthBudgets)) * 12, nil
}

func (b *BudgetService) CalculateExpenseFromCategories(categories []ynab_openapi.Category) int64 {
	var totalExpense int64

	for _, c := range categories {
		if *c.CategoryGroupName == "Credit Card Payments" || *c.CategoryGroupName == "Internal Master Category" {
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
	budgetChan := make(chan MonthBudget, 12)

	now := time.Now().UTC()
	now = time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, time.UTC)

	for i := 0; i < 12; i++ {
		wg.Add(1)

		go func(monthsAgo int) {
			defer wg.Done()

			targetMonth := now.AddDate(0, -monthsAgo, 0)
			budget, err := ynab.GetMonthDetail(ctx, "last-used", targetMonth)
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

	existingBudgets := []MonthBudget{}
	for budget := range budgetChan {
		if budget.Error != nil {
			if _, ok := budget.Error.(*NetworkError); ok {
				return []MonthBudget{}, &NetworkError{Message: budget.Error.Error()}
			}

			// If the month is not found, we can skip it
			continue
		}

		existingBudgets = append(existingBudgets, budget)
	}

	return existingBudgets, nil
}
