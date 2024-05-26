use duckdb::Connection;
use std::sync::Arc;
use tauri::{async_runtime::Mutex, State};

mod db;
mod errors;
mod plaid;

pub struct DbConnection {
    pub db: Arc<Mutex<Connection>>,
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() -> Result<(), tauri::Error> {
    let invoke_handler = {
        let builder = tauri_specta::ts::builder().commands(tauri_specta::collect_commands![
            greet,
            get_users,
            create_user
        ]);

        #[cfg(debug_assertions)] // <- Only export on non-release builds
        let builder = builder.path("../frontend/bindings.ts");

        builder.build().unwrap()
    };

    let db_conn = duckdb::Connection::open_in_memory().expect("Failed to open DuckDB connection");
    db::init_db_schema(&db_conn).expect("Failed to initialize database schema");

    tauri::Builder::default()
        .invoke_handler(invoke_handler)
        .manage(DbConnection {
            db: Arc::new(Mutex::new(db_conn)),
        })
        .plugin(tauri_plugin_shell::init())
        .plugin(tauri_plugin_store::Builder::new().build())
        .invoke_handler(tauri::generate_handler![greet, get_users, create_user])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");

    Ok(())
}

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
#[specta::specta]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
#[specta::specta]
async fn create_user(state: State<'_, DbConnection>) -> Result<(), ()> {
    println!("run query");
    let conn = state.db.lock().await;
    db::create_user(&conn).unwrap_or_else(|error| {
        println!("Error: {:?}", error);
    });

    Ok(())
}

#[tauri::command]
#[specta::specta]
async fn get_users(state: State<'_, DbConnection>) -> Result<(), ()> {
    let conn = state.db.lock().await;
    db::get_users(&conn).unwrap();

    Ok(())
}
