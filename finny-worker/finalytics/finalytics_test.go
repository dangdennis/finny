package finalytics

import (
	"testing"
	"time"

	"github.com/finny/worker/database"
	"github.com/finny/worker/profile"
	"github.com/google/uuid"
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
}
