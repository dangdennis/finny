use crate::errors::AppError;
use anyhow::Result;
use log::info;
use sea_orm::{ConnectionTrait, Statement};
// use tauri::path::BaseDirectory::Data;
// use std::path::PathBuf;

// fn get_database_path() -> PathBuf {
//     // Get the AppData directory for your application
//     let app_data_path = app:
//         app_data_dir(&tauri::Config::default()).expect("Failed to get app data directory");
//     // Create the full path for your SQLite database
//     let db_path = app_data_path.join("my_app").join("database.sqlite");
//     db_path
// }

pub async fn init_connection(app_data_dir: Option<&str>) -> Result<sea_orm::DbConn, AppError> {
    let db_path = {
        match app_data_dir {
            Some(dir) => {
                let mut path = std::path::PathBuf::new();
                path.push(dir);
                path.push("my_app");
                path.push("database.sqlite");
                path
            }
            None => {
                let mut path = std::path::PathBuf::new();
                path.push("sqlite::memory:");
                path
            }
        }
    };

    let db = sea_orm::Database::connect(db_path.to_str().unwrap_or("sqlite::memory:")).await?;

    info!("Opened connection to sqlite");

    Ok(db)
}

pub fn init_db_schema(conn: &sea_orm::DbConn) -> Result<(), AppError> {
    // conn.execute(
    //     r"
    //     CREATE SEQUENCE IF NOT EXISTS users_id_seq;",
    //     params![],
    // )?;

    // conn.execute(
    //     r"
    //     CREATE TABLE IF NOT EXISTS users (
    //         id INTEGER PRIMARY KEY DEFAULT NEXTVAL('users_id_seq') ,
    //         name TEXT NOT NULL,
    //         data BLOB
    //     )",
    //     params![],
    // )?;

    Ok(())
}

pub fn create_user(conn: &sea_orm::DbConn) -> Result<(), AppError> {
    // let me = User {
    //     id: 0,
    //     name: "Alice".to_string(),
    //     data: None,
    // };

    // conn.execute(Statement {
    //     db_backend: sea_orm::DbBackend::Postgres,
    //     sql: "INSERT INTO users (name, data) VALUES ($1, $2)",
    //     values: Some(sea_orm::Values::from(vec![sea_query me.name, me.data])),
    // })
    // .await?;

    Ok(())
}

pub fn get_users(conn: &sea_orm::DbConn) -> Result<(), AppError> {
    // let mut stmt = conn.prepare("SELECT id, name, data FROM users")?;
    // let user_iter = stmt.query_map([], |row| {
    //     Ok(User {
    //         id: row.get(0)?,
    //         name: row.get(1)?,
    //         data: row.get(2)?,
    //     })
    // })?;

    // for user in user_iter {
    //     println!("Found user {:?}", user.unwrap());
    // }

    Ok(())
}
