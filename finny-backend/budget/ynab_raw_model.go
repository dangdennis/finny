package budget

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/datatypes"
)

type YnabRaw struct {
	ID                              uuid.UUID      `gorm:"type:uuid;primary_key;default:gen_random_uuid()"`
	CategoriesJSON                  datatypes.JSON `gorm:"column:categories_json;type:jsonb"`
	UserID                          uuid.UUID      `gorm:"type:uuid;not null"`
	CategoriesLastKnowledgeOfServer int
	CategoriesLastUpdated           time.Time
}

func (YnabRaw) TableName() string {
	return "ynab_raw"
}
