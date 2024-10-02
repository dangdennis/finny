package finalytics

import (
	"fmt"
	"log"
	"sync"
	"sync/atomic"
	"time"

	"github.com/finny/worker/plaid_items"
	"github.com/finny/worker/queue"
	amqp "github.com/rabbitmq/amqp091-go"
	"gorm.io/gorm"
)

const FINALYTICS_QUEUE_NAME = "finalytics"

type WorkerManager struct {
	db            *gorm.DB
	qm            *queue.QueueManager
	ch            *amqp.Channel
	workerStarted atomic.Bool
	startOnce     sync.Once
	plaidItemRepo *plaid_items.PlaidItemRepository
	waitTimeSecs  int64
}

type WorkerManagerOption func(*WorkerManager)

func WithWaitTime(waitTime time.Duration) WorkerManagerOption {
	return func(wm *WorkerManager) {
		wm.waitTimeSecs = int64(waitTime.Seconds())
	}
}

func NewWorkerManager(qm *queue.QueueManager, db *gorm.DB, options ...WorkerManagerOption) (*WorkerManager, error) {
	ch, err := qm.Channel()
	if err != nil {
		return nil, err
	}

	wm := &WorkerManager{
		db:           db,
		qm:           qm,
		ch:           ch,
		waitTimeSecs: 10,
	}

	for _, option := range options {
		option(wm)
	}

	return wm, nil
}

func (wm *WorkerManager) Close() error {
	if wm.qm != nil {
		return wm.qm.Close()
	}

	return nil
}

func (wm *WorkerManager) StartWorker() error {
	if wm.workerStarted.Load() {
		return nil
	}

	wm.startOnce.Do(func() {
		wm.workerStarted.Store(true)
		go wm.processFinalyticsMessages()
	})

	return nil
}

func (wm *WorkerManager) processFinalyticsMessages() {
	q, err := wm.ch.QueueDeclare(
		FINALYTICS_QUEUE_NAME, // name
		true,                  // durable
		false,                 // delete when unused
		false,                 // exclusive
		false,                 // no-wait
		nil,                   // arguments
	)
	if err != nil {
		log.Printf("Failed to declare a queue: %v", err)
		return
	}

	msgs, err := wm.ch.Consume(
		q.Name, // queue
		"",     // consumer
		false,  // auto-ack
		false,  // exclusive
		false,  // no-local
		false,  // no-wait
		nil,    // args
	)
	if err != nil {
		log.Printf("Failed to register a consumer: %v", err)
		return
	}

	timeout := time.NewTimer(time.Duration(wm.waitTimeSecs) * time.Second)
	defer timeout.Stop()

	for {
		select {
		case msg, ok := <-msgs:
			if !ok {
				log.Println("Channel closed, stopping worker")
				return
			}

			fmt.Printf("Received a message: %s\n", msg.Body)

			if err := processFinalyticMessage(&msg); err != nil {
				continue
			}

			msg.Ack(false)

			timeout.Reset(time.Duration(wm.waitTimeSecs) * time.Second)
		case <-timeout.C:
			log.Println("No messages received for 10 seconds, stopping worker")
			return
		}
	}
}
