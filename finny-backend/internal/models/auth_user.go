package models

import (
	"time"

	"github.com/google/uuid"
)

type AuthUser struct {
	ID                uuid.UUID `gorm:"primaryKey"`
	Email             string    `gorm:"type:varchar(255)"`
	EncryptedPassword string    `gorm:"type:varchar(255)"`
	CreatedAt         time.Time
	UpdatedAt         time.Time
}

func (AuthUser) TableName() string {
	return "auth.users"
}
