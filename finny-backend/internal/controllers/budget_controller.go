package controllers

import (
	"net/http"

	"github.com/finny/finny-backend/internal/budget"
)

type BudgetController struct {
	budgetService *budget.BudgetService
}

func NewBudgetController(budgetSvc *budget.BudgetService) *BudgetController {
	return &BudgetController{
		budgetService: budgetSvc,
	}
}

func (b *BudgetController) GetExpense(w http.ResponseWriter, r *http.Request) {
	// Parse the user's access token for their Supabase user id.
	// Use the user id to fetch the user's budget data from the database.
	// Compute the user's expenses for the last 12 months.
	// Return the user's expenses as a JSON response.
}
