package plaid_item

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type PlaidItemRepository struct {
	db *gorm.DB
}

func NewPlaidItemRepository(db *gorm.DB) *PlaidItemRepository {
	return &PlaidItemRepository{
		db: db,
	}
}

func (r *PlaidItemRepository) GetItem(itemId uuid.UUID) (*PlaidItem, error) {
	var item PlaidItem
	err := r.db.Where("id = ?", itemId).First(&item).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &item, nil
}

type PlaidItem struct {
	ID                  uuid.UUID      `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	UserID              uuid.UUID      `gorm:"type:uuid;not null"`
	PlaidAccessToken    string         `gorm:"type:text;not null"`
	PlaidItemID         string         `gorm:"column:plaid_item_id;type:text;not null"`
	PlaidInstitutionID  string         `gorm:"type:text;not null"`
	Status              string         `gorm:"type:text;not null"`
	TransactionsCursor  *string        `gorm:"type:text"`
	CreatedAt           time.Time      `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	UpdatedAt           time.Time      `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	DeletedAt           gorm.DeletedAt `gorm:"type:timestamp(6) with time zone"`
	LastSyncedAt        *time.Time     `gorm:"type:timestamp with time zone"`
	LastSyncError       *string        `gorm:"type:text"`
	LastSyncErrorAt     *time.Time     `gorm:"type:timestamp with time zone"`
	RetryCount          int            `gorm:"type:integer;default:0"`
	ErrorType           *string        `gorm:"type:text"`
	ErrorCode           *string        `gorm:"type:varchar"`
	ErrorMessage        *string        `gorm:"type:varchar"`
	ErrorDisplayMessage *string        `gorm:"type:varchar"`
	ErrorRequestID      *string        `gorm:"type:varchar"`
	DocumentationURL    *string        `gorm:"type:varchar"`
	SuggestedAction     *string        `gorm:"type:varchar"`
}

func (PlaidItem) TableName() string {
	return "plaid_items"
}
