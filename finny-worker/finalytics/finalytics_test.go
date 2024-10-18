package finalytics

import (
	"testing"
	"time"

	"github.com/finny/worker/account"
	"github.com/finny/worker/database"
	"github.com/finny/worker/goal"
	"github.com/finny/worker/profile"
	"github.com/finny/worker/transaction"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

func TestFinalyticsService(t *testing.T) {
	testDB, err := database.NewTestDatabase()
	require.NoError(t, err, "Failed to connect to database")

	testCalcDB, err := database.NewTestCalcDatabase()
	require.NoError(t, err, "Failed to connect to database")

	accountRepo := account.NewAccountRepository(testDB)
	profileRepo := profile.NewProfileRepository(testDB)
	goalRepo := goal.NewGoalRepository(testDB, accountRepo)
	transactionRepo := transaction.NewTransactionRepository(testDB)
	finSvcWithTestDB := NewFinalyticsService(testDB, accountRepo, profileRepo, goalRepo, transactionRepo)

	accountRepo = account.NewAccountRepository(testCalcDB)
	profileRepo = profile.NewProfileRepository(testCalcDB)
	goalRepo = goal.NewGoalRepository(testCalcDB, accountRepo)
	transactionRepo = transaction.NewTransactionRepository(testCalcDB)
	finSvcWithTestCalcDB := NewFinalyticsService(testCalcDB, accountRepo, profileRepo, goalRepo, transactionRepo)

	t.Run("Pmt", func(t *testing.T) {
		tc := []struct {
			Rate        float64
			NumPeriods  int
			Pv          float64
			Fv          float64
			ExpectedPmt float64
		}{
			{
				Rate:        0.02,
				NumPeriods:  30,
				Pv:          -10_000.0,
				Fv:          230_000.0,
				ExpectedPmt: -5222.982904548653,
			},
			{
				Rate:        0.08,
				NumPeriods:  35,
				Pv:          -80000,
				Fv:          3_000_000,
				ExpectedPmt: -10_545.532517185018,
			},
		}

		for _, tc := range tc {
			pmt, err := finSvcWithTestDB.Pmt(PmtInput{
				rate:       tc.Rate,
				numPeriods: tc.NumPeriods,
				pv:         tc.Pv,
				fv:         tc.Fv,
			})
			require.NoError(t, err)
			require.Equal(t, tc.ExpectedPmt, pmt)
		}
	})

	t.Run("Nper", func(t *testing.T) {
		t.Run("happy paths", func(t *testing.T) {
			tc := []struct {
				Rate         float64
				Pmt          float64
				Pv           float64
				Fv           float64
				ExpectedNper float64
			}{
				{
					Rate:         0.0,
					Pmt:          -48_000,
					Pv:           -80_000,
					Fv:           230_000,
					ExpectedNper: 3.125,
				},
				{
					Rate:         0.045,
					Pmt:          0.0,
					Pv:           -10_000.0,
					Fv:           230_000,
					ExpectedNper: 71.23389549807297,
				},
			}

			for _, tc := range tc {
				pmt, err := finSvcWithTestDB.Nper(NperInput{
					rate: tc.Rate,
					pmt:  tc.Pmt,
					pv:   tc.Pv,
					fv:   tc.Fv,
				})
				require.NoError(t, err)
				require.Equal(t, tc.ExpectedNper, pmt)
			}
		})

		t.Run("errors on invalid nper inputs", func(t *testing.T) {
			tc := []struct {
				Rate         float64
				Pmt          float64
				Pv           float64
				Fv           float64
				ExpectedNper float64
			}{
				{
					Rate:         0.03,
					Pmt:          0,
					Pv:           0,
					Fv:           230_000,
					ExpectedNper: 0.0,
				},
				{
					Rate:         0.0,
					Pmt:          0.0,
					Pv:           -10_000.0,
					Fv:           230_000,
					ExpectedNper: 71.23389549807297,
				},
			}

			for _, tc := range tc {
				_, err := finSvcWithTestDB.Nper(NperInput{
					rate: tc.Rate,
					pmt:  tc.Pmt,
					pv:   tc.Pv,
					fv:   tc.Fv,
				})
				require.Error(t, err)
			}
		})
	})

	t.Run("Fv", func(t *testing.T) {
		t.Run("happy paths", func(t *testing.T) {
			tc := []struct {
				Rate        float64
				Pmt         float64
				Pv          float64
				NumPeriods  int
				ExpectedFv  float64
				ExpectedErr error
			}{
				{
					Rate:       0.02,
					Pmt:        -5222,
					Pv:         -10_000.0,
					NumPeriods: 30,
					ExpectedFv: 229960.12545041912,
				},
				{
					Rate:       0.045,
					Pmt:        0.0,
					Pv:         -10_000.0,
					NumPeriods: 35,
					ExpectedFv: 46673.47810024524,
				},
			}

			for _, tc := range tc {
				fv, err := finSvcWithTestDB.Fv(FvInput{
					rate:       tc.Rate,
					pmt:        tc.Pmt,
					pv:         tc.Pv,
					numPeriods: tc.NumPeriods,
				})
				require.NoError(t, err)
				require.Equal(t, tc.ExpectedFv, fv)
			}
		})

	})

	t.Run("ComputeAccountBalance", func(t *testing.T) {
		t.Run("Compute without persisting", func(t *testing.T) {
			startDateInclusive := time.Date(2024, time.September, 18, 0, 0, 0, 0, time.UTC)
			endDateExclusive := time.Date(2024, time.October, 5, 0, 0, 0, 0, time.UTC)
			balances, err := finSvcWithTestCalcDB.ComputeAccountBalance(ComputeAccountBalanceInput{
				AccountID:          uuid.MustParse("b80a370f-f36c-45d8-853e-3ddf35557816"),
				StartDateInclusive: startDateInclusive,
				EndDateInclusive:   endDateExclusive,
			})
			require.NoError(t, err)
			require.Equal(t, 18, len(balances.Balances))

			expectedBalances := []struct {
				Date    time.Time
				Balance float64
			}{
				{time.Date(2024, 10, 5, 0, 0, 0, 0, time.UTC), 589.62},
				{time.Date(2024, 10, 4, 0, 0, 0, 0, time.UTC), 459.20000000000005},
				{time.Date(2024, 10, 3, 0, 0, 0, 0, time.UTC), 291.47},
				{time.Date(2024, 10, 2, 0, 0, 0, 0, time.UTC), 196.24},
				{time.Date(2024, 10, 1, 0, 0, 0, 0, time.UTC), 196.24},
				{time.Date(2024, 9, 30, 0, 0, 0, 0, time.UTC), -189.29000000000002},
				{time.Date(2024, 9, 29, 0, 0, 0, 0, time.UTC), -189.29000000000002},
				{time.Date(2024, 9, 28, 0, 0, 0, 0, time.UTC), -189.29000000000002},
				{time.Date(2024, 9, 27, 0, 0, 0, 0, time.UTC), 504},
				{time.Date(2024, 9, 26, 0, 0, 0, 0, time.UTC), 407},
				{time.Date(2024, 9, 25, 0, 0, 0, 0, time.UTC), 407},
				{time.Date(2024, 9, 24, 0, 0, 0, 0, time.UTC), 3331.83},
				{time.Date(2024, 9, 23, 0, 0, 0, 0, time.UTC), 3074.0599999999995},
				{time.Date(2024, 9, 22, 0, 0, 0, 0, time.UTC), 3074.0599999999995},
				{time.Date(2024, 9, 21, 0, 0, 0, 0, time.UTC), 3074.0599999999995},
				{time.Date(2024, 9, 20, 0, 0, 0, 0, time.UTC), 2983.7999999999993},
				{time.Date(2024, 9, 19, 0, 0, 0, 0, time.UTC), 2671.0299999999997},
				{time.Date(2024, 9, 18, 0, 0, 0, 0, time.UTC), 2655.7799999999997},
			}

			require.Equal(t, len(expectedBalances), len(balances.Balances))

			for i, expected := range expectedBalances {
				require.Equal(t, expected.Date, balances.Balances[i].Date)
				require.InDelta(t, expected.Balance, balances.Balances[i].CurrentBal, 0.000001)
			}
		})

		t.Run("Compute with persisting", func(t *testing.T) {
			startDateInclusive := time.Date(2024, time.September, 18, 0, 0, 0, 0, time.UTC)
			endDateExclusive := time.Date(2024, time.October, 5, 0, 0, 0, 0, time.UTC)
			acctID := uuid.MustParse("b80a370f-f36c-45d8-853e-3ddf35557816")
			balances, err := finSvcWithTestCalcDB.ComputeAccountBalance(ComputeAccountBalanceInput{
				AccountID:          acctID,
				StartDateInclusive: startDateInclusive,
				EndDateInclusive:   endDateExclusive,
				Persist:            true,
			})
			require.NoError(t, err)
			require.Equal(t, 18, len(balances.Balances))

			expectedBalances := []struct {
				Date    time.Time
				Balance float64
			}{
				{time.Date(2024, 10, 5, 0, 0, 0, 0, time.UTC), 589.62},
				{time.Date(2024, 10, 4, 0, 0, 0, 0, time.UTC), 459.20000000000005},
				{time.Date(2024, 10, 3, 0, 0, 0, 0, time.UTC), 291.47},
				{time.Date(2024, 10, 2, 0, 0, 0, 0, time.UTC), 196.24},
				{time.Date(2024, 10, 1, 0, 0, 0, 0, time.UTC), 196.24},
				{time.Date(2024, 9, 30, 0, 0, 0, 0, time.UTC), -189.29000000000002},
				{time.Date(2024, 9, 29, 0, 0, 0, 0, time.UTC), -189.29000000000002},
				{time.Date(2024, 9, 28, 0, 0, 0, 0, time.UTC), -189.29000000000002},
				{time.Date(2024, 9, 27, 0, 0, 0, 0, time.UTC), 504},
				{time.Date(2024, 9, 26, 0, 0, 0, 0, time.UTC), 407},
				{time.Date(2024, 9, 25, 0, 0, 0, 0, time.UTC), 407},
				{time.Date(2024, 9, 24, 0, 0, 0, 0, time.UTC), 3331.83},
				{time.Date(2024, 9, 23, 0, 0, 0, 0, time.UTC), 3074.0599999999995},
				{time.Date(2024, 9, 22, 0, 0, 0, 0, time.UTC), 3074.0599999999995},
				{time.Date(2024, 9, 21, 0, 0, 0, 0, time.UTC), 3074.0599999999995},
				{time.Date(2024, 9, 20, 0, 0, 0, 0, time.UTC), 2983.7999999999993},
				{time.Date(2024, 9, 19, 0, 0, 0, 0, time.UTC), 2671.0299999999997},
				{time.Date(2024, 9, 18, 0, 0, 0, 0, time.UTC), 2655.7799999999997},
			}

			gotBalances, err := finSvcWithTestCalcDB.accountRepo.GetAccountBalancesInDateRange(acctID, startDateInclusive, endDateExclusive)
			require.NoError(t, err)
			require.Equal(t, len(expectedBalances), len(gotBalances))
			for i, expected := range expectedBalances {
				require.Equal(t, expected.Date, gotBalances[i].BalanceDate)
				require.InDelta(t, expected.Balance, gotBalances[i].CurrentBalance, 0.000001)
			}
		})
	})
}
