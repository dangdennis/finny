package budget

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"slices"
	"time"

	"github.com/brunomvsouza/ynab.go/api/category"
	"github.com/finny/worker/ynabclient"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type BudgetService struct {
	db   *gorm.DB
	ynab *ynabclient.YNABClient
}

func NewBudgetService(db *gorm.DB, ynab *ynabclient.YNABClient) *BudgetService {
	return &BudgetService{
		db:   db,
		ynab: ynab,
	}
}

func (b *BudgetService) GetAndCreateYNABData(db *gorm.DB, userID uuid.UUID) error {
	categories, err := b.ynab.GetCategories(userID, 0)
	if err != nil {
		return fmt.Errorf("failed to fetch categories: %w", err)
	}

	return b.CreateYNABData(db, userID, categories.GroupWithCategories, categories.ServerKnowledge)
}

func (b *BudgetService) CreateYNABData(db *gorm.DB, userID uuid.UUID, categories []*category.GroupWithCategories, serverKnowledge uint64) error {
	categoriesJson, err := json.Marshal(categories)
	if err != nil {
		return fmt.Errorf("failed to marshal categories: %w", err)
	}

	var ynabRaw YnabRaw
	result := db.Where("user_id = ?", userID).First(&ynabRaw)

	if result.Error == gorm.ErrRecordNotFound {
		ynabRaw = YnabRaw{
			UserID:                          userID,
			CategoriesJSON:                  categoriesJson,
			CategoriesLastUpdated:           time.Now(),
			CategoriesLastKnowledgeOfServer: int(serverKnowledge),
		}
		return db.Create(&ynabRaw).Error
	} else if result.Error != nil {
		return result.Error
	}

	ynabRaw.CategoriesJSON = categoriesJson
	ynabRaw.CategoriesLastUpdated = time.Now()
	ynabRaw.CategoriesLastKnowledgeOfServer = int(serverKnowledge)

	return db.Save(&ynabRaw).Error
}

func (b *BudgetService) CalculateCashflow(budget *Budget, ignoredCategories []string) (YNABInflowOutflow, error) {
	var positiveCategorySum float64
	var negativeCategorySum float64

	for _, group := range budget.CategoryGroups {
		for _, category := range group.Categories {
			if category.Activity > 0.0 {
				if !slices.Contains(ignoredCategories, group.Name) {
					positiveCategorySum += float64(category.Activity)
				}
			} else {
				negativeCategorySum += float64(category.Activity)
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

	var groupsWithCategories []category.GroupWithCategories
	err = json.Unmarshal(jsonData, &groupsWithCategories)
	if err != nil {
		return nil, err
	}

	return &Budget{
		CategoryGroups: groupsWithCategories,
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

	var groupsWithCategories []category.GroupWithCategories
	err = json.Unmarshal(result.CategoriesJSON, &groupsWithCategories)
	if err != nil {
		return nil, err
	}

	return &Budget{
		CategoryGroups: groupsWithCategories,
	}, nil
}

type Budget struct {
	CategoryGroups []category.GroupWithCategories
}

type YNABInflowOutflow struct {
	outflow float64
	inflow  float64
}
