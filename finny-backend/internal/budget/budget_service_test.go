package budget

import (
	"crypto/rand"
	"testing"

	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_client"
	"gorm.io/gorm"
)

func TestBudgetService(t *testing.T) {
	t.Run("CalculateExpenseFromCategories", func(t *testing.T) {
		t.Run("should get expense from ynab budget", func(t *testing.T) {
			ynabClient, err := ynab_client.NewYNABClient("x")
			if err != nil {
				t.Fatalf("failed to create ynab client: %v", err)
			}

			categories, err := ynabClient.ReadCategoriesFromFile("categories_fixture.json")
			if err != nil {
				t.Fatalf("failed to read categories from file: %v", err)
			}

			db := &gorm.DB{}
			ynabAuthService, err := ynab_auth.NewYNABAuthService(rand.Reader, db)
			if err != nil {
				t.Fatalf("failed to create ynab auth service: %v", err)
			}
			budgetSvc, err := NewBudgetService(db, ynabAuthService)
			if err != nil {
				t.Fatalf("failed to create budget service: %v", err)
			}

			totalExpense := budgetSvc.CalculateExpenseFromCategories(categories)
			if err != nil {
				t.Fatalf("failed to get expense from ynab: %v", err)
			}

			t.Logf("total expense: %d", totalExpense)
			if totalExpense != 3899 {
				t.Fatalf("expected total expense to be -8101300, got %d", totalExpense)
			}
		})
	})

	t.Run("FetchLast12MonthsBudgets", func(t *testing.T) {
		// todo(rani): mock out YNAB.
		// we want to test that we fetching the last 12 months of budgets.
		// we want to test what what happens when we have less than 12 months of budgets.
		// we want to test what happens if we failed to fetch one of the budgets.
		t.SkipNow()
	})
}
