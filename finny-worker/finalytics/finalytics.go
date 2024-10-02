package finalytics

import (
	"encoding/json"
	"fmt"
	"log"

	amqp "github.com/rabbitmq/amqp091-go"
)

func processFinalyticMessage(msg *amqp.Delivery) error {
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

type FinalyticMessage struct {
	MessageId string `json:"message_id"`
	ItemId    string `json:"item_id"`
	Op        string `json:"op"`
}
