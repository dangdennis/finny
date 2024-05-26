use std::sync::Arc;

use duckdb::Connection;
use tauri::async_runtime::Mutex;

pub struct AppState {
    pub db_conn: Arc<Mutex<Connection>>,
}
