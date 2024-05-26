use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    // #[error("DuckDB schema initialization error: {0}")]
    // SchemaInitError(String),
    #[error("DuckDB error: {0}")]
    DuckDBError(#[from] duckdb::Error),
    // #[error("Network error: {0}")]
    // NetworkError(String),
    // #[error("Unknown error")]
    // Unknown,
}
