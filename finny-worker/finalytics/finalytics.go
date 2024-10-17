package finalytics

import (
	"github.com/alpeb/go-finance/fin"
	"github.com/finny/worker/goal"
	"github.com/finny/worker/profile"
	"github.com/finny/worker/transaction"
	"gorm.io/gorm"
)

type FinalyticsService struct {
	db              *gorm.DB
	profileRepo     *profile.ProfileRepository
	goalRepo        *goal.GoalRepository
	transactionRepo *transaction.TransactionRepository
}

func NewFinalyticsService(db *gorm.DB, profileRepo *profile.ProfileRepository, goalRepo *goal.GoalRepository, transactionRepo *transaction.TransactionRepository) *FinalyticsService {
	return &FinalyticsService{
		db: db,
	}
}

type NperInput struct {
	rate float64
	pmt  float64
	pv   float64
	fv   float64
}

func (s *FinalyticsService) Nper(input NperInput) (float64, error) {
	return fin.Periods(input.rate, input.pmt, input.pv, input.fv, fin.PayEnd)
}

type PmtInput struct {
	rate       float64
	numPeriods int
	pv         float64
	fv         float64
}

func (s *FinalyticsService) Pmt(input PmtInput) (float64, error) {
	return fin.Payment(input.rate, input.numPeriods, input.pv, input.fv, fin.PayEnd)
}

type FvInput struct {
	pv         float64
	pmt        float64
	rate       float64
	numPeriods int
}

func (s *FinalyticsService) Fv(input FvInput) (float64, error) {
	return fin.FutureValue(input.rate, input.numPeriods, input.pmt, input.pv, fin.PayEnd)
}
