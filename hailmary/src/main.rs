use hailmary::budget::Budget;
use hailmary::config::Config;
use hailmary::database;
use hailmary::error::Result;

#[tokio::main]
async fn main() -> Result<()> {
    dotenvy::dotenv().ok();
    let config = Config::load()?;
    let pool = database::create_pool().await?;
    let budget = Budget::from_database(&pool, uuid::Uuid::parse_str("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d").unwrap()).await?;
    let (inflow, outflow) = budget.calculate_spending(&config.ignored_categories)?;
    
    println!("Spending: inflow: ${:.2}, outflow: ${:.2}", inflow, outflow);
    println!("Total expense: ${:.2}", inflow + outflow);

    Ok(())
}
