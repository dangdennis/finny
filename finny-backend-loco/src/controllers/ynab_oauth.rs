use axum::{debug_handler, extract::Query};
use loco_rs::prelude::*;
use serde::{Deserialize, Serialize};
use reqwest::Client;

use crate::app::AppConfig;

const YNAB_AUTH_URL: &str = "https://app.youneedabudget.com/oauth/authorize";
const YNAB_TOKEN_URL: &str = "https://api.youneedabudget.com/oauth/token";

#[derive(Debug, Serialize)]
pub struct AuthUrlResponse {
    auth_url: String,
}

#[derive(Debug, Deserialize)]
pub struct OAuthCallbackParams {
    code: String,
    state: Option<String>,
}

#[derive(Debug, Deserialize)]
struct YNABTokenResponse {
    access_token: String,
    token_type: String,
    expires_in: i32,
    refresh_token: String,
}

#[derive(Debug, Serialize)]
pub struct TokenResponse {
    access_token: String,
    refresh_token: String,
    expires_in: i32,
}

/// Initiates the YNAB OAuth flow by generating and returning the authorization URL
#[debug_handler]
async fn authorize(State(ctx): State<AppContext>, State(config): State<AppConfig>) -> Result<Response> {
    let ynab_config = config.ynab
        .ok_or_else(|| Error::String("YNAB OAuth not configured".to_string()))?;

    let auth_url = format!(
        "{}?client_id={}&redirect_uri={}&response_type=code",
        YNAB_AUTH_URL,
        ynab_config.client_id,
        ynab_config.redirect_uri
    );

    format::json(AuthUrlResponse { auth_url })
}

/// Handles the OAuth callback from YNAB, exchanges the code for tokens
#[debug_handler]
async fn callback(
    State(ctx): State<AppContext>,
    State(config): State<AppConfig>,
    Query(params): Query<OAuthCallbackParams>,
) -> Result<Response> {
    let ynab_config = config.ynab
        .ok_or_else(|| Error::String("YNAB OAuth not configured".to_string()))?;

    let client = Client::new();
    let token_response = client
        .post(YNAB_TOKEN_URL)
        .form(&[
            ("client_id", ynab_config.client_id),
            ("client_secret", ynab_config.client_secret),
            ("redirect_uri", ynab_config.redirect_uri),
            ("grant_type", "authorization_code".to_string()),
            ("code", params.code),
        ])
        .send()
        .await?
        .json::<YNABTokenResponse>()
        .await?;

    // Here you would typically store the tokens in your database
    // associated with the current user
    
    format::json(TokenResponse {
        access_token: token_response.access_token,
        refresh_token: token_response.refresh_token,
        expires_in: token_response.expires_in,
    })
}

pub fn routes() -> Routes {
    Routes::new()
        .prefix("/api/ynab/oauth")
        .add("/authorize", get(authorize))
        .add("/callback", get(callback))
}
