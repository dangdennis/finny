package goal

import (
	"testing"

	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestGoalRepository(t *testing.T) {
	t.Run("GetRetirementGoal", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		assert.NoError(t, err)

		repo := NewGoalRepository(db)
		goal, err := repo.GetRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		assert.NoError(t, err)
		assert.NotNil(t, goal)
	})

	t.Run("GetAssignedAccountsOnGoal", func(t *testing.T) {
		db, err := database.NewTestCalcDatabase()
		assert.NoError(t, err)

		repo := NewGoalRepository(db)
		goal, err := repo.GetRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
		goals, err := repo.GetAssignedAccountsOnGoal(goal.ID)
		assert.NoError(t, err)
		assert.NotNil(t, goals)
		assert.Equal(t, 5, len(goals))
	})
}
