package test_utils

import (
	"math/rand/v2"
	"time"

	"github.com/finny/finny-backend/internal/models"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

func CreateAuthUser(db *gorm.DB, email string, password string) (uuid.UUID, error) {
	userID := uuid.New()

	user := models.AuthUser{
		ID:                userID,
		Email:             email,
		EncryptedPassword: password, // Note: In a real-world scenario, you should hash the password before storing it.
		CreatedAt:         time.Now(),
		UpdatedAt:         time.Now(),
	}

	result := db.Create(&user)
	if result.Error != nil {
		return uuid.Nil, result.Error
	}

	return userID, nil
}

func CleanupAuthUser(db *gorm.DB, userID uuid.UUID) error {
	result := db.Where("id = ?", userID).Delete(&models.AuthUser{})
	if result.Error != nil {
		return result.Error
	}

	return nil
}

func GenerateRandomEmail() string {
	letters := "abcdefghijklmnopqrstuvwxyz"
	randomString := make([]byte, 10)
	for i := range randomString {
		randomString[i] = letters[rand.IntN(len(letters))]
	}
	return string(randomString) + "@example.com"
}

func GenerateRandomPassword() string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	password := make([]byte, 16)
	for i := range password {
		password[i] = charset[rand.IntN(len(charset))]
	}
	return string(password)
}
