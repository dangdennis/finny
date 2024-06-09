package main

import (
	"database/sql"
	"time"

	"github.com/jmoiron/sqlx"
)

func GetSyncStatus(user *User, db *sqlx.DB) (*SyncStatus, error) {
	syncStatus := SyncStatus{}
	err := db.Get(&syncStatus, "SELECT user_id, sync_seq, last_sync FROM sync_statuses WHERE user_id=$1", user.ID)
	if err != nil {
		if err == sql.ErrNoRows {
			db.Exec("INSERT INTO sync_statuses (user_id, sync_seq, last_sync) VALUES ($1, 0, $2)", user.ID, time.Now())
			return nil, err
		}

		return nil, err
	}

	return &syncStatus, nil
}

func IncrementSyncStatus(user *User, db *sqlx.DB) error {
	_, err := db.Exec("UPDATE sync_statuses SET sync_seq = sync_seq + 1, last_sync = $1 WHERE user_id=$2", time.Now(), user.ID)
	return err
}
