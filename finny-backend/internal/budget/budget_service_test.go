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

			assert.Equal(t, int64(8319), totalExpense)
		})
	})

	t.Run("GetAnnualAverageExpenseFromYNAB", func(t *testing.T) {
		t.Run("Average annual expense should return network error if any one of the calls fail", func(t *testing.T) {
			expectedErr := &NetworkError{Message: "Simulated network error"}
			budgetSvc, err := setupBudgetServiceWithMockClient(true, false, 1, 0) // One call will fail with a NetworkError
			assert.NoError(t, err)
			_, err = budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
			assert.Error(t, err)
			assert.Equal(t, expectedErr, err)
		})

		t.Run("Default to 0 if user doesn't have any budget data", func(t *testing.T) {
			budgetSvc, err := setupBudgetServiceWithMockClient(false, true, 12, 0) // All 12 calls to get month details will return a NotFoundError
			assert.NoError(t, err)
			avgExp, err := budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
			assert.NoError(t, err)
			assert.Equal(t, avgExp, int64(0))
		})

		t.Run("Should fetch last 12 months and calculate annual expense average, skipping any months that dont have data", func(t *testing.T) {
			budgetSvc, err := setupBudgetServiceWithMockClient(false, true, 6, 2) // Skip 6 months, so get average of 6 months then mult by 12 for annual average
			assert.NoError(t, err)
			avgExp, err := budgetSvc.GetAnnualAverageExpenseFromYNAB(uuid.UUID{})
			assert.NoError(t, err)
			assert.Equal(t, avgExp, int64(191028))
		})
	})
}

// todo(dennis): This mock API is not nice and should be refactored such that we can have more control over
// how each ynabclient method behaves without having to append more and more fields here.
type MockYNABClient struct {
	simulateNetworkError  bool
	simulateNotFoundError bool
	callCount             int
	numErrors             int
	// expenseMultFactor is a multiplier used to change the total expense calculated from GetMonthDetail for more variation.
	expenseMultFactor int
	monthDetailMutex  sync.Mutex
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
	m.monthDetailMutex.Lock()
	defer m.monthDetailMutex.Unlock()

	m.callCount++

	expenseMultFactor := m.expenseMultFactor
	if m.expenseMultFactor > 0 {
		m.expenseMultFactor++
	}

	// Simulate errors up to desired number of errors
	if m.simulateNetworkError {
		if m.numErrors > 0 {
			m.numErrors--
			return nil, &NetworkError{Message: "Simulated network error"}
		}
	} else if m.simulateNotFoundError {
		if m.numErrors > 0 {
			m.numErrors--
			return nil, &NotFoundError{Message: "Simulated not found"}
		}
	}

	monthDetail, err := ynab_client.ReadMonthDetailsFromFile("month_details.json")
	if err != nil {
		return nil, err
	}

	if expenseMultFactor > 0 {
		// We change the category in the 7th index pos because it just happens to be the first expense-contributing category.
		monthDetail.Categories[7].Activity = monthDetail.Categories[7].Activity * int64(expenseMultFactor)
		fmt.Println("monthDetail.Categories[7].Activity - expenseMultFactor", monthDetail.Categories[7].Activity, expenseMultFactor)
	}

	return monthDetail, nil
}

func (m *MockYNABClient) GetLatestBudget(ctx context.Context) (*ynab_openapi.BudgetDetailResponse, error) {
	return nil, nil
}

func (m *MockYNABClient) GetLatestCategories(ctx context.Context) (*ynab_openapi.CategoriesResponse, error) {
	return &ynab_openapi.CategoriesResponse{}, nil
}

func setupBudgetServiceWithMockClient(simulateNetworkError bool, simulateNotFoundError bool, numErrors int, expenseVarianceFactor int) (*BudgetService, error) {
	mockClient := &MockYNABClient{
		simulateNetworkError:  simulateNetworkError,
		simulateNotFoundError: simulateNotFoundError,
		callCount:             0,
		numErrors:             numErrors,
		expenseMultFactor:     expenseVarianceFactor,
	}

	mockAuthService := &MockYNABAuthService{
		YNABAuthService: &ynab_auth.YNABAuthService{},
	}

	return NewBudgetService(mockAuthService, func(string) (ynab_client.YNAB, error) {
		return mockClient, nil
	})
}
