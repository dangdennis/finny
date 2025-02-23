package budget

import (
	"context"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/stretchr/testify/assert"
)

//because we are injecting a ynab in our service
//we have to create a mock of ynab to control
//if there is a network error or data not found error
type MockYNABClient struct{
	simulateNetworkError bool
	simulateNotFoundError bool
}

func (m *MockYNABClient) GetMonthDetail(ctx context.Context, budgetID string, month time.Time) (*ynab_openapi.MonthDetail, error){
	if m.simulateNetworkError{
		return nil, &NetworkError{Message: "Simulated network error"}
	}
	if m.simulateNotFoundError{
		return nil, &NotFoundError{Message: "Simulated not found error"}
	}

	return &ynab_openapi.MonthDetail{}, nil
}

func (m *MockYNABClient) GetLatestBudget(ctx context.Context) (*ynab_openapi.BudgetDetailResponse, error) {
    return &ynab_openapi.BudgetDetailResponse{}, nil 
}

func (m *MockYNABClient) GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error) {
    return &ynab_openapi.CategoriesResponse{}, nil 
}


func setupBudgetServiceWithMockClient(simulateNetworkError bool, simulateNotFoundError bool) *BudgetService{
	mockClient := &MockYNABClient{
		simulateNetworkError: simulateNetworkError,
		simulateNotFoundError: simulateNotFoundError,
	}
	ynabAuthService := &ynab_auth.YNABAuthService{}
	return NewBudgetService(ynabAuthService, mockClient)
}

func mockCategories() []ynab_openapi.Category{
	return []ynab_openapi.Category{
		{
            Name:            "Groceries",
            Activity:        5000, 
            CategoryGroupName: &[]string{"Monthly Expenses"}[0],
        },
        {
            Name:            "Utilities",
            Activity:        2000,
            CategoryGroupName: &[]string{"Monthly Expenses"}[0],
        },
        {
            Name:            "Credit Card Payments",
            Activity:        1000,
            CategoryGroupName: &[]string{"Monthly Expenses"}[0],
        },
    }
	}

		


func TestBudgetService(t *testing.T) {
	t.Run("Should return network error when fetching avg expense", func(t *testing.T){
		budgetSvc := setupBudgetServiceWithMockClient(true, false)
		_, err := budgetSvc.GetAnnualAverageExpenseFromYNAB()
		assert.Error(t, err)
		assert.IsType(t, &NetworkError{}, err)
	})

	t.Run("Should return not found error when fetching avg expense", func(t *testing.T){
		budgetSvc := setupBudgetServiceWithMockClient(false, true)
		_, err := budgetSvc.GetAnnualAverageExpenseFromYNAB()
		assert.Error(t, err)
		assert.IsType(t, &NotFoundError{}, err)
	})

	t.Run("Should calculate average expense successfully with full data", func(t *testing.T){
		budgetSvc := setupBudgetServiceWithMockClient(false, false)
		avgExpense, err := budgetSvc.GetAnnualAverageExpenseFromYNAB()
		assert.NoError(t, err)
		assert.GreaterOrEqual(t, avgExpense, int64(0))
	})

	t.Run("Should fetch last 12 months and calculate average", func(t *testing.T) {
		budgetSvc := setupBudgetServiceWithMockClient(false, false)
		budgets, err := budgetSvc.FetchLast12MonthsDetails(budgetSvc.ynabClient)
		assert.NoError(t, err)
		assert.Equal(t, 12, len(budgets))
		categories := mockCategories()
		avgExpense := budgetSvc.CalculateExpenseFromCategories(categories)
		assert.LessOrEqual(t, avgExpense, int64(0))
	})

	t.Run("Should handle NotFoundError when fetching last 12 months", func(t *testing.T){
		budgetSvc := setupBudgetServiceWithMockClient(false, true)
		budgets, err := budgetSvc.FetchLast12MonthsDetails(budgetSvc.ynabClient)
		assert.Error(t, err)
		assert.Less(t, len(budgets), 12)
		categories := mockCategories()
		avgExpense := budgetSvc.CalculateExpenseFromCategories(categories)
		assert.LessOrEqual(t, avgExpense, int64(0))
	})

	t.Run("Should handle NetworkError when fetching last 12 months", func(t *testing.T){
		budgetSvc := setupBudgetServiceWithMockClient(true, false)
		_, err := budgetSvc.FetchLast12MonthsDetails(budgetSvc.ynabClient)
		assert.Error(t, err)
		assert.IsType(t, &NetworkError{}, err)
	})

}


