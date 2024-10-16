use crate::error::Result;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct Budget {
    data: BudgetData,
}

#[derive(Serialize, Deserialize)]
struct BudgetData {
    category_groups: Vec<CategoryGroup>,
}

#[derive(Serialize, Deserialize)]
struct CategoryGroup {
    categories: Vec<Category>,
}

#[derive(Serialize, Deserialize)]
struct Category {
    activity: f64,
    category_group_name: String,
    name: String,
}

impl Budget {
    pub fn calculate_spending(&self, ignored_categories: &[String]) -> Result<(f64, f64)> {
        let mut positive_category_sum = 0.0;
        let mut negative_category_sum = 0.0;

        for group in &self.data.category_groups {
            for category in &group.categories {
                if category.activity > 0.0 {
                    if !ignored_categories.contains(&category.category_group_name) {
                        positive_category_sum += category.activity;
                    }
                } else {
                    negative_category_sum += category.activity;
                }
            }
        }

        let actual_inflow = positive_category_sum / 1000.0;
        let actual_outflow = negative_category_sum / 1000.0;

        println!(
            "spending: positive: ${:.2}, negative: ${:.2}",
            actual_inflow, actual_outflow
        );

        let total_spending = actual_inflow + actual_outflow;

        println!("total expense ${:.2}", total_spending);

        Ok((actual_inflow, actual_outflow))
    }

    pub fn from_file(path: &str) -> Result<Budget> {
        let json_data = std::fs::read_to_string(path)?;
        Ok(serde_json::from_str(&json_data)?)
    }
}
