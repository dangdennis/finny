package ynab_client

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/finny/finny-backend/internal/ynab_openapi"
)

type MonthBudget struct {
	Month  time.Time
	Budget *ynab_openapi.BudgetDetailResponse
	Error  error
}


func (y *YNABClient) FetchMonthlyBudgets(ctx context.Context) []MonthBudget {
	var wg sync.WaitGroup
	results := make([]MonthBudget, 12)
	

	budgetChan := make(chan MonthBudget, 12)
	

	now := time.Now()
	

	for i := 0; i < 12; i++ {
		wg.Add(1)
		go func(monthsAgo int) {
			defer wg.Done()
			

			targetMonth := now.AddDate(0, -monthsAgo, 0)
			
			// Insert your YNAB API endpoint URL here
			// Example: fmt.Sprintf("https://api.ynab.com/v1/budgets/last-used/months/%s", targetMonth.Format("2006-01"))
			
			budget, err := y.GetLatestBudget(ctx)
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

		monthDiff := int(now.Sub(result.Month).Hours() / 24 / 30)
		if monthDiff < 12 {
			results[monthDiff] = result
		}
	}
	
	return results
}


func ProcessBudgetResults(results []MonthBudget) error {
	for _, result := range results {
		if result.Error != nil {
			return fmt.Errorf("error fetching budget for %s: %w", 
				result.Month.Format("2006-01"), result.Error)
		}
		
		// Process successful results here
		// You can access the budget data via result.Budget
	}
	
	return nil
}
