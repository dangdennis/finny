package ynab_client

import (
	"context"
	"fmt"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/oapi-codegen/runtime/types"
)

type mockYNABAPI struct {
	monthBudgets map[string]*ynab_openapi.MonthDetail
	err          error
}

func newMockYNABAPI() *mockYNABAPI {
	return &mockYNABAPI{
		monthBudgets: make(map[string]*ynab_openapi.MonthDetail),
	}
}

func (m *mockYNABAPI) GetBudgetMonthWithResponse(ctx context.Context, budgetID string, date types.Date, reqEditors ...ynab_openapi.RequestEditorFn) (*ynab_openapi.GetBudgetMonthResponse, error) {
	if m.err != nil {
		return nil, m.err
	}
	monthKey := date.Time.Format("2006-01")
	budget, exists := m.monthBudgets[monthKey]
	if !exists {
		return nil, fmt.Errorf("no budget for month %s", monthKey)
	}
	return &ynab_openapi.GetBudgetMonthResponse{
		JSON200: &ynab_openapi.MonthDetailResponse{
			Data: struct {
				Month ynab_openapi.MonthDetail "json:\"month\""
			}{
				Month: *budget,
			},
		},
	}, nil
}

type FetchMonthlyBudgetResult struct {
	Budget *ynab_openapi.MonthDetail
	Error  error
	Month  types.Date
}

func TestFetchMonthlyBudgets(t *testing.T) {
	t.Run("should fetch all months with categories successfully", func(t *testing.T) {
		mock := newMockYNABAPI()
		now := time.Date(2025, 2, 1, 0, 0, 0, 0, time.UTC)

	
		testCategory := ynab_openapi.Category{
			Id:              types.UUID{}, 
			CategoryGroupId: types.UUID{}, 
			Name:           "Test Category",
			Budgeted:       100,
			Activity:       -50,
			Balance:        50,
			Hidden:         false,
			Deleted:        false,
		}

		for i := 0; i < 12; i++ {
			month := now.AddDate(0, -i, 0)
			monthStr := month.Format("2006-01")
			mock.monthBudgets[monthStr] = &ynab_openapi.MonthDetail{
				Month:      types.Date{Time: month},
				Income:     1000,
				Budgeted:   800,
				Activity:   -750,
				Deleted:    false,
				Categories: []ynab_openapi.Category{testCategory},
			}
		}

		fetcher := NewYNABBudgetFetcher(mock)
		results := fetcher.FetchMonthlyBudgets(context.Background())

		if len(results) != 12 {
			t.Errorf("expected 12 results, got %d", len(results))
		}

		for i, result := range results {
			if result.Error != nil {
				t.Errorf("unexpected error for month %d: %v", i, result.Error)
			}
			if result.Budget == nil {
				t.Errorf("expected budget for month %d, got nil", i)
			}
			
		
			expectedMonth := now.AddDate(0, -i, 0)
			if !result.Month.Equal(expectedMonth) {
				t.Errorf("month mismatch for index %d: expected %v, got %v", 
					i, expectedMonth, result.Month)
			}
			
			
			if result.Budget.Income != 1000 {
				t.Errorf("income mismatch for month %d: expected 1000, got %d", 
					i, result.Budget.Income)
			}

		
			if len(result.Budget.Categories) != 1 {
				t.Errorf("expected 1 category for month %d, got %d", 
					i, len(result.Budget.Categories))
			}

			cat := result.Budget.Categories[0]
			if cat.Name != "Test Category" {
				t.Errorf("category name mismatch for month %d: expected 'Test Category', got %s",
					i, cat.Name)
			}
			if cat.Budgeted != 100 {
				t.Errorf("category budget mismatch for month %d: expected 100, got %d",
					i, cat.Budgeted)
			}
		}
	})

	t.Run("should handle API errors", func(t *testing.T) {
		mock := newMockYNABAPI()
		mock.err = fmt.Errorf("API error")

		fetcher := NewYNABBudgetFetcher(mock)
		results := fetcher.FetchMonthlyBudgets(context.Background())

		if len(results) != 12 {
			t.Errorf("expected 12 results, got %d", len(results))
		}

		for i, result := range results {
			if result.Error == nil {
				t.Errorf("expected error for month %d, got nil", i)
			}
			if result.Budget != nil {
				t.Errorf("expected nil budget for month %d, got %v", i, result.Budget)
			}
		}
	})

	t.Run("should handle missing months", func(t *testing.T) {
		mock := newMockYNABAPI()
		now := time.Date(2025, 2, 1, 0, 0, 0, 0, time.UTC)

	
		for i := 0; i < 6; i++ {
			month := now.AddDate(0, -i, 0)
			monthStr := month.Format("2006-01")
			mock.monthBudgets[monthStr] = &ynab_openapi.MonthDetail{
				Month:    types.Date{Time: month},
				Income:   1000,
				Budgeted: 800,
				Activity: -750,
				Deleted:  false,
			}
		}

		fetcher := NewYNABBudgetFetcher(mock)
		results := fetcher.FetchMonthlyBudgets(context.Background())

		if len(results) != 12 {
			t.Errorf("expected 12 results, got %d", len(results))
		}

		
		for i := 0; i < 6; i++ {
			if results[i].Error != nil {
				t.Errorf("unexpected error for month %d: %v", i, results[i].Error)
			}
			if results[i].Budget == nil {
				t.Errorf("expected budget for month %d, got nil", i)
			}
		}

	
		for i := 6; i < 12; i++ {
			if results[i].Error == nil {
				t.Errorf("expected error for month %d, got nil", i)
			}
			if results[i].Budget != nil {
				t.Errorf("expected nil budget for month %d, got %v", i, results[i].Budget)
			}
		}
	})
}
