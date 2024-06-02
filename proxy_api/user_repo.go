package main

import "github.com/jmoiron/sqlx"

type User struct {
	ID    string `db:"id"`
	Email string `db:"email"`
}

func GetUserByEmail(email string, db *sqlx.DB) (*User, error) {
	user := User{}
	err := db.Get(&user, "SELECT id, email FROM auth.users WHERE email=$1", email)
	if err != nil {
		return nil, err
	}

	return &user, nil
}
