package models

import (
	"time"

	"github.com/google/uuid"
)

type YNABToken struct {
	ID           int64     `gorm:"primaryKey;autoIncrement"`
	UserID       uuid.UUID `gorm:"type:uuid;not null"`
	AccessToken  string    `gorm:"type:text;not null"`
	RefreshToken string    `gorm:"type:text;not null"`
	ExpiresAt    time.Time `gorm:"type:timestamp with time zone;not null"`
	CreatedAt    time.Time `gorm:"type:timestamp with time zone;default:CURRENT_TIMESTAMP"`
	UpdatedAt    time.Time `gorm:"type:timestamp with time zone;default:CURRENT_TIMESTAMP"`
}

func (YNABToken) TableName() string {
	return "ynab_tokens"
}
