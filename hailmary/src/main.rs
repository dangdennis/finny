use hailmary::budget::Budget;
use hailmary::config::Config;
use hailmary::error::Result;

fn main() -> Result<()> {
    let config = Config::load()?;
    let budget = Budget::from_file(&config.budget_file)?;
    let (inflow, outflow) = budget.calculate_spending(&config.ignored_categories)?;

    println!("Spending: inflow: ${:.2}, outflow: ${:.2}", inflow, outflow);
    println!("Total expense: ${:.2}", inflow + outflow);

    Ok(())
}
