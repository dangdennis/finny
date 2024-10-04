package goal

import (
	"errors"
	"time"

	"github.com/finny/worker/account"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type GoalType string

const (
	RetirementGoalType GoalType = "retirement"
	CustomGoalType     GoalType = "custom"
)

type Goal struct {
	ID         uuid.UUID      `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	Name       string         `gorm:"type:text;not null"`
	Amount     float64        `gorm:"type:double precision;not null"`
	TargetDate time.Time      `gorm:"type:timestamp(6) with time zone;not null"`
	UserID     uuid.UUID      `gorm:"type:uuid;not null"`
	Progress   float64        `gorm:"type:double precision;not null;default:0"`
	CreatedAt  time.Time      `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	UpdatedAt  time.Time      `gorm:"type:timestamp(6) with time zone;not null;default:CURRENT_TIMESTAMP"`
	DeletedAt  gorm.DeletedAt `gorm:"type:timestamp(6) with time zone"`
	GoalType   string         `gorm:"type:text;default:'retirement'"`
}

type GoalAccount struct {
	ID         uuid.UUID      `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	GoalID     uuid.UUID      `gorm:"type:uuid;not null"`
	AccountID  uuid.UUID      `gorm:"type:uuid;not null"`
	Amount     float64        `gorm:"type:numeric(10,2);not null"`
	Percentage float64        `gorm:"type:numeric(5,2);not null"`
	CreatedAt  time.Time      `gorm:"type:timestamp without time zone;not null;default:CURRENT_TIMESTAMP"`
	UpdatedAt  time.Time      `gorm:"type:timestamp without time zone;not null;default:CURRENT_TIMESTAMP"`
	DeletedAt  gorm.DeletedAt `gorm:"type:timestamp without time zone"`

	// Goal    Goal    `gorm:"foreignKey:GoalID"`
	// Account Account `gorm:"foreignKey:AccountID"`
}
type GoalRepository struct {
	db          *gorm.DB
	accountRepo *account.AccountRepository
}

func NewGoalRepository(db *gorm.DB, accountRepo *account.AccountRepository) *GoalRepository {
	return &GoalRepository{
		db:          db,
		accountRepo: accountRepo,
	}
}

func (g *GoalRepository) GetAssignedBalanceOnRetirementGoal(userID uuid.UUID) (float64, error) {
	retGoal, err := g.GetRetirementGoal(userID)
	if err != nil {
		return 0, err
	}

	goalAccs, err := g.GetAssignedAccountsOnGoal(retGoal.ID)
	if err != nil {
		return 0, err
	}

	var balance float64
	for _, goalAcc := range goalAccs {
		account, err := g.accountRepo.GetAccount(goalAcc.AccountID)
		if err != nil {
			return 0, err
		}

		balance += account.CurrentBalance * (goalAcc.Percentage / 100)
	}

	return balance, nil
}

func (g *GoalRepository) GetRetirementGoal(userID uuid.UUID) (*Goal, error) {
	var item Goal
	err := g.db.Where("user_id = ?", userID).Where("goal_type = 'retirement'").First(&item).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &item, nil
}

func (g *GoalRepository) GetAssignedAccountsOnGoal(goalID uuid.UUID) ([]GoalAccount, error) {
	var goalAccounts []GoalAccount
	tx := g.db.Where("goal_id = ?", goalID).Find(&goalAccounts)
	if tx.Error != nil {
		if errors.Is(tx.Error, gorm.ErrRecordNotFound) {
			return goalAccounts, nil
		}
		return goalAccounts, tx.Error
	}

	return goalAccounts, nil
}
