use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("Plaid error: {0}")]
    PlaidError(#[from] plaid::Error),
}
