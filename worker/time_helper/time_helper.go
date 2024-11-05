package time_helper

import (
	"time"
)

func Now() time.Time {
	return time.Now().UTC()
}

// FirstDayOfMonth returns the first day of the month for the given date in UTC.
func FirstDayOfMonth(date time.Time) time.Time {
	y, m, _ := date.Date()
	return time.Date(y, m, 1, 0, 0, 0, 0, date.UTC().Location())
}
