package goal

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type GoalType string

const (
	RetirementGoalType GoalType = "retirement"
	CustomGoalType     GoalType = "custom"
)

type Goal struct {
	ID         uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
	Name       string    `gorm:"type:text;not null"`
	Amount     float64   `gorm:"type:double precision;not null"`
	TargetDate time.Time `gorm:"column:target_date;type:timestamp(6) with time zone;not null"`
	GoalType   string    `gorm:"column:goal_type;type:text;not null"`
}

type GoalRepository struct {
	db *gorm.DB
}

func NewGoalRepository(db *gorm.DB) *GoalRepository {
	return &GoalRepository{
		db: db,
	}
}

func (g *GoalRepository) GetAssignedBalanceOnRetirementGoal(userId uuid.UUID) (float64, error) {
	return 0, nil
}

func (g *GoalRepository) GetRetirementGoal(userId uuid.UUID) (*Goal, error) {
	var item Goal
	err := g.db.Where("user_id = ?", userId).Where("goal_type = 'retirement'").First(&item).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}
	return &item, nil
}
