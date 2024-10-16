use chrono::{DateTime, Datelike, NaiveDate, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct Profile {
    pub id: Uuid,
    pub deleted_at: Option<DateTime<Utc>>,
    pub date_of_birth: NaiveDate,
    pub retirement_age: i32,
    pub risk_profile: String,
    pub fire_profile: String,
}

impl Profile {
    pub fn years_to_retirement(&self, now: DateTime<Utc>) -> i32 {
        let current_date = now.date_naive();
        let age = current_date.year() - self.date_of_birth.year();

        // Adjust age if birthday hasn't occurred this year
        let current_age = if current_date.ordinal() < self.date_of_birth.ordinal() {
            age - 1
        } else {
            age
        };

        self.retirement_age - current_age
    }
}
