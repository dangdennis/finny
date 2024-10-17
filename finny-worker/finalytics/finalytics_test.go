package finalytics

import (
	"testing"

	"github.com/finny/worker/account"
	"github.com/finny/worker/database"
	"github.com/finny/worker/goal"
	"github.com/finny/worker/profile"
	"github.com/finny/worker/transaction"
	"github.com/stretchr/testify/require"
)

func TestFinalyticsService(t *testing.T) {
	db, err := database.NewTestDatabase()
	require.NoError(t, err, "Failed to connect to database")
	accountRepo := account.NewAccountRepository(db)
	profileRepo := profile.NewProfileRepository(db)
	goalRepo := goal.NewGoalRepository(db, accountRepo)
	transactionRepo := transaction.NewTransactionRepository(db)
	finSvc := NewFinalyticsService(db, profileRepo, goalRepo, transactionRepo)

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
			pmt, err := finSvc.Pmt(PmtInput{
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
				pmt, err := finSvc.Nper(NperInput{
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
				_, err := finSvc.Nper(NperInput{
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
				fv, err := finSvc.Fv(FvInput{
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
}
