package transaction

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
)

type Transaction struct {
	ID                     uuid.UUID       `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	AccountID              uuid.UUID       `gorm:"type:uuid;not null"`
	PlaidTransactionID     string          `gorm:"type:text;not null;uniqueIndex:uq:transactions.plaid_transaction_id"`
	Category               string          `gorm:"type:text"`
	Subcategory            string          `gorm:"type:text"`
	Type                   string          `gorm:"type:text;not null"`
	Name                   string          `gorm:"type:text;not null"`
	Amount                 decimal.Decimal `gorm:"type:decimal;not null"`
	IsoCurrencyCode        string          `gorm:"type:text"`
	UnofficialCurrencyCode string          `gorm:"type:text"`
	Date                   time.Time       `gorm:"type:date;not null"`
	Pending                bool            `gorm:"type:boolean;not null"`
	AccountOwner           string          `gorm:"type:text"`
	CreatedAt              time.Time       `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	UpdatedAt              time.Time       `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	DeletedAt              gorm.DeletedAt  `gorm:"type:timestamp(6) with time zone"`
}

type TransactionRepository struct {
	db *gorm.DB
}

func NewTransactionRepository(db *gorm.DB) *TransactionRepository {
	return &TransactionRepository{
		db: db,
	}
}

type GetTransactionsInput struct {
	AccountID uuid.UUID
	StartDate time.Time
	EndDate   time.Time
}

func (t *TransactionRepository) GetTransactionsByAccountID(input GetTransactionsInput) ([]Transaction, error) {
	var transactions []Transaction
	err := t.db.Where("account_id = ?", input.AccountID).
		Where("date >= ?", input.StartDate).
		Where("date <= ?", input.EndDate).
		Find(&transactions).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return transactions, nil
		}
		return transactions, err
	}
	return transactions, nil
}
