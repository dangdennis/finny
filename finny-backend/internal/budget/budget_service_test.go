package budget

import (
	"testing"

	"github.com/finny/finny-backend/internal/ynab_client"
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

			budgetSvc := NewBudgetService(nil)
			totalExpense := budgetSvc.CalculateExpenseFromCategories(categories)
			if err != nil {
				t.Fatalf("failed to get expense from ynab: %v", err)
			}

			t.Logf("total expense: %d", totalExpense)
			if totalExpense != -3899164 {
				t.Fatalf("expected total expense to be -8101300, got %d", totalExpense)
			}
		})
	})
}
