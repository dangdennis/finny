package budget

import (
	"testing"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_client"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

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
