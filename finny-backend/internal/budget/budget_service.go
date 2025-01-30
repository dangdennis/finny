package budget

import (
	"context"

	"github.com/finny/finny-backend/internal/ynab_client"
	"github.com/finny/finny-backend/internal/ynab_openapi"
	"gorm.io/gorm"
)

type BudgetService struct {
	db *gorm.DB
}

func NewBudgetService(db *gorm.DB) *BudgetService {
	return &BudgetService{
		db: db,
	}
}

func (b *BudgetService) GetExpenseFromYNAB(ynab ynab_client.YNABClientIntf) (int64, error) {
	ctx := context.Background()
	categories, err := ynab.GetLatestCategories(ctx)
	if err != nil {
		return 0, err
	}

	return b.CalculateExpenseFromCategories(categories), nil
}

func (b *BudgetService) CalculateExpenseFromCategories(categories *ynab_openapi.CategoriesResponse) int64 {
	var totalExpense int64
	for _, cg := range *&categories.Data.CategoryGroups {
		if cg.Name == "Credit Card Payments" {
			continue
		}

		if cg.Name == "Hidden Categories" {
			continue
		}

		for _, c := range cg.Categories {
			if *c.CategoryGroupName == "Internal Master Category" && c.Name != "Uncategorized" {
				continue
			}

			totalExpense += c.Activity
		}
	}

	return totalExpense
}
