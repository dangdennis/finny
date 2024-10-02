package database

import (
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func NewDatabase(url string) (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open(url), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Error),
	})
	if err != nil {
		return nil, err
	}
	return db, nil
}

// NewTestDatabase connects to Supabase.
func NewTestDatabase() (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open("postgres://postgres:postgres@localhost:54322/postgres"), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		return nil, err
	}
	return db, nil
}

// NewTestCalcDatabase uses a local db that is a clone of production data.
func NewTestCalcDatabase() (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open("postgres://postgres:postgres@localhost:5432/postgres"), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		return nil, err
	}
	return db, nil
}
