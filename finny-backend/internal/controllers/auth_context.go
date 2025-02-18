package controllers

import (
	"fmt"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

func GetContextUserID(c echo.Context) (uuid.UUID, error) {
	userInterface := c.Get("user")
	if userInterface == nil {
		return uuid.Nil, fmt.Errorf("No user found in context")
	}

	user, ok := userInterface.(*jwt.Token)
	if !ok {
		return uuid.Nil, fmt.Errorf("Invalid token type in context")
	}

	claims, ok := user.Claims.(jwt.MapClaims)
	if !ok {
		return uuid.Nil, fmt.Errorf("Invalid claims type in token")
	}

	sub, ok := claims["sub"].(string)
	if !ok {
		return uuid.Nil, fmt.Errorf("Invalid or missing sub claim in token")
	}

	userID, err := uuid.Parse(sub)
	if err != nil {
		return uuid.Nil, fmt.Errorf("Invalid user ID format: %v", err)
	}

	if userID == uuid.Nil {
		return uuid.Nil, fmt.Errorf("User not authenticated")
	}

	return userID, nil
}
