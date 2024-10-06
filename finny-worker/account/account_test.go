package account

import (
	"testing"
	"time"

	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"github.com/stretchr/testify/assert"
)

func TestAccountRepository(t *testing.T) {
	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)
	repo := NewAccountRepository(db)

	t.Run("GetAccount", func(t *testing.T) {
		goal, err := repo.GetAccount(uuid.MustParse("0fb340fa-ec00-4ef1-acbc-29940b8a3ff7"))
		assert.NoError(t, err)
		assert.NotNil(t, goal)
	})

	t.Run("GetAccountBalanceAtDate", func(t *testing.T) {
		accountID := uuid.MustParse("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")
		targetDate := time.Date(2024, time.September, 7, 0, 0, 0, 0, time.UTC)

		balance, err := repo.GetAccountBalanceAtDate(accountID, targetDate)
		assert.NoError(t, err)
		assert.Equal(t, decimal.NewFromFloat(8967.22), balance)
	})
}
