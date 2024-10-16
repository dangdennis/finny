use chrono::{DateTime, NaiveDate};
use hailmary::profile::Profile;
use uuid::Uuid;

#[test]
fn test_years_to_retirement() {
    let p = Profile {
        date_of_birth: NaiveDate::from_ymd_opt(1994, 04, 09).unwrap(),
        deleted_at: None,
        fire_profile: String::new(),
        id: Uuid::new_v4(),
        retirement_age: 65,
        risk_profile: String::new(),
    };

    let now = DateTime::parse_from_rfc3339("2024-10-16T00:00:00Z")
        .unwrap()
        .with_timezone(&chrono::Utc);

    assert_eq!(p.years_to_retirement(now), 35);
}
