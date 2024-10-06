package finalytics

import (
	"fmt"
	"math"
	"time"

	"github.com/finny/worker/goal"
	"github.com/finny/worker/profile"
	"github.com/finny/worker/time_helper"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
)

type FinalyticsService struct {
	db          *gorm.DB
	profileRepo *profile.ProfileRepository
	goalRepo    *goal.GoalRepository
}

func NewFinalyticsService(db *gorm.DB, profileRepo *profile.ProfileRepository) *FinalyticsService {
	return &FinalyticsService{
		db:          db,
		profileRepo: profileRepo,
	}
}

type ExpenseCalculation int

const (
	Last12Months ExpenseCalculation = iota
	Average
)

func (s *FinalyticsService) GetActualRetirementAge(userId uuid.UUID, calcType ExpenseCalculation) (int32, error) {
	annualInterestRate := 0.08

	fv, err := s.GetFreedomFutureValueOfCurrentExpenses(userId, calcType)
	if err != nil {
		return 0, err
	}

	pv := 0.0

	pmt, err := s.GetActualSavingsThisMonth(userId, time.Now())
	if err != nil {
		return 0, nil
	}

	period := s.GetPeriodFromFutureValue(PeriodFromFutureValueInput{
		fv:                 fv,
		pv:                 pv,
		pmt:                pmt,
		annualInterestRate: annualInterestRate,
	})

	return period, nil
}

func (s *FinalyticsService) GetFreedomFutureValueOfCurrentExpenses(userId uuid.UUID, exp ExpenseCalculation) (float64, error) {
	switch exp {
	case Last12Months:
		flows, err := s.GetLast12MonthsInflowOutflow(userId)
		return flows.Inflows, err
	case Average:
		flows, err := s.GetAverageMonthlyInflowOutflow(userId)
		return flows.Outflows * 12 / 0.04, err
	default:
		return 0.0, fmt.Errorf("Invalid expense calculation: %+v", exp)
	}
}

type InflowOutflow struct {
	Inflows  float64 `gorm:"column:inflows"`
	Outflows float64 `gorm:"column:outflows"`
}

func (s *FinalyticsService) GetLast12MonthsInflowOutflow(userID uuid.UUID) (InflowOutflow, error) {
	sqlParams := map[string]interface{}{
		"userID": userID,
	}

	var output InflowOutflow
	err := s.db.Raw(`
				WITH regular_transactions AS (
	               SELECT
	                   SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS total_inflows,
	                   SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_outflows
	               FROM
	                   transactions
	                   JOIN accounts ON transactions.account_id = accounts.id
	               WHERE
	                   date >= (CURRENT_DATE - INTERVAL '12 months')
	                   AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT')
	                   AND accounts.user_id = @userID
	           ),
	           transfer_transactions AS (
	               SELECT
	                   SUM(CASE WHEN category = 'TRANSFER_IN' THEN amount ELSE -amount END) AS net_transfer
	               FROM
	                   transactions
	               JOIN accounts on transactions.account_id = accounts.id
	               WHERE
	                   date >= (CURRENT_DATE - INTERVAL '12 months')
	                   AND category IN ('TRANSFER_IN', 'TRANSFER_OUT')
	                   AND accounts.user_id = @userID
	           )
	           SELECT
	               CASE
	                   WHEN tt.net_transfer > 0 THEN rt.total_inflows + tt.net_transfer
	                   ELSE rt.total_inflows
	               END AS inflows,
	               CASE
	                   WHEN tt.net_transfer < 0 THEN rt.total_outflows - tt.net_transfer
	                   ELSE rt.total_outflows
	               END AS outflows
	                       FROM
	                           regular_transactions rt, transfer_transactions tt;
		`, sqlParams).Scan(&output).Error

	if err != nil {
		return InflowOutflow{}, err
	}

	return InflowOutflow{}, nil
}

