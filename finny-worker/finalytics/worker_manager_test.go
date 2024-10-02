package finalytics

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/finny/worker/database"
	"github.com/finny/worker/plaid_items"
	"github.com/finny/worker/queue"
	"github.com/google/uuid"
	amqp "github.com/rabbitmq/amqp091-go"
	"github.com/stretchr/testify/assert"
)

func TestProcessFinalyticMessage(t *testing.T) {
	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)

	finalyticsService := NewFinalyticsService(db)

	qm, err := queue.NewTestQueueManager()
	assert.NoError(t, err)

	plaidItemRepo := plaid_items.NewPlaidItemRepository(db)

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

	time.Sleep(2 * time.Second)

	err = wm.Close()
	assert.NoError(t, err)
}

func publishFinalyticsMessage(t *testing.T, ch *amqp.Channel, msg FinalyticMessage) {
	body, err := json.Marshal(msg)
	assert.NoError(t, err)

	err = ch.Publish("",
		FINALYTICS_QUEUE_NAME,
		false,
		false,
		amqp.Publishing{
			ContentType: "application/json",
			Body:        body,
		})
	assert.NoError(t, err)
}
