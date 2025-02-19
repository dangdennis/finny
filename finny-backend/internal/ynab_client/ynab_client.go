package ynab_client

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/oapi-codegen/runtime/types"
)

const (
	baseURL = "https://api.ynab.com/v1"
)

type YNABClientIntf interface {
	GetLatestBudget(ctx context.Context) (*ynab_openapi.BudgetDetailResponse, error)
	GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error)
}

type YNABClient struct {
	accessToken string
	client      *ynab_openapi.ClientWithResponses
}

var _ YNABClientIntf = (*YNABClient)(nil)

func NewYNABClient(accessToken string) (*YNABClient, error) {
	httpDoer := &HttpDoer{
		accessToken: accessToken,
		client:      &http.Client{},
	}

	client, err := ynab_openapi.NewClientWithResponses(baseURL, ynab_openapi.WithHTTPClient(httpDoer))
	if err != nil {
		return nil, err
	}

	return &YNABClient{
		accessToken: accessToken,
		client:      client,
	}, nil
}

func (y *YNABClient) GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error) {
	categoriesResp, err := y.client.GetCategoriesWithResponse(ctx, "last-used", nil)
	if err != nil {
		return nil, fmt.Errorf("failed to make request for categories. err=%w", err)
	}

	if categoriesResp.JSON200 == nil {
		return nil, fmt.Errorf("failed to get categories. err=%w", err)
	}

	return categoriesResp.JSON200, nil
}

func (y *YNABClient) GetLatestBudget(ctx context.Context) (*ynab_openapi.BudgetDetailResponse, error) {
	budgetResp, err := y.client.GetBudgetByIdWithResponse(ctx, "last-used", nil)
	if err != nil {
		return nil, fmt.Errorf("failed to make request for budget. err=%w", err)
	}

	if budgetResp.JSON200 == nil {
		return nil, fmt.Errorf("failed to get budget. err=%w", err)
	}

	return budgetResp.JSON200, nil
}

func (y *YNABClient) WriteBudgetToFile(budget *ynab_openapi.BudgetDetailResponse, filename string) error {
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
func (y *YNABClient) WriteCategoriesToFile(categories *ynab_openapi.CategoriesResponse, filename string) error {
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

func (y *YNABClient) ReadCategoriesFromFile(filename string) (*ynab_openapi.CategoriesResponse, error) {
	data, err := os.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read categories file: %w", err)
	}

	var categories ynab_openapi.CategoriesResponse
	err = json.Unmarshal(data, &categories)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal categories JSON: %w", err)
	}

	return &categories, nil
}

func (y *YNABClient) GetBudgetByMonth(ctx context.Context, budgetID string, month time.Time) (*ynab_openapi.MonthDetail, error) {
	date := types.Date{Time: month}
	resp, err := y.client.GetBudgetMonthWithResponse(ctx, budgetID, date)
	if err != nil {
		return nil, fmt.Errorf("failed to get budget for month %s: %w", month.Format("2006-01"), err)
	}

	if resp.JSON200 == nil {
		return nil, fmt.Errorf("no budget data for month %s", month.Format("2006-01"))
	}

	return &resp.JSON200.Data.Month, nil
}
