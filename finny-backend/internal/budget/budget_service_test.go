package budget

import (
	"context"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_client"
	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/google/uuid"
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


func TestBudgetService(t *testing.T) {
	// t.Run("CalculateExpenseFromCategories", func(t *testing.T) {
	// 	t.Run("should get expense from ynab budget", func(t *testing.T) {
	// 		ynabClient, err := ynab_client.NewYNABClient("x")
	// 		if err != nil {
	// 			t.Fatalf("failed to create ynab client: %v", err)
	// 		}

	// 		categories, err := ynabClient.ReadCategoriesFromFile("categories_fixture.json")
	// 		if err != nil {
	// 			t.Fatalf("failed to read categories from file: %v", err)
	// 		}

	// 		db := &gorm.DB{}
	// 		ynabAuthService, err := ynab_auth.NewYNABAuthService(rand.Reader, db)
	// 		if err != nil {
	// 			t.Fatalf("failed to create ynab auth service: %v", err)
	// 		}
	// 		budgetSvc, err := NewBudgetService(db, ynabAuthService)
	// 		if err != nil {
	// 			t.Fatalf("failed to create budget service: %v", err)
	// 		}

	// 		totalExpense := budgetSvc.CalculateExpenseFromCategories(categories)
	// 		if err != nil {
	// 			t.Fatalf("failed to get expense from ynab: %v", err)
	// 		}

	// 		t.Logf("total expense: %d", totalExpense)
	// 		if totalExpense != 3899 {
	// 			t.Fatalf("expected total expense to be -8101300, got %d", totalExpense)
	// 		}
	// 	})
	// })
	//

	t.Run("GetAnnualAverageExpenseFromYNAB", func(t *testing.T) {
		// todo(rani): mock out YNAB.
		// we want to test that we fetching the last 12 months of budgets.
		// we want to test what what happens when we have less than 12 months of budgets.
		// we want to test what happens if we failed to fetch one of the budgets.
		//

		// 1. mock out ynabauthservice
		// 2. mock out ynabclient provider

		mockYnabAuthService := &ynab_auth.YNABAuthService{}

		budgetService, err := NewBudgetService(mockYnabAuthService, mockClientProvider)
		assert.NoError(t, err)

		totalavgExpense, err := budgetService.GetAnnualAverageExpenseFromYNAB(uuid.MustParse("2c84e471-d9e0-464d-88c4-a496be29c910"))
		assert.NoError(t, err)

		assert.Equal(t, int64(0), totalavgExpense)

		t.SkipNow()
	})
}

func mockClientProvider(accessToken string) (ynab_client.YNAB, error) {
	// return a mock client
	//
	return nil, nil
}
