package budget

import (
	"testing"
)

// todo(rani): write tests for budget service
func TestBudgetService(t *testing.T) {
	// step 1: how to get a mock yet realistic Budget from YNAB.
	// Does not need to actually call YNAB'S API for the budget data. We should have a local, immutable copy of a budget.

	// c := ynab.NewClient(pat)

	// step 2: calculate the expenses from the budget
	// result, _ := budgetService.CalculateCashflow(&budget, ignoredCategories)
}
