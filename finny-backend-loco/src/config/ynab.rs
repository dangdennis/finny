use serde::Deserialize;

#[derive(Debug, Deserialize, Clone)]
pub struct YnabOAuthConfig {
    pub client_id: String,
    pub client_secret: String,
    pub redirect_uri: String,
}

impl YnabOAuthConfig {
    pub fn from_config(config: &loco_rs::config::Config) -> Option<Self> {
        Some(Self {
            client_id: config.get("YNAB_CLIENT_ID")?,
            client_secret: config.get("YNAB_CLIENT_SECRET")?,
            redirect_uri: config.get("YNAB_REDIRECT_URI")?,
        })
    }
}
