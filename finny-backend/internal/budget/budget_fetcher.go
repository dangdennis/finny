package budget

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/oapi-codegen/runtime/types"
)

type YNABAPIClient interface {
	GetBudgetMonthWithResponse(ctx context.Context, budgetID string, date types.Date, reqEditors ...ynab_openapi.RequestEditorFn) (*ynab_openapi.GetBudgetMonthResponse, error)
}

type MonthBudget struct {
	Month  time.Time
	Budget *ynab_openapi.MonthDetail
	Error  error
}

type YNABBudgetFetcher struct {
	client YNABAPIClient
}

func NewYNABBudgetFetcher(client YNABAPIClient) *YNABBudgetFetcher {
	return &YNABBudgetFetcher{
		client: client,
	}
}

func (y *YNABBudgetFetcher) FetchMonthlyBudgets(ctx context.Context) []MonthBudget {
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
			budget, err := y.GetBudgetByMonth(ctx, "last-used", targetMonth)
			result := MonthBudget{
				Month:  targetMonth,
				Budget: budget,
				Error:  err,
			}
			budgetChan <- result
		}(i)
	}

	go func() {
		wg.Wait()
		close(budgetChan)
	}()

	for result := range budgetChan {
		monthIndex := int(now.Sub(result.Month).Hours() / 24 / 30)
		results[monthIndex] = result
	}

	return results
}

func (y *YNABBudgetFetcher) GetBudgetByMonth(ctx context.Context, budgetID string, month time.Time) (*ynab_openapi.MonthDetail, error) {
	date := types.Date{Time: month}
	resp, err := y.client.GetBudgetMonthWithResponse(ctx, budgetID, date)
	if err != nil {
		return nil, fmt.Errorf("failed to get budget for month %s: %w", month.Format("2006-01"), err)
	}

	if resp.JSON200 == nil {
		return nil, fmt.Errorf("no budget data for month %s", month.Format("2006-01"))
	}

	return &resp.JSON200.Data.Month, nil
}
