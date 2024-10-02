package database

import (
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func NewDatabase(url string) (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open(url), &gorm.Config{})
	if err != nil {
		return nil, err
	}
	return db, nil
}

func NewTestDatabase() (*gorm.DB, error) {
	db, err := NewDatabase("postgres://postgres:postgres@localhost:54322/postgres")
	if err != nil {
		return nil, err
	}
	return db, nil
}
