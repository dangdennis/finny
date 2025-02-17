package controllers

import (
	"fmt"

	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
)

func GetContextUserID(c echo.Context) (uuid.UUID, error) {
	user := c.Get("user").(*jwt.Token)
	claims := user.Claims.(jwt.MapClaims)
	sub := claims["sub"].(string)
	userID, err := uuid.Parse(sub)
	if err != nil {
		return uuid.Nil, fmt.Errorf("Invalid user ID format")
	}
	if userID == uuid.Nil {
		return uuid.Nil, fmt.Errorf("User not authenticated")
	}
	return userID, nil
}
