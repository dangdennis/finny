package finalytics

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/finny/worker/profile"
	"github.com/google/uuid"
	amqp "github.com/rabbitmq/amqp091-go"
	"gorm.io/gorm"
)

type FinalyticsService struct {
	db          *gorm.DB
	profileRepo *profile.ProfileRepository
}

func NewFinalyticsService(db *gorm.DB, profileRepo *profile.ProfileRepository) *FinalyticsService {
	return &FinalyticsService{
		db:          db,
		profileRepo: profileRepo,
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
	profile, err := s.GetProfile(userId)
	if err != nil {
		return 0, err
	}

	age := profile.Age()

	return age, nil
}

type Profile struct {
	ID            uuid.UUID      `gorm:"type:uuid;primary_key"`
	DeletedAt     gorm.DeletedAt `gorm:"index"`
	DateOfBirth   time.Time      `gorm:"type:date"`
	RetirementAge int            `gorm:"type:integer"`
	RiskProfile   string         `gorm:"type:text"`
	FireProfile   string         `gorm:"type:text"`
}

func (Profile) TableName() string {
	return "profiles"
}

func (p *Profile) Age() int {
	if p.DateOfBirth.IsZero() {
		return 0
	}

	now := time.Now()
	age := now.Year() - p.DateOfBirth.Year()

	// Adjust age if birthday hasn't occurred this year
	if now.YearDay() < p.DateOfBirth.YearDay() {
		age--
	}

	return age
}

func (s *FinalyticsService) GetProfile(userId uuid.UUID) (*Profile, error) {
	var profile Profile
	err := s.db.Where("id = ?", userId).First(&profile).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &profile, nil
}
