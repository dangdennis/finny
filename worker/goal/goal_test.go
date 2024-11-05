package goal

import (
	"fmt"
	"testing"

	"github.com/finny/worker/account"
	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

func TestGoalRepository(t *testing.T) {
	db, err := database.NewTestCalcDatabase()
	require.NoError(t, err)
	accountRepo := account.NewAccountRepository(db)
	repo := NewGoalRepository(db, accountRepo)

	t.Run("GetRetirementGoal", func(t *testing.T) {
		goal, err := repo.GetRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		require.NoError(t, err)
		require.NotNil(t, goal)
	})

	t.Run("GetAssignedAccountsOnGoal", func(t *testing.T) {
		goal, err := repo.GetRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		goals, err := repo.GetAssignedAccountsOnGoal(goal.ID)
		require.NoError(t, err)
		require.NotNil(t, goals)
		require.Equal(t, 5, len(goals))
	})

	t.Run("GetBalanceOnRetirementGoal", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		require.NoError(t, err)

		accountRepo := account.NewAccountRepository(db)
		repo := NewGoalRepository(db, accountRepo)
		goalBalance, err := repo.GetAssignedBalanceOnRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		require.NoError(t, err)
		fmt.Printf("%f\n", goalBalance)
		require.Equal(t, 83997.435, goalBalance)
	})
}
