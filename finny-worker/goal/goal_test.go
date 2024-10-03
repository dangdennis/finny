package goal

import (
	"testing"

	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestGetRetirementGoal(t *testing.T) {
	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)

	repo := NewGoalRepository(db)
	item, err := repo.GetRetirementGoal(uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d"))
	assert.NoError(t, err)
	assert.NotNil(t, item)
}
