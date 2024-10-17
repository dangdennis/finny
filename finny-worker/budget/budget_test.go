package budget

import (
	"encoding/json"
	"fmt"
	"os"
	"testing"

	"math/rand"

	"github.com/brunomvsouza/ynab.go/api/category"
	"github.com/finny/worker/database"
	"github.com/finny/worker/supabaseclient"
	"github.com/finny/worker/ynabclient"
	"github.com/stretchr/testify/require"
	"github.com/supabase-community/gotrue-go/types"
)

func TestBudgetService(t *testing.T) {
	testDB, err := database.NewTestDatabase()
	require.NoError(t, err)

	t.Run("CalculateCashflow", func(t *testing.T) {
		sbc, err := supabaseclient.NewTestSupabase()
		require.NoError(t, err)

		t.Run("FromFile", func(t *testing.T) {
			userRes, err := sbc.Auth.Signup(types.SignupRequest{
				Email:    generateRandomEmail(),
				Password: generateRandomPassword(8),
			})
			require.NoError(t, err)
			require.NotNil(t, userRes)

			budgetService := NewBudgetService(testDB, ynabclient.NewYNABClient(""))
			budget, err := budgetService.FromFile("../calc_fixtures/budget.json")
			require.NoError(t, err)

			ynabInOutflow, err := budgetService.CalculateCashflow(budget, []string{"Credit Card Payments", "Internal Master Category"})
			require.Equal(t, 2689.35, ynabInOutflow.inflow)
			require.Equal(t, -8312.81, ynabInOutflow.outflow)
		})

		t.Run("FromDatabase", func(t *testing.T) {
			userRes, err := sbc.Auth.Signup(types.SignupRequest{
				Email:    generateRandomEmail(),
				Password: generateRandomPassword(8),
			})
			require.NoError(t, err)
			require.NotNil(t, userRes)

			categoriesJson, err := os.ReadFile("../calc_fixtures/budget.json")
			require.NoError(t, err)

			var groupsWithCategories []*category.GroupWithCategories
			err = json.Unmarshal(categoriesJson, &groupsWithCategories)
			require.NoError(t, err)

			budgetService := NewBudgetService(testDB, ynabclient.NewYNABClient(""))

			err = budgetService.CreateYNABData(testDB, userRes.ID, groupsWithCategories, 0)
			require.NoError(t, err)

			budget, err := budgetService.FromDatabase(userRes.ID)
			require.NoError(t, err)

			ynabInOutflow, err := budgetService.CalculateCashflow(budget, []string{"Credit Card Payments", "Internal Master Category"})
			require.Equal(t, 2689.35, ynabInOutflow.inflow)
			require.Equal(t, -8312.81, ynabInOutflow.outflow)
		})
	})
}

func generateRandomPassword(length int) string {
	chars := []rune("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+")
	password := make([]rune, length)
	for i := range password {
		password[i] = chars[rand.Intn(len(chars))]
	}
	return string(password)
}

func generateRandomEmail() string {
	const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	length := 10 // length of the random part of the email
	result := make([]byte, length)
	for i := range result {
		result[i] = chars[rand.Intn(len(chars))]
	}
	return fmt.Sprintf("%s@example.com", string(result))
}
