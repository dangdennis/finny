package main

import (
	"errors"

	"github.com/golang-jwt/jwt/v5"
	"github.com/jmoiron/sqlx"
	"github.com/labstack/echo/v4"
)

func GetContextUser(c echo.Context, db *sqlx.DB) (*User, error) {
	token, ok := c.Get("user").(*jwt.Token)
	if !ok {
		return nil, errors.New("failed to cast token as jwt.Token")
	}
	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok {
		return nil, errors.New("failed to cast claims as jwt.MapClaims")
	}

	email, ok := claims["email"].(string)
	if !ok {
		return nil, errors.New("failed to cast email as string")
	}

	user := User{}
	err := db.Get(&user, "SELECT id, email FROM auth.users WHERE email=$1", email)
	if err != nil {
		return nil, err
	}

	return &user, nil
}
