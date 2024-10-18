package transaction

import (
	"testing"
	"time"

	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

func TestTransactionRepository(t *testing.T) {
	t.Run("GetTransactionsByAccountID", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		require.NoError(t, err)

		repo := NewTransactionRepository(db)
		accountID := uuid.MustParse("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")
		transactions, err := repo.GetTransactionsByAccountID(GetTransactionsInput{
			AccountID:          accountID,
			StartDateInclusive: time.Date(2024, time.September, 25, 0, 0, 0, 0, time.UTC),
			EndDateInclusive:   time.Date(2024, time.September, 30, 0, 0, 0, 0, time.UTC),
		})
		require.NoError(t, err)
		require.NotNil(t, transactions)
		require.Equal(t, 10, len(transactions))
	})

	t.Run("GetLatestTransactionDate", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		require.NoError(t, err)

		repo := NewTransactionRepository(db)
		accountID := uuid.MustParse("b80a370f-f36c-45d8-853e-3ddf35557816")
		date, err := repo.GetLatestTransactionDate(accountID)
		require.NoError(t, err)
		require.Equal(t, time.Date(2024, time.October, 4, 0, 0, 0, 0, time.UTC), date)
	})
}
