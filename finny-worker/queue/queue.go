package queue

import "github.com/rabbitmq/amqp091-go"

type QueueManager struct {
	conn *amqp091.Connection
}

func NewQueueManager(conn *amqp091.Connection) *QueueManager {
	return &QueueManager{
		conn: conn,
	}
}

func NewLavinMqQueue(url string) (*QueueManager, error) {
	conn, err := amqp091.Dial(url)
	if err != nil {
		return nil, err
	}

	return &QueueManager{
		conn: conn,
	}, nil
}

func NewTestQueueManager() (*QueueManager, error) {
	return NewLavinMqQueue("amqp://guest:guest@localhost:5672/")
}

func (qm *QueueManager) Close() error {
	if qm.conn != nil {
		return qm.conn.Close()
	}
	return nil
}

func (qm *QueueManager) Channel() (*amqp091.Channel, error) {
	return qm.conn.Channel()
}
