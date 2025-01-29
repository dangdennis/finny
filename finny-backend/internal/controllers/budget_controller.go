package controllers

import (
	"net/http"

	"github.com/finny/finny-backend/internal/budget"
	"github.com/labstack/echo/v4"
)

type BudgetController struct {
	budgetService *budget.BudgetService
}

func NewBudgetController(budgetSvc *budget.BudgetService) *BudgetController {
	return &BudgetController{
		budgetService: budgetSvc,
	}
}

func (b *BudgetController) GetExpense(c echo.Context) error {
	// Parse the user's access token for their Supabase user id.
	// Use the user id to fetch the user's budget data from the database.
	// Compute the user's expenses for the last 12 months.
	// Return the user's expenses as a JSON response
	return c.JSON(http.StatusOK, map[string]interface{}{
		// your response data here
	})
}
