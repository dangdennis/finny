use std::sync::Arc;

use app_state::AppState;
use tauri::{async_runtime::Mutex, Manager};

mod app_state;
mod db;
mod errors;
mod plaid;

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() -> Result<(), tauri::Error> {
    let db_conn = duckdb::Connection::open_in_memory().expect("Failed to open DuckDB connection");

    db::init_db_schema(&db_conn).expect("Failed to initialize database schema");

    let app_state = AppState {
        db_conn: Arc::new(Mutex::new(db_conn)),
    };

    tauri::Builder::default()
        .manage(app_state)
        .plugin(tauri_plugin_shell::init())
        .plugin(tauri_plugin_store::Builder::new().build())
        .invoke_handler(tauri::generate_handler![greet, get_users])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");

    Ok(())
}

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

// #[tauri::command]
// async fn create_user(state: State<'_, Mutex<AppState>>) -> Result<(), ()> {
//     println!("run query");

//     db::create_user(state.db_conn.lock().await).unwrap_or_else(|error| {
//         println!("Error: {:?}", error);
//     });

//     Ok(())
// }

#[tauri::command]
async fn get_users(app: tauri::AppHandle) -> Result<(), ()> {
    println!("print users");

    let state_mutex = app.state::<Mutex<AppState>>();
    let state = state_mutex.lock().await;
    let conn = state.db_conn.lock().await;
    db::get_users(&conn).unwrap();

    Ok(())
}
