package budget

import (
	"fmt"
	"testing"

	"math/rand"

	"github.com/finny/worker/database"
	"github.com/finny/worker/supabaseclient"
	"github.com/stretchr/testify/assert"
	"github.com/supabase-community/gotrue-go/types"
)

func TestBudgetService(t *testing.T) {
	testDB, err := database.NewTestDatabase()
	assert.NoError(t, err)

	sbc, err := supabaseclient.NewTestSupabase()
	assert.NoError(t, err)

	userRes, err := sbc.Auth.Signup(types.SignupRequest{
		Email:    generateRandomEmail(),
		Password: generateRandomPassword(8),
	})
	assert.NoError(t, err)
	assert.NotNil(t, userRes)

	budgetService := NewBudgetService(testDB)
	budget, err := budgetService.FromFile("../calc_fixtures/budget.json")
	assert.NoError(t, err)

	ynabInOutflow, err := budgetService.CalculateSpending(budget, []string{"Credit Card Payments", "Internal Master Category"})
	assert.Equal(t, 2689.35, ynabInOutflow.inflow)
	assert.Equal(t, -8304.97, ynabInOutflow.outflow)
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
