package finalytics

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/google/uuid"
	amqp "github.com/rabbitmq/amqp091-go"
	"gorm.io/gorm"
)

type FinalyticsService struct {
	db *gorm.DB
}

func NewFinalyticsService(db *gorm.DB) *FinalyticsService {
	return &FinalyticsService{
		db: db,
	}
}

type FinalyticMessage struct {
	MessageId string `json:"message_id"`
	ItemId    string `json:"item_id"`
	Op        string `json:"op"`
}

func (s *FinalyticsService) ProcessFinalyticMessage(msg *amqp.Delivery) error {
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

type ExpenseCalculation int

const (
	Last12Months ExpenseCalculation = iota
	Average
)

func (s *FinalyticsService) GetActualRetirementAge(userId uuid.UUID, calcType ExpenseCalculation) (int, error) {
	var age int
	return age, nil
}
