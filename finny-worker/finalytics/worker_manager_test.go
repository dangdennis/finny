package finalytics

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/finny/worker/account"
	"github.com/finny/worker/database"
	"github.com/finny/worker/goal"
	"github.com/finny/worker/plaid_item"
	"github.com/finny/worker/profile"
	"github.com/finny/worker/queue"
	"github.com/finny/worker/transaction"
	"github.com/google/uuid"
	"github.com/rabbitmq/amqp091-go"
	"github.com/stretchr/testify/require"
)

func TestProcessFinalyticMessage(t *testing.T) {
	t.SkipNow()

	db, err := database.NewTestCalcDatabase()
	require.NoError(t, err)

	accountRepo := account.NewAccountRepository(db)
	profileRepo := profile.NewProfileRepository(db)
	goalRepo := goal.NewGoalRepository(db, account.NewAccountRepository(db))
	transactionRepo := transaction.NewTransactionRepository(db)
	finalyticsService := NewFinalyticsService(db, accountRepo, profileRepo, goalRepo, transactionRepo)

	qm, err := queue.NewTestQueueManager()
	require.NoError(t, err)

	plaidItemRepo := plaid_item.NewPlaidItemRepository(db)

	wm, err := NewWorkerManager(db, qm, finalyticsService, plaidItemRepo, WithWaitTime(10*time.Second))
	require.NoError(t, err)

	err = wm.StartWorker()
	require.NoError(t, err)

	for i := 0; i < 10; i++ {
		msg := FinalyticMessage{
			MessageId: uuid.New().String(),
			ItemId:    uuid.New().String(),
			Op:        "recalculate_all",
		}
		publishFinalyticsMessage(t, wm.ch, msg)
	}

	time.Sleep(500 * time.Millisecond)

	err = wm.Close()
	require.NoError(t, err)
}

func publishFinalyticsMessage(t *testing.T, ch *amqp091.Channel, msg FinalyticMessage) {
	body, err := json.Marshal(msg)
	require.NoError(t, err)

	err = ch.Publish("",
		FINALYTICS_QUEUE_NAME,
		false,
		false,
		amqp091.Publishing{
			ContentType: "application/json",
			Body:        body,
		})
	require.NoError(t, err)
}
