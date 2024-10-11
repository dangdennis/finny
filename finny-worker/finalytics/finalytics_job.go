package finalytics

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/rabbitmq/amqp091-go"
)

type FinalyticMessage struct {
	MessageId string `json:"message_id"`
	ItemId    string `json:"item_id"`
	Op        string `json:"op"`
}

func (s *FinalyticsService) ProcessFinalyticMessage(msg *amqp091.Delivery) error {
	var finalyticMsg FinalyticMessage
	err := json.Unmarshal(msg.Body, &finalyticMsg)
	if err != nil {
		log.Printf("Error unmarshaling message: %v", err)
		return err
	}

	fmt.Printf("Received a message: MessageID=%s, UserID=%s, Op=%s\n",
		finalyticMsg.MessageId, finalyticMsg.ItemId, finalyticMsg.Op)

	return nil
}
