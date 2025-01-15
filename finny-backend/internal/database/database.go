package database

import (
	"fmt"
	"net/url"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func NewDatabase(databaseURL string) (*gorm.DB, error) {
	u, err := url.Parse(databaseURL)
	if err != nil {
		return nil, fmt.Errorf("failed to parse database URL: %w", err)
	}

	password, _ := u.User.Password()
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s",
		u.Hostname(),
		u.Port(),
		u.User.Username(),
		password,
		u.Path[1:], // remove leading '/'
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Error),
	})
	if err != nil {
		return nil, err
	}
	return db, nil
}
