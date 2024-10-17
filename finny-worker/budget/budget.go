package budget

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"slices"

	"github.com/google/uuid"
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

type Budget struct {
	CategoryGroups []CategoryGroup `json:"category_groups"`
}

type CategoryGroup struct {
	Categories []Category `json:"categories"`
}

type Category struct {
	Activity          float64 `json:"activity"`
	CategoryGroupName string  `json:"category_group_name"`
	Name              string  `json:"name"`
}

type BudgetJson struct {
	Data Budget `json:"data"`
}

type BudgetSQL struct {
	Data Budget `json:"data"`
}

type YNABInflowOutflow struct {
	outflow float64
	inflow  float64
}

func (b *BudgetService) CalculateSpending(budget *Budget, ignoredCategories []string) (YNABInflowOutflow, error) {
	var positiveCategorySum float64
	var negativeCategorySum float64

	for _, group := range budget.CategoryGroups {
		for _, category := range group.Categories {
			if category.Activity > 0.0 {
				if !slices.Contains(ignoredCategories, category.CategoryGroupName) {
					positiveCategorySum += category.Activity
				}
			} else {
				negativeCategorySum += category.Activity
			}
		}
	}

	actualInflow := positiveCategorySum / 1000.0
	actualOutflow := negativeCategorySum / 1000.0

	return YNABInflowOutflow{
		outflow: actualOutflow,
		inflow:  actualInflow,
	}, nil
}

func (b *BudgetService) FromFile(path string) (*Budget, error) {
	jsonData, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}

	var budget BudgetJson
	err = json.Unmarshal(jsonData, &budget)
	if err != nil {
		return nil, err
	}

	return &Budget{
		CategoryGroups: budget.Data.CategoryGroups,
	}, nil
}

func (b *BudgetService) FromDatabase(userID uuid.UUID) (*Budget, error) {
	var result struct {
		CategoriesJSON []byte `gorm:"column:categories_json"`
	}

	err := b.db.Table("ynab_raw").
		Select("categories_json").
		Where("user_id = ?", userID).
		First(&result).Error

	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, fmt.Errorf("no budget found for user ID %s", userID)
		}
		return nil, err
	}

	categoriesJSON := result.CategoriesJSON

	var budgetSQL BudgetSQL
	err = json.Unmarshal(categoriesJSON, &budgetSQL)
	if err != nil {
		return nil, err
	}

	return &Budget{
		CategoryGroups: budgetSQL.Data.CategoryGroups,
	}, nil
}