func (s *FinalyticsService) GetAverageMonthlyInflowOutflow(userId uuid.UUID) (InflowOutflow, error) {
	inputs := map[string]interface{}{
		"userId": userId,
	}

	s.db.Raw(`
		WITH monthly_regular_transactions AS (
	     SELECT
	       date_trunc('month', date) AS month,
	       sum(
	         CASE WHEN amount < 0 THEN
	           abs(amount)
	         ELSE
	           0
	         END) AS monthly_inflows,
	       sum(
	         CASE WHEN amount > 0 THEN
	           amount
	         ELSE
	           0
	         END) AS monthly_outflows
	     FROM
	       transactions
	       JOIN accounts ON transactions.account_id = accounts.id
	     WHERE
	       date >= (CURRENT_DATE - INTERVAL '12 months')
	       AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT')
	       AND accounts.user_id = @userId
	     GROUP BY
	       date_trunc('month', date)
	   ),
	   monthly_transfer_transactions AS (
	     SELECT
	       date_trunc('month', date) AS month,
	       sum(
	         CASE WHEN category = 'TRANSFER_IN' THEN
	           amount
	         ELSE
	           - amount
	         END) AS net_transfer
	     FROM
	       transactions join accounts on transactions.account_id = accounts.id
	     WHERE
	       date >= (CURRENT_DATE - INTERVAL '12 months')
	       AND category IN ('TRANSFER_IN', 'TRANSFER_OUT')
	       AND accounts.user_id = @userId
	     GROUP BY
	       date_trunc('month', date)
	   ),
	   adjusted_monthly_totals AS (
	     SELECT
	       mrt.month,
	       CASE WHEN coalesce(mtt.net_transfer, 0) > 0 THEN
	         mrt.monthly_inflows + coalesce(mtt.net_transfer, 0)
	       ELSE
	         mrt.monthly_inflows
	       END AS adjusted_inflows,
	       CASE WHEN coalesce(mtt.net_transfer, 0) < 0 THEN
	         mrt.monthly_outflows - coalesce(mtt.net_transfer, 0)
	       ELSE
	         mrt.monthly_outflows
	       END AS adjusted_outflows
	     FROM
	       monthly_regular_transactions mrt
	       LEFT JOIN monthly_transfer_transactions mtt ON mrt.month = mtt.month
	   )
	   SELECT
	     avg(adjusted_inflows) AS inflows,
	     avg(adjusted_outflows) AS outflows
	   FROM
	     adjusted_monthly_totals;
		`, inputs)

	return InflowOutflow{}, nil
}

type ActualSavingsThisMonthResult struct {
	NetBalanceChange float64 `gorm:"column:net_balance_change"`
}

func (s *FinalyticsService) GetActualSavingsThisMonth(userId uuid.UUID, month time.Time) (float64, error) {
	retirementGoal, err := s.goalRepo.GetRetirementGoal(userId)
	if err != nil || retirementGoal == nil {
		return 0.0, err
	}

	_, err = s.goalRepo.GetAssignedAccountsOnGoal(retirementGoal.ID)
	if err != nil {
		return 0.0, err
	}

	// sqlParams := map[string]interface{}{
	// 	"userID": userId,
	// }
	// retGoal, err := s.
	var result ActualSavingsThisMonthResult
	// 	start_of_month_balances AS (
	// 				-- Get the earliest balance in the current month for each account
	// 				SELECT DISTINCT ON (ab.account_id)
	// 					ab.account_id,
	// 					ab.balance_date AS start_balance_date,
	// 					ab.current_balance AS start_balance
	// 				FROM
	// 					account_balances ab
	// 				WHERE
	// 					ab.balance_date >= date_trunc('month', '2023-09-01'::date)
	// 					AND ab.account_id IN (
	// 						SELECT
	// 							account_id
	// 						FROM
	// 							assigned_accounts)
	// 					ORDER BY
	// 						ab.account_id,
	// 						ab.balance_date
	// 	),
	// 	most_recent_balances AS (
	// 				-- Get the most recent balance for each account
	// 				SELECT DISTINCT ON (ab.account_id)
	// 					ab.account_id,
	// 					ab.balance_date AS most_recent_balance_date,
	// 					ab.current_balance AS most_recent_balance
	// 				FROM
	// 					account_balances ab
	// 				WHERE
	// 					ab.account_id IN (
	// 						SELECT
	// 							account_id
	// 						FROM
	// 							assigned_accounts)
	// 					ORDER BY
	// 						ab.account_id,
	// 						ab.balance_date DESC
	// 	)
	// 	SELECT
	// 				GREATEST (coalesce(sum(mr.most_recent_balance - som.start_balance), 0), 0) AS net_balance_change
	// 	FROM
	// 				most_recent_balances mr
	// 				JOIN start_of_month_balances som ON mr.account_id = som.account_id
	// 				JOIN accounts ON mr.account_id = accounts.id
	// 	WHERE
	// 				mr.most_recent_balance_date >= som.start_balance_date
	// `, sqlParams).Scan(&result).Error

	if err != nil {
		return 0, fmt.Errorf("error calculating actual savings: %w", err)
	}

	return result.NetBalanceChange, nil
}

