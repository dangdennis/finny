package budget

import (
	"context"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/oapi-codegen/runtime/types"
	"github.com/stretchr/testify/assert"
)

type mockYNABClient struct {
	monthDetails map[string]*ynab_openapi.MonthDetail
	err          error
}

func (m *mockYNABClient) GetBudgetMonthWithResponse(ctx context.Context, budgetID string, date types.Date, reqEditors ...ynab_openapi.RequestEditorFn) (*ynab_openapi.GetBudgetMonthResponse, error) {
	if m.err != nil {
		return nil, m.err
	}

	monthKey := date.Time.Format("2006-01")
	monthDetail, exists := m.monthDetails[monthKey]
	if !exists {
		return &ynab_openapi.GetBudgetMonthResponse{}, nil
	}

	return &ynab_openapi.GetBudgetMonthResponse{
		JSON200: &ynab_openapi.MonthDetailResponse{
			Data: struct {
				Month ynab_openapi.MonthDetail `json:"month"`
			}{
				Month: *monthDetail,
			},
		},
	}, nil
}

func TestFetchMonthlyBudgets(t *testing.T) {
	mockClient := &mockYNABClient{
		monthDetails: map[string]*ynab_openapi.MonthDetail{},
	}

	now := time.Now().UTC()
	for i := 0; i < 12; i++ {
		targetMonth := now.AddDate(0, -i, 0)
		monthKey := targetMonth.Format("2006-01")
		mockClient.monthDetails[monthKey] = &ynab_openapi.MonthDetail{}
	}

	fetcher := NewYNABBudgetFetcher(mockClient)
	results := fetcher.FetchMonthlyBudgets(context.Background())

	assert.Len(t, results, 12)
	for _, result := range results {
		assert.NoError(t, result.Error)
		assert.NotNil(t, result.Budget)
	}
}
