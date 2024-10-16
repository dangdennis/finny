pub struct Config {
    pub budget_file: String,
    pub ignored_categories: Vec<String>,
}

impl Config {
    pub fn load() -> crate::error::Result<Self> {
        // Load configuration from file or environment
        Ok(Config {
            budget_file: "budget.json".to_string(),
            ignored_categories: vec![
                "Credit Card Payments".to_string(),
                "Internal Master Category".to_string(),
            ],
        })
    }
}
