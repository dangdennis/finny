use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("DuckDB error: {0}")]
    DuckDBError(#[from] duckdb::Error),

    #[error("Plaid error: {0}")]
    PlaidError(#[from] plaid::Error),
}
