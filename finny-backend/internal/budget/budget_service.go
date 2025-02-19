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
	"gorm.io/gorm"
)

type BudgetService struct {
	db              *gorm.DB
	ynabAuthService *ynab_auth.YNABAuthService
}

func NewBudgetService(db *gorm.DB, ynabAuthService *ynab_auth.YNABAuthService) (*BudgetService, error) {
	if db == nil {
		return nil, fmt.Errorf("db is nil")
	}

	if ynabAuthService == nil {
		return nil, fmt.Errorf("ynabAuthService is nil")
	}

	return &BudgetService{
		db:              db,
		ynabAuthService: ynabAuthService,
	}, nil
}

func (b *BudgetService) GetAnnualAverageExpenseFromYNAB(userID uuid.UUID) (int64, error) {
	monthBudgets, err := b.FetchLast12MonthsDetails(userID)
	if err != nil {
		return 0, fmt.Errorf("failed to fetch last 12 months details. err=%w", err)
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

func (b *BudgetService) FetchLast12MonthsDetails(userID uuid.UUID) ([]MonthBudget, error) {
	ctx := context.Background()
	accessToken, err := b.ynabAuthService.GetAccessToken(userID)
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return []MonthBudget{}, fmt.Errorf("user has not connected to YNAB")
		}

		return []MonthBudget{}, err
	}

	ynab, err := ynab_client.NewYNABClient(accessToken.AccessToken)
	if err != nil {
		return []MonthBudget{}, fmt.Errorf("failed to create YNAB client. err=%w", err)
	}

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

	for result := range budgetChan {
		if result.Error != nil {
			return []MonthBudget{}, fmt.Errorf("encountered error when fetching a month's budget. err=%w", result.Error)
		}

		monthIndex := int(now.Sub(result.Month).Hours() / 24 / 30)
		results[monthIndex] = result
	}

	return results, nil
}
