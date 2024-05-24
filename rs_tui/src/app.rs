use httpclient;
use plaid::model::*;
use plaid::PlaidAuth;
use plaid::PlaidClient;
use std::error;

/// Application result type.
pub type AppResult<T> = std::result::Result<T, Box<dyn error::Error>>;

/// Application.
#[derive(Debug)]
pub struct App {
    /// Is the application running?
    pub running: bool,
    /// counter
    pub counter: u8,

    pub institutions: Vec<Institution>,
}

impl Default for App {
    fn default() -> Self {
        Self {
            running: true,
            counter: 0,
            institutions: Vec::new(),
        }
    }
}

impl App {
    /// Constructs a new instance of [`App`].
    pub fn new() -> Self {
        Self::default()
    }

    /// Handles the tick event of the terminal.
    pub fn tick(&self) {}

    /// Set running to false to quit the application.
    pub fn quit(&mut self) {
        self.running = false;
    }

    pub fn increment_counter(&mut self) {
        if let Some(res) = self.counter.checked_add(1) {
            self.counter = res;
        }
    }

    pub fn decrement_counter(&mut self) {
        if let Some(res) = self.counter.checked_sub(1) {
            self.counter = res;
        }
    }

    pub async fn get_transactions(&mut self) {
        // get transactions from the database
        let url = format!("https://sandbox.plaid.com");
        let http_client = httpclient::Client::new().base_url(&url);
        let client = PlaidClient::new_with(
            http_client,
            PlaidAuth::ClientId {
                client_id: "x".to_string(),
                secret: "x".to_string(),
                plaid_version: "2020-09-14".to_string(),
            },
        );
        let response = client.institutions_get(20, &["US", "CA"], 0).await.unwrap();
        self.institutions = response.institutions;
    }
}
