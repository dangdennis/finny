package budget

import (
	"context"
	"os"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_client"
	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/google/uuid"
	"github.com/joho/godotenv"
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
    if m.simulateNetworkError {
		return nil, &NetworkError{Message: "Simulated network error"}
	}
	if m.simulateNotFoundError {
		return nil, &NotFoundError{Message: "Simulated not found error"}
	}
	
    mockBudget := ynab_openapi.BudgetDetail{  
        Id: uuid.New(),
        Name: "Test Budget",
    }
    
    response := &ynab_openapi.BudgetDetailResponse{}
    response.Data.Budget = mockBudget  
    
    return response, nil
}

func (m *MockYNABClient) GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error) {
    return &ynab_openapi.CategoriesResponse{}, nil 
}


func setupBudgetServiceWithMockClient(simulateNetworkError bool, simulateNotFoundError bool) (*BudgetService, error){
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
		_, err := setupBudgetServiceWithMockClient(true, false)
		assert.Error(t, err)
		assert.IsType(t, &NetworkError{}, err)
	})

	t.Run("Should return not found error when fetching avg expense", func(t *testing.T){
		_, err := setupBudgetServiceWithMockClient(false, true)
		assert.Error(t, err)
		assert.IsType(t, &NotFoundError{}, err)
	})

	t.Run("Should calculate average expense successfully with full data", func(t *testing.T){
		budgetSvc, err := setupBudgetServiceWithMockClient(false, false)
		assert.NoError(t, err)
		avgExpense, err := budgetSvc.GetAnnualAverageExpenseFromYNAB()
		assert.NoError(t, err)
		assert.GreaterOrEqual(t, avgExpense, int64(0))
	})

	t.Run("Should fetch last 12 months and calculate average", func(t *testing.T) {
		budgetSvc, err := setupBudgetServiceWithMockClient(false, false)
		assert.NoError(t, err)
		budgets, err := budgetSvc.FetchLast12MonthsDetails(budgetSvc.ynabClient)
		assert.NoError(t, err)
		assert.Equal(t, 12, len(budgets))
		categories := mockCategories()
		avgExpense := budgetSvc.CalculateExpenseFromCategories(categories)
		assert.LessOrEqual(t, avgExpense, int64(0))
	})

	t.Run("Should handle NotFoundError when fetching last 12 months", func(t *testing.T){
		budgetSvc, err := setupBudgetServiceWithMockClient(false, true)
		assert.NoError(t,err)
		budgets, err := budgetSvc.FetchLast12MonthsDetails(budgetSvc.ynabClient)
		assert.Error(t, err)
		assert.Less(t, len(budgets), 12)
		categories := mockCategories()
		avgExpense := budgetSvc.CalculateExpenseFromCategories(categories)
		assert.LessOrEqual(t, avgExpense, int64(0))
	})

	t.Run("Should handle NetworkError when fetching last 12 months", func(t *testing.T){
		budgetSvc, err := setupBudgetServiceWithMockClient(true, false)
		assert.NoError(t, err)
		var fetchErr error
		_, fetchErr = budgetSvc.FetchLast12MonthsDetails(budgetSvc.ynabClient)
		assert.Error(t, fetchErr)
		assert.IsType(t, &NetworkError{}, fetchErr)
	})

}

func TestMain(m *testing.M) {
    if err := godotenv.Load("../../.env"); err != nil {
        panic("Error loading .env file: " + err.Error())
    }
    os.Exit(m.Run())
}

func TestBudgetServiceIntegration(t *testing.T) {
    if testing.Short() {
        t.Skip("Skipping integration test")
    }

    accessToken := os.Getenv("YNAB_PERSONAL_ACCESS_TOKEN")
    if accessToken == "" {
        t.Fatal("YNAB_PERSONAL_ACCESS_TOKEN environment variable is required")
    }

    ynabClient, err := ynab_client.NewYNABClient(accessToken)
    if err != nil {
        t.Fatalf("Failed to create YNAB client: %v", err)
    }

    ynabAuthService := &ynab_auth.YNABAuthService{}
    budgetSvc, err := NewBudgetService(ynabAuthService, ynabClient)
    if err != nil {
        t.Fatalf("Failed to create budget service: %v", err)
    }

    t.Run("Should fetch real budget data from YNAB", func(t *testing.T) {
        avgExpense, err := budgetSvc.GetAnnualAverageExpenseFromYNAB()
        if err != nil {
            if _, ok := err.(*NotFoundError); ok {
                t.Logf("Successfully confirmed no data in YNAB account: %v", err)
                return
            }
            t.Fatalf("Unexpected error getting annual average expense: %v", err)
        }
        assert.NotZero(t, avgExpense, "Average expense should not be zero when data exists")
    })

    t.Run("Should fetch last 12 months of budget data", func(t *testing.T) {
        budgets, err := budgetSvc.FetchLast12MonthsDetails(ynabClient)
        if err != nil {
            if _, ok := err.(*NotFoundError); ok {
                t.Logf("Successfully confirmed no data in YNAB account: %v", err)
                return
            }
            t.Fatalf("Unexpected error fetching last 12 months: %v", err)
        }
        assert.Equal(t, 12, len(budgets), "Should fetch exactly 12 months of data when data exists")
        t.Logf("Successfully fetched %d months of budget data", len(budgets))
    })
}