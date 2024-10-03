package finalytics

import (
	"encoding/json"
	"testing"
	"time"

	"github.com/finny/worker/database"
	"github.com/finny/worker/plaid_item"
	"github.com/finny/worker/profile"
	"github.com/finny/worker/queue"
	"github.com/google/uuid"
	amqp "github.com/rabbitmq/amqp091-go"
	"github.com/stretchr/testify/assert"
)

func TestProcessFinalyticMessage(t *testing.T) {
	t.SkipNow()

	db, err := database.NewTestCalcDatabase()
	assert.NoError(t, err)

	profileRepo := profile.NewProfileRepository(db)
	finalyticsService := NewFinalyticsService(db, profileRepo)

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
