package controllers

import (
	"fmt"
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
	userID, err := GetContextUserID(c)
	if err != nil {
		fmt.Printf("Failed to get user ID from context: %v\n", err)
		return c.String(http.StatusBadRequest, "User not authenticated")
	}

	expenseTotal, err := b.budgetService.GetCurrentMonthExpenseFromYNAB(userID)
	if err != nil {
		fmt.Printf("Failed to get current month expense from YNAB: %v\n", err)
		return c.String(http.StatusBadRequest, "Failed to get current expense")
	}

	return c.JSON(http.StatusOK, map[string]interface{}{
		"expense": expenseTotal,
	})
}
