package profile

import (
	"errors"
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

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

func (p *Profile) YearsToRetirement() int {
	currentAge := p.Age()
	yearsToRetirement := p.RetirementAge - currentAge

	// Return 0 if already past retirement age
	if yearsToRetirement < 0 {
		return 0
	}

	return yearsToRetirement
}

type ProfileRepository struct {
	db *gorm.DB
}

func NewProfileRepository(db *gorm.DB) *ProfileRepository {
	return &ProfileRepository{
		db: db,
	}
}

func (s *ProfileRepository) GetProfile(userId uuid.UUID) (*Profile, error) {
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
