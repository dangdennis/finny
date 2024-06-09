// use plaid::model::*;
use plaid::{PlaidAuth, PlaidClient};

use crate::errors::AppError;

pub enum Environment {
    Sandbox,
    Development,
    Production,
}

pub fn new_client(env: Environment) -> PlaidClient {
    let plaid_env = {
        match env {
            Environment::Sandbox => "sandbox",
            Environment::Development => "development",
            Environment::Production => "production",
        }
    };
    let url = format!("https://{plaid_env}.plaid.com");
    let client = httpclient::Client::new().base_url(&url);

    PlaidClient::new_with(
        client,
        PlaidAuth::ClientId {
            client_id: "661ac9375307a3001ba2ea46".to_string(),
            secret: "57ebac97c0bcf92f35878135d68793".to_string(),
            plaid_version: "2020-09-14".to_string(),
        },
    )
}

pub async fn get_plaid_transactions() -> Result<(), AppError> {
    let client = new_client(Environment::Sandbox);
    let response = client
        .transactions_sync("access-sandbox-09f74ffe-8b6a-433e-a5f3-883d7fe2ef76")
        .await;
    println!("{:#?}", response);
    Ok(())
}
