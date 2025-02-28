package ynab_client

import (
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/oapi-codegen/runtime/types"
)

const (
	baseURL = "https://api.ynab.com/v1"
)

type YNAB interface {
	GetLatestBudget(ctx context.Context) (*ynab_openapi.BudgetDetailResponse, error)
	GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error)
	GetMonthDetail(ctx context.Context, budgetID string, month time.Time) (*ynab_openapi.MonthDetail, error)
}

type YNABClient struct {
	accessToken string
	client      *ynab_openapi.ClientWithResponses
}

var _ YNAB = (*YNABClient)(nil)

func NewYNABClient(accessToken string) (YNAB, error) {
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

func (y *YNABClient) GetMonthDetail(ctx context.Context, budgetID string, month time.Time) (*ynab_openapi.MonthDetail, error) {
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
