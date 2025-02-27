package budget

import (
	"context"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/models"
	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_client"
	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

type MockYNABClient struct {
	simulateNetworkError  bool
	simulateNotFoundError bool
}

type MockYNABAuthService struct {
	*ynab_auth.YNABAuthService
}

func (m *MockYNABAuthService) GetAccessToken(userID uuid.UUID) (models.YNABToken, error) {
	return models.YNABToken{
		AccessToken: "mock_token",
		ExpiresAt:   time.Now().Add(time.Hour),
	}, nil
}

func (m *MockYNABClient) GetMonthDetail(ctx context.Context, budgetID string, month time.Time) (*ynab_openapi.MonthDetail, error) {
	if m.simulateNetworkError {
		return nil, &NetworkError{Message: "Simulated network error"}
	}
	if m.simulateNotFoundError {
		return nil, &NotFoundError{Message: "Simulated not found error"}
	}

	return &ynab_openapi.MonthDetail{
		Categories: mockCategories(),
	}, nil
}

func (m *MockYNABClient) GetLatestBudget(ctx context.Context) (*ynab_openapi.BudgetDetailResponse, error) {
	if m.simulateNetworkError {
		return nil, &NetworkError{Message: "Simulated network error"}
	}
	if m.simulateNotFoundError {
		return nil, &NotFoundError{Message: "Simulated not found error"}
	}

	mockBudget := ynab_openapi.BudgetDetail{
		Id:   uuid.New(),
		Name: "Test Budget",
	}

	response := &ynab_openapi.BudgetDetailResponse{}
	response.Data.Budget = mockBudget

	return response, nil
}

func (m *MockYNABClient) GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error) {
	return &ynab_openapi.CategoriesResponse{}, nil
}

func setupBudgetServiceWithMockClient(simulateNetworkError bool, simulateNotFoundError bool) (*BudgetService, error) {
	mockClient := &MockYNABClient{
		simulateNetworkError:  simulateNetworkError,
		simulateNotFoundError: simulateNotFoundError,
	}
	mockAuthService := &MockYNABAuthService{
		YNABAuthService: &ynab_auth.YNABAuthService{},
	}

	return NewBudgetService(mockAuthService, func(string) (ynab_client.YNAB, error) {
		return mockClient, nil
	})
}

func mockCategories() []ynab_openapi.Category {
	monthlyExpenses := "Monthly Expenses"
	internalMaster := "Internal Master Category"
	return []ynab_openapi.Category{
		{
			Name:              "Groceries",
			Activity:          -50000,
			CategoryGroupName: &monthlyExpenses,
		},
		{
			Name:              "Utilities",
			Activity:          -20000,
			CategoryGroupName: &monthlyExpenses,
		},
		{
			Name:              "Credit Card Payments",
			Activity:          -10000,
			CategoryGroupName: &monthlyExpenses,
		},
		{
			Name:              "Internal Transfer",
			Activity:          -5000,
			CategoryGroupName: &internalMaster,
		},
	}
}

func TestBudgetService(t *testing.T) {
	t.Run("Should return network error when fetching avg expense", func(t *testing.T) {
		expectedErr := &NetworkError{Message: "Simulated network error"}
		budgetSvc, err := setupBudgetServiceWithMockClient(true, false)
		assert.NoError(t, err)
		_, err = budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
		assert.Error(t, err)
		assert.Equal(t, expectedErr, err)
	})

	//    t.Run("Should return not found error when fetching avg expense", func(t *testing.T) {
	// 	expectedErr := &NotFoundError{Message: "Simulated not found error"}
	// 	budgetSvc, err := setupBudgetServiceWithMockClient(false, true)
	// 	assert.NoError(t, err)
	// 	_, err = budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
	// 	assert.Error(t, err)
	// 	assert.Equal(t, expectedErr, err)
	//    })

	// t.Run("Should calculate average expense successfully with full data", func(t *testing.T){
	// 	budgetSvc, err := setupBudgetServiceWithMockClient(false, false)
	// 	assert.NoError(t, err)
	// 	avgExpense, err := budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
	// 	assert.NoError(t, err)
	// 	assert.LessOrEqual(t, avgExpense, int64(0))
	// })

	// t.Run("Should fetch last 12 months and calculate average", func(t *testing.T) {
	//        budgetSvc, err := setupBudgetServiceWithMockClient(false, false)
	//        assert.NoError(t, err)
	//        ynabClient, err := budgetSvc.ynabClientProvider("")
	//        assert.NoError(t, err)
	//        budgets, err := budgetSvc.FetchLast12MonthsDetails(ynabClient)
	//        assert.NoError(t, err)
	//        assert.Equal(t, 12, len(budgets))
	//        categories := mockCategories()
	//        avgExpense := budgetSvc.CalculateExpenseFromCategories(categories)
	//        assert.LessOrEqual(t, avgExpense, int64(0))
	// })

	// t.Run("Should handle NotFoundError when fetching last 12 months", func(t *testing.T){
	// 	expectedErr := &NotFoundError{Message: "Simulated not found error"}
	// 	budgetSvc, err := setupBudgetServiceWithMockClient(false, true)
	// 	assert.NoError(t, err)
	// 	ynabClient, err := budgetSvc.ynabClientProvider("")
	// 	assert.NoError(t, err)
	// 	budgets, err := budgetSvc.FetchLast12MonthsDetails(ynabClient)
	// 	assert.Error(t, err)
	// 	assert.Equal(t, expectedErr, err)
	// 	assert.Empty(t, budgets)
	// })

	// t.Run("Should handle NetworkError when fetching last 12 months", func(t *testing.T){
	// 	expectedErr := &NetworkError{Message: "Simulated network error"}
	// 	budgetSvc, err := setupBudgetServiceWithMockClient(true, false)
	// 	assert.NoError(t, err)
	// 	ynabClient, err := budgetSvc.ynabClientProvider("")
	// 	assert.NoError(t, err)
	// 	budgets, err := budgetSvc.FetchLast12MonthsDetails(ynabClient)
	// 	assert.Error(t, err)
	// 	assert.Equal(t, expectedErr, err)
	// 	assert.Empty(t, budgets)
	// })

}
