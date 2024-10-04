package account

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type Account struct {
	ID                     uuid.UUID      `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	ItemID                 uuid.UUID      `gorm:"type:uuid;not null"`
	UserID                 uuid.UUID      `gorm:"type:uuid;not null;index"`
	PlaidAccountID         string         `gorm:"type:text;not null;uniqueIndex"`
	Name                   string         `gorm:"type:text;not null"`
	Mask                   *string        `gorm:"type:text"`
	OfficialName           *string        `gorm:"type:text"`
	CurrentBalance         float64        `gorm:"type:double precision;not null;default:0"`
	AvailableBalance       float64        `gorm:"type:double precision;not null;default:0"`
	IsoCurrencyCode        *string        `gorm:"type:text"`
	UnofficialCurrencyCode *string        `gorm:"type:text"`
	Type                   *string        `gorm:"type:text"`
	Subtype                *string        `gorm:"type:text"`
	CreatedAt              time.Time      `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	UpdatedAt              time.Time      `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	DeletedAt              gorm.DeletedAt `gorm:"type:timestamp(6) with time zone"`

	// PlaidItem PlaidItem `gorm:"foreignKey:ItemID"`
	// User      User      `gorm:"foreignKey:UserID"`
}

type AccountRepository struct {
	db *gorm.DB
}

func NewAccountRepository(db *gorm.DB) *AccountRepository {
	return &AccountRepository{
		db: db,
	}
}

func (a *AccountRepository) GetAccount(accountID uuid.UUID) (*Account, error) {
	var account Account
	err := a.db.Where("id = ?", accountID).First(&account).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}

		return nil, err
	}

	return &account, nil
}
