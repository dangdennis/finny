package finalytics

import (
	"testing"

	"github.com/finny/worker/database"
	"github.com/finny/worker/profile"
	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
)

func TestFinalytics(t *testing.T) {
	t.Skip()

	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)

	profileRepo := profile.NewProfileRepository(db)
	finalyticsSvc := NewFinalyticsService(db, profileRepo)

	userId := uuid.MustParse("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")
	outflow, err := finalyticsSvc.GetLast12MonthsInflowOutflow(userId)
	assert.NoError(t, err)
	t.Fatalf("outflow %+v\n", outflow)
}
