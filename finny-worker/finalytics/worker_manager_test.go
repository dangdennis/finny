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
	"github.com/stretchr/testify/assert"
)

func TestProcessFinalyticMessage(t *testing.T) {
	t.SkipNow()

	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)

	profileRepo := profile.NewProfileRepository(db)
	goalRepo := goal.NewGoalRepository(db, account.NewAccountRepository(db))
	transactionRepo := transaction.NewTransactionRepository(db)
	finalyticsService := NewFinalyticsService(db, profileRepo, goalRepo, transactionRepo)

	qm, err := queue.NewTestQueueManager()
	assert.NoError(t, err)

	plaidItemRepo := plaid_item.NewPlaidItemRepository(db)

	wm, err := NewWorkerManager(db, qm, finalyticsService, plaidItemRepo, WithWaitTime(10*time.Second))
	assert.NoError(t, err)

	err = wm.StartWorker()
	assert.NoError(t, err)

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
	assert.NoError(t, err)
}

func publishFinalyticsMessage(t *testing.T, ch *amqp091.Channel, msg FinalyticMessage) {
	body, err := json.Marshal(msg)
	assert.NoError(t, err)

	err = ch.Publish("",
		FINALYTICS_QUEUE_NAME,
		false,
		false,
		amqp091.Publishing{
			ContentType: "application/json",
			Body:        body,
		})
	assert.NoError(t, err)
}
