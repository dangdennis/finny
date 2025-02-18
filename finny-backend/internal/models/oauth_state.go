package models

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type OAuthState struct {
	ID        uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()"`
	State     string         `gorm:"type:text;not null;uniqueIndex:uq:oauth_states.state"`
	UserID    uuid.UUID      `gorm:"type:uuid;not null;index:ix:oauth_states.user_id"`
	CreatedAt time.Time      `gorm:"type:timestamp with time zone;not null;default:CURRENT_TIMESTAMP"`
	UpdatedAt time.Time      `gorm:"type:timestamp with time zone;not null;default:CURRENT_TIMESTAMP"`
	ExpiresAt time.Time      `gorm:"type:timestamp with time zone;not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamp with time zone"`
}

func (OAuthState) TableName() string {
	return "oauth_states"
}
