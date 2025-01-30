package budget

import (
	"testing"

	"github.com/finny/finny-backend/internal/ynab_client"
)

func TestBudgetService(t *testing.T) {
	t.Skip("GetExpenseFromYNAB", func(t *testing.T) {
		t.Run("should get expense from ynab budget", func(t *testing.T) {
			ynabClient, err := ynab_client.NewYNABClient("x")
			if err != nil {
				t.Fatalf("failed to create ynab client: %v", err)
			}

			budgetSvc := NewBudgetService(nil)
			totalExpense, err := budgetSvc.GetExpenseFromYNAB(ynabClient)
			if err != nil {
				t.Fatalf("failed to get expense from ynab: %v", err)
			}

			t.Logf("total expense: %d", totalExpense)
			if totalExpense != 1000 {
				t.Fatalf("expected total expense to be 1000, got %d", totalExpense)
			}
		})
	})
}
