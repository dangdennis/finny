package account

import (
	"errors"
	"fmt"
	"time"

	"github.com/finny/worker/plaid_item"
	"github.com/finny/worker/profile"
	"github.com/google/uuid"
	"github.com/shopspring/decimal"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type Account struct {
	ID                     uuid.UUID      `gorm:"column:id; type:uuid; default:gen_random_uuid(); primaryKey"`
	ItemID                 uuid.UUID      `gorm:"column:item_id; type:uuid; not null"`
	UserID                 uuid.UUID      `gorm:"column:user_id; type:uuid; not null; index"`
	PlaidAccountID         string         `gorm:"column:plaid_account_id; type:text; not null; uniqueIndex"`
	Name                   string         `gorm:"column:name; type:text; not null"`
	Mask                   *string        `gorm:"column:mask; type:text"`
	OfficialName           *string        `gorm:"column:official_name; type:text"`
	CurrentBalance         float64        `gorm:"column:current_balance; type:double precision; not null; default:0"`
	AvailableBalance       float64        `gorm:"column:available_balance; type:double precision; not null; default:0"`
	IsoCurrencyCode        *string        `gorm:"column:iso_currency_code; type:text"`
	UnofficialCurrencyCode *string        `gorm:"column:unofficial_currency_code; type:text"`
	Type                   *string        `gorm:"column:type; type:text"`
	Subtype                *string        `gorm:"column:subtype; type:text"`
	CreatedAt              time.Time      `gorm:"column:created_at; type:timestamp(6) with time zone; not null; default:CURRENT_TIMESTAMP"`
	UpdatedAt              time.Time      `gorm:"column:updated_at; type:timestamp(6) with time zone; not null; default:CURRENT_TIMESTAMP"`
	DeletedAt              gorm.DeletedAt `gorm:"column:deleted_at; type:timestamp(6) with time zone"`

	PlaidItem plaid_item.PlaidItem `gorm:"foreignKey:ItemID"`
	User      profile.Profile      `gorm:"foreignKey:UserID"`
}

type AccountBalance struct {
	ID               uuid.UUID `gorm:"column:id; type:uuid; default:gen_random_uuid(); primaryKey"`
	AccountID        uuid.UUID `gorm:"column:account_id; type:uuid; not null"`
	BalanceDate      time.Time `gorm:"column:balance_date; type:date; not null"`
	CurrentBalance   float64   `gorm:"column:current_balance; type:double precision; not null"`
	AvailableBalance *float64  `gorm:"column:available_balance; type:double precision"`
	CreatedAt        time.Time `gorm:"column:created_at; type:timestamp(6) with time zone; not null; default:CURRENT_TIMESTAMP"`

	Account Account `gorm:"foreignKey:AccountID"`
}

func (a *AccountBalance) TableName() string {
	return "account_balances"
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

func (a *AccountRepository) GetAccountBalanceAtDate(accountID uuid.UUID, targetDate time.Time) (decimal.Decimal, error) {
	type AccountBalance struct {
		CurrentBalance decimal.Decimal `gorm:"column:current_balance"`
	}
	var output AccountBalance
	err := a.db.Table("account_balances").
		Select("current_balance").
		Where("account_id = ?", accountID).
		Where("balance_date = ?", targetDate).
		First(&output).Error
	if err != nil {
		return decimal.NewFromFloat(0.0), err
	}

	fmt.Printf("output: %+v\n", output)

	return output.CurrentBalance, nil
}

func (a *AccountRepository) UpsertAccountBalancesBulk(balances []AccountBalance) error {
	if len(balances) == 0 {
		return nil
	}

	return a.db.Transaction(func(tx *gorm.DB) error {
		for _, balance := range balances {
			result := tx.Clauses(clause.OnConflict{
				Columns:   []clause.Column{{Name: "account_id"}, {Name: "balance_date"}},
				DoUpdates: clause.AssignmentColumns([]string{"current_balance", "available_balance", "created_at"}),
			}).Create(&balance)

			if result.Error != nil {
				return fmt.Errorf("failed to upsert account balance: %w", result.Error)
			}
		}
		return nil
	})
}

func (a *AccountRepository) GetAccountBalancesInDateRange(accountID uuid.UUID, startDate, endDate time.Time) ([]AccountBalance, error) {
	var balances []AccountBalance
	err := a.db.Where("account_id = ? AND balance_date BETWEEN ? AND ?", accountID, startDate, endDate).
		Order("balance_date DESC").
		Find(&balances).Error
	if err != nil {
		return nil, fmt.Errorf("failed to fetch account balances: %w", err)
	}
	return balances, nil
}
