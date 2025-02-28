package ynab_client

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/finny/finny-backend/internal/ynab_openapi"
)

func ReadCategoriesFromFile(filename string) ([]ynab_openapi.Category, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read categories file: %w", err)
	}

	var categoriesResponse ynab_openapi.CategoriesResponse
	err = json.Unmarshal(data, &categoriesResponse)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal categories JSON: %w", err)
	}

	var categoryList []ynab_openapi.Category
	for _, categoryGroup := range categoriesResponse.Data.CategoryGroups {
		categoryList = append(categoryList, categoryGroup.Categories...)
	}

	return categoryList, nil
}

func ReadMonthDetailsFromFile(filename string) (*ynab_openapi.MonthDetail, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read categories file: %w", err)
	}

	var monthDetail ynab_openapi.MonthDetail
	err = json.Unmarshal(data, &monthDetail)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal categories JSON: %w", err)
	}

	return &monthDetail, nil
}

func WriteBudgetToFile(budget *ynab_openapi.BudgetDetailResponse, filename string) error {
	jsonData, err := json.MarshalIndent(budget, "", "    ")
	if err != nil {
		return fmt.Errorf("failed to marshal budget to JSON: %w", err)
	}

	err = os.WriteFile(filename, jsonData, 0777)
	if err != nil {
		return fmt.Errorf("failed to write budget to file: %w", err)
	}

	return nil
}

func WriteCategoriesToFile(categories *ynab_openapi.CategoriesResponse, filename string) error {
	jsonData, err := json.MarshalIndent(categories, "", "    ")
	if err != nil {
		return fmt.Errorf("failed to marshal categories to JSON: %w", err)
	}

	err = os.WriteFile(filename, jsonData, 0777)
	if err != nil {
		return fmt.Errorf("failed to write categories to file: %w", err)
	}

	return nil
}

func WriteMonthDetailToFile(monthDetail ynab_openapi.MonthDetail, filename string) error {
	monthDetailJSON, err := json.Marshal(monthDetail)
	if err != nil {
		return fmt.Errorf("failed to marshal month detail to JSON: %w", err)
	}

	err = os.WriteFile("month_details.json", monthDetailJSON, 0777)
	if err != nil {
		return fmt.Errorf("failed to write month detail to file: %w", err)
	}

	return nil
}
