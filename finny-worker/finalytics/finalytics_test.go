package finalytics

import (
	"testing"
	"time"

	"github.com/finny/worker/database"
	"github.com/finny/worker/profile"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"github.com/stretchr/testify/assert"
)

func TestFinalyticsService(t *testing.T) {
	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)
	profileRepo := profile.NewProfileRepository(db)
	finalyticsSvc := NewFinalyticsService(db, profileRepo)
	userId := uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")

	t.Run("GetLast12MonthsInflowOutflow", func(t *testing.T) {
		t.Skip()
		outflow, err := finalyticsSvc.GetLast12MonthsInflowOutflow(userId)
		assert.NoError(t, err)
		t.Fatalf("outflow %+v\n", outflow)
	})

	t.Run("GetActualSavingsThisMonth", func(t *testing.T) {
		testDate := time.Date(2023, time.September, 1, 0, 0, 0, 0, time.UTC)
		savings, err := finalyticsSvc.GetActualSavingsThisMonth(userId, testDate)
		assert.NoError(t, err)
		assert.Equal(t, savings, 50)
	})

	t.Run("GetAccountBalancesAtStartOfMonth", func(t *testing.T) {
		testDate := time.Date(2024, time.September, 25, 0, 0, 0, 0, time.UTC)
		startOfMonthBalances, err := finalyticsSvc.GetAccountBalancesAtStartOfMonth(userId, testDate)
		assert.NoError(t, err)
		assert.NotNil(t, startOfMonthBalances)

		assert.Equal(t, 14, len(startOfMonthBalances))

		expected := map[string]struct {
			Date    time.Time
			Balance decimal.Decimal
		}{
			"0fb340fa-ec00-4ef1-acbc-29940b8a3ff7": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(0)},
			"12e99f3e-729f-4f77-9aa3-923899bab8f6": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(0)},
			"1e308a98-0936-4b5c-8b49-c8ccc9cd86e6": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(10)},
			"37fa243d-018b-46b5-9b9e-7a8cfcfcb52d": {time.Date(2024, 9, 16, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(16645.66)},
			"4025721e-fd90-4797-a431-caf9c1f4cb7f": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(0)},
			"495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(8967.22)},
			"50b9c14a-d6a6-4bf3-9769-3fe4b949caee": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(21504.69)},
			"6d3c01cc-8b67-48c8-9b42-aa61b407b7cd": {time.Date(2024, 9, 12, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(0)},
			"934e256f-d01a-4f50-a69a-6502facc030c": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(15264.96)},
			"b7c85418-99b0-4466-8c95-b3d28fcbb970": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(0)},
			"b80a370f-f36c-45d8-853e-3ddf35557816": {time.Date(2024, 9, 12, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(3524.95)},
			"f0227957-76be-49c2-ad61-e6617a3330e5": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(16021.27)},
			"f7feb08f-010a-43e3-8fd9-9c27984dfad9": {time.Date(2024, 9, 7, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(16108.27)},
			"fff51a2f-3dda-4e4d-a371-1a2ae8536656": {time.Date(2024, 9, 12, 0, 0, 0, 0, time.UTC), decimal.NewFromFloat(0)},
		}

		assert.Equal(t, len(expected), len(startOfMonthBalances), "Number of results doesn't match expected")

		for _, balance := range startOfMonthBalances {
			expectedValue, exists := expected[balance.AccountID.String()]
			assert.True(t, exists, "Unexpected account ID: %s", balance.AccountID)
			if exists {
				assert.Equal(t, expectedValue.Date, balance.BalanceDate, "Incorrect date for account %s", balance.AccountID)
				assert.True(t, expectedValue.Balance.Equal(balance.CurrentBalance),
					"Incorrect balance for account %s. Expected %s, got %s",
					balance.AccountID, expectedValue.Balance, balance.CurrentBalance)
			}
		}
	})
}
