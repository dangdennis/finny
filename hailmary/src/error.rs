use thiserror::Error;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Database error: {0}")]
    DatabaseError(#[from] sqlx::Error),

    #[error("JSON error: {0}")]
    JsonError(#[from] serde_json::Error),

    #[error("IO error: {0}")]
    IoError(#[from] std::io::Error),

    #[error("Parse error: {0}")]
    UuidParseError(uuid::Error),

    #[error("Error: {0}")]
    ServerError(#[from] anyhow::Error),
    // Add other error variants as needed
}

pub type Result<T> = std::result::Result<T, Error>;
