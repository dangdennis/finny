package budget

import (
	"context"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/finny/finny-backend/internal/models"
	"github.com/finny/finny-backend/internal/ynab_auth"
	"github.com/finny/finny-backend/internal/ynab_client"
	"github.com/finny/finny-backend/internal/ynab_openapi"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestBudgetService(t *testing.T) {
	t.Run("CalculateExpenseFromCategories", func(t *testing.T) {
		t.Run("should get total expense from a month's details", func(t *testing.T) {
			monthDetails, err := ynab_client.ReadMonthDetailsFromFile("month_details.json")
			if err != nil {
				t.Fatalf("failed to read categories from file: %v", err)
			}

			budgetSvc, err := NewBudgetService(&ynab_auth.YNABAuthService{}, nil)
			assert.NoError(t, err)

			var categories []ynab_openapi.Category
			for _, category := range monthDetails.Categories {
				categories = append(categories, category)
			}

			totalExpense := budgetSvc.CalculateExpenseFromCategories(categories)
			assert.NoError(t, err)

			assert.Equal(t, int64(7599), totalExpense)
		})
	})

	t.Run("GetAnnualAverageExpenseFromYNAB", func(t *testing.T) {
		t.Run("Average annual expense should return network error if any", func(t *testing.T) {
			expectedErr := &NetworkError{Message: "Simulated network error"}
			budgetSvc, err := setupBudgetServiceWithMockClient(true, false, 1)
			assert.NoError(t, err)
			_, err = budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
			assert.Error(t, err)
			assert.Equal(t, expectedErr, err)
		})

		t.Run("Default to 0 if user doesn't have any budget data", func(t *testing.T) {
			budgetSvc, err := setupBudgetServiceWithMockClient(false, true, 12)
			assert.NoError(t, err)
			avgExp, err := budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
			assert.NoError(t, err)
			assert.LessOrEqual(t, avgExp, int64(0))
		})

		// t.Run("Should fetch last 12 months and calculate average, skipping any months that dont have data", func(t *testing.T) {
		// 	budgetSvc, err := setupBudgetServiceWithMockClient(false, true, 4)
		// 	assert.NoError(t, err)
		// 	avgExp, err := budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
		// 	assert.NoError(t, err)
		// 	assert.LessOrEqual(t, avgExp, int64(1231231123))
		// })
	})
}

type MockYNABClient struct {
	simulateNetworkError  bool
	simulateNotFoundError bool
	callCount             int
	numErrors             int
	mu                    sync.Mutex // To make it safe for concurrent access
}

type MockYNABAuthService struct {
	*ynab_auth.YNABAuthService
}

func (m *MockYNABAuthService) GetAccessToken(userID uuid.UUID) (models.YNABToken, error) {
	return models.YNABToken{
		AccessToken: "mock_token",
		ExpiresAt:   time.Now().Add(time.Hour),
	}, nil
}

func (m *MockYNABClient) GetMonthDetail(ctx context.Context, budgetID string, month time.Time) (*ynab_openapi.MonthDetail, error) {
	m.mu.Lock()
	m.callCount++
	m.mu.Unlock()

	// Simulate errors up to desired number of errors
	if m.numErrors > 0 {
		m.numErrors--
		if m.simulateNotFoundError {
			return nil, &NotFoundError{Message: "Simulated not found"}
		}

		return nil, &NetworkError{Message: "Simulated network error"}
	}

	monthDetail, err := ynab_client.ReadMonthDetailsFromFile("month_details.json")
	if err != nil {
		return nil, err
	}

	fmt.Println("monthDetail", monthDetail)

	return monthDetail, nil
}

func (m *MockYNABClient) GetLatestBudget(ctx context.Context) (*ynab_openapi.BudgetDetailResponse, error) {
	return nil, nil
}

func (m *MockYNABClient) GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error) {
	return &ynab_openapi.CategoriesResponse{}, nil
}

func setupBudgetServiceWithMockClient(simulateNetworkError bool, simulateNotFoundError bool, numErrors int) (*BudgetService, error) {
	mockClient := &MockYNABClient{
		simulateNetworkError:  simulateNetworkError,
		simulateNotFoundError: simulateNotFoundError,
		callCount:             0,
		numErrors:             numErrors,
	}

	mockAuthService := &MockYNABAuthService{
		YNABAuthService: &ynab_auth.YNABAuthService{},
	}

	return NewBudgetService(mockAuthService, func(string) (ynab_client.YNAB, error) {
		return mockClient, nil
	})
}
