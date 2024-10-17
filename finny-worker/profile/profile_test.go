package profile

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestProfile(t *testing.T) {
	t.Run("YearsToRetirement", func(t *testing.T) {
		p := Profile{
			DateOfBirth: time.Date(2000, time.January, 1, 0, 0, 0, 0, time.UTC),
		}
		assert.Equal(t, 0, p.YearsToRetirement())
		p.RetirementAge = 65
		assert.Equal(t, 41, p.YearsToRetirement())
	})
}
