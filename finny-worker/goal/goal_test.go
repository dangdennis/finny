package goal

import (
	"fmt"
	"testing"

	"github.com/finny/worker/account"
	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestGoalRepository(t *testing.T) {
	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)
	accountRepo := account.NewAccountRepository(db)
	repo := NewGoalRepository(db, accountRepo)

	t.Run("GetRetirementGoal", func(t *testing.T) {
		goal, err := repo.GetRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		assert.NoError(t, err)
		assert.NotNil(t, goal)
	})

	t.Run("GetAssignedAccountsOnGoal", func(t *testing.T) {
		goal, err := repo.GetRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		goals, err := repo.GetAssignedAccountsOnGoal(goal.ID)
		assert.NoError(t, err)
		assert.NotNil(t, goals)
		assert.Equal(t, 5, len(goals))
	})

	t.Run("GetBalanceOnRetirementGoal", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		assert.NoError(t, err)

		accountRepo := account.NewAccountRepository(db)
		repo := NewGoalRepository(db, accountRepo)
		goalBalance, err := repo.GetAssignedBalanceOnRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		assert.NoError(t, err)
		fmt.Printf("%f\n", goalBalance)
		assert.Equal(t, 73904.070300, goalBalance)
	})
}
