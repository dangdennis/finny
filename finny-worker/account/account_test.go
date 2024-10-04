package account

import (
	"testing"

	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestAccountRepository(t *testing.T) {
	t.Run("GetAccount", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		assert.NoError(t, err)

		repo := NewAccountRepository(db)
		goal, err := repo.GetAccount(uuid.MustParse("0fb340fa-ec00-4ef1-acbc-29940b8a3ff7"))
		assert.NoError(t, err)
		assert.NotNil(t, goal)
	})
}
