use crate::error::Result;
use serde::{Deserialize, Serialize};
use sqlx::PgPool;
use sqlx::Row;
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
pub struct Budget {
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

#[derive(Serialize, Deserialize)]
struct BudgetSql {
    data: Budget
}

impl Budget {
    pub fn calculate_spending(&self, ignored_categories: &[String]) -> Result<(f64, f64)> {
        let mut positive_category_sum = 0.0;
        let mut negative_category_sum = 0.0;

        for group in &self.category_groups {
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

    pub async fn from_database(pool: &PgPool, user_id: Uuid) -> Result<Budget> {
        let row =
            sqlx::query("SELECT categories_json FROM ynab_raw WHERE user_id = $1")
                .bind(user_id)
                .fetch_one(pool) 
                .await?;

        let categories_json: serde_json::Value = row.try_get("categories_json")?;
                
        let budget_data: BudgetSql = serde_json::from_value(categories_json)?;

        Ok(Budget {
            category_groups: budget_data.data.category_groups,
        })
    }
}
