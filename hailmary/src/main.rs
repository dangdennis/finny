use axum::{response::IntoResponse, routing::get, Router};
use hailmary::budget::Budget;
use hailmary::config::Config;
use hailmary::database;
use hailmary::error::Result;

#[tokio::main]
async fn main() -> Result<()> {
    dotenvy::dotenv().ok();
    let config = Config::load()?;
    let pool = database::create_pool().await?;
    let budget = Budget::from_database(
        &pool,
        uuid::Uuid::parse_str("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d").unwrap(),
    )
    .await?;
    let (inflow, outflow) = budget.calculate_spending(&config.ignored_categories)?;

    println!("Spending: inflow: ${:.2}, outflow: ${:.2}", inflow, outflow);
    println!("Total expense: ${:.2}", inflow + outflow);

    println!("Server is running on http://0.0.0.0:8080");

    let app = Router::new().route("/health", get(health_check)); // Added health check route
    axum::Server::bind(&"0.0.0.0:8080".parse().unwrap()) // Listening on port 8080
        .serve(app.into_make_service())
        .await
        .unwrap();

    Ok(())
}

async fn health_check() -> impl IntoResponse {
    "Healthy"
}
