package plaid_item

import (
	"testing"

	"github.com/finny/worker/database"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

func TestGetItem(t *testing.T) {
	db, err := database.NewTestCalcDatabase()
	require.NoError(t, err)

	repo := NewPlaidItemRepository(db)
	item, err := repo.GetItem(uuid.MustParse("21ed5e1a-4e37-4281-ba8d-64152cefd682"))
	require.NoError(t, err)
	require.NotNil(t, item)
}