type StartOfMonthBalance struct {
	AccountID      uuid.UUID       `gorm:"column:account_id"`
	BalanceDate    time.Time       `gorm:"column:balance_date"`
	CurrentBalance decimal.Decimal `gorm:"column:current_balance"`
}

func (s *FinalyticsService) GetAccountBalancesAtStartOfMonth(userId uuid.UUID, date time.Time) ([]StartOfMonthBalance, error) {
	var results []StartOfMonthBalance

	firstDayOfMonth := time_helper.FirstDayOfMonth(date)
	err := s.db.Table("account_balances ab").
		Select("DISTINCT ON (account_id) ab.account_id, ab.balance_date, ab.current_balance").
		Joins("JOIN accounts ON ab.account_id = accounts.id").
		Where("accounts.user_id = ?", userId).
		Where("balance_date >= ?", firstDayOfMonth).
		Order("account_id, balance_date").
		Scan(&results).Error

	if err != nil {
		return nil, err
	}

	return results, nil
}

// todo: implement
func (s *FinalyticsService) GetActualInvestmentThisMonth(userId uuid.UUID) (float64, error) {
	return 0.0, nil
}

type PeriodFromFutureValueInput struct {
	fv                 float64
	pv                 float64
	pmt                float64
	annualInterestRate float64
}

func (s *FinalyticsService) GetPeriodFromFutureValue(input PeriodFromFutureValueInput) int32 {
	if input.annualInterestRate == 0 {
		return int32(math.Round((input.fv - input.pv) / input.pmt))
	}

	absFv := math.Abs(input.fv)
	absPv := math.Abs(input.pv)
	absPmt := math.Abs(input.pmt)

	period := math.Log((absFv*input.annualInterestRate+absPmt)/
		(absPv*input.annualInterestRate+absPmt)) /
		math.Log(1+input.annualInterestRate)

	return int32(math.Round(period))
}

type FutureValueInput struct {
	pv    float64
	pmt   float64
	rate  float64
	years int
}

func (s *FinalyticsService) GetFutureValue(input FutureValueInput) float64 {
	futureValue := input.pv*math.Pow(1+input.rate, float64(input.years)) +
		input.pmt*((math.Pow(1+input.rate, float64(input.years))-1)/input.rate)

	if input.pmt < 0 && input.pv < 0 {
		return -futureValue
	} else {
		return futureValue
	}
}

func (s *FinalyticsService) GetYearsToRetirement(userId uuid.UUID) (int32, error) {
	profile, err := s.profileRepo.GetProfile(userId)
	if err != nil {
		return 0, err
	}

	retirementAge := profile.RetirementAge
	if retirementAge == 0 {
		return 0, fmt.Errorf("Retirement age is missing")
	}

	return int32(retirementAge) - int32(profile.Age()), nil
}

type PaymentFromFutureValueInput struct {
	fv    float64
	pv    float64
	rate  float64
	years int
}

func (s *FinalyticsService) GetPaymentFromFutureValue(input PaymentFromFutureValueInput) float64 {
	var payment float64
	if input.rate == 0 {
		payment = (input.fv - input.pv) / float64(input.years)
	} else {
		payment = (input.fv - input.pv*math.Pow(1+input.rate, float64(input.years))/
			(math.Pow(1+input.rate, float64(input.years)-1)/input.rate))
	}

	if input.fv < 0 && input.pv < 0 {
		payment = -payment
	}

	return math.Trunc(payment)
}
