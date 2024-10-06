package transaction

import (
	"testing"
	"time"

	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestTransactionRepository(t *testing.T) {
	t.Run("GetTransactionsByAccountID", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		assert.NoError(t, err)

		repo := NewTransactionRepository(db)
		accountID := uuid.MustParse("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")
		transactions, err := repo.GetTransactionsByAccountID(GetTransactionsInput{
			AccountID: accountID,
			StartDate: time.Date(2024, time.September, 25, 0, 0, 0, 0, time.UTC),
			EndDate:   time.Date(2024, time.September, 30, 0, 0, 0, 0, time.UTC),
		})
		assert.NoError(t, err)
		assert.NotNil(t, transactions)
		assert.Equal(t, 10, len(transactions))
	})
}
