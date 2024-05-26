use anyhow::Result;
use duckdb::{params, Connection};

use crate::errors::AppError;

#[derive(Debug)]
struct User {
    id: i32,
    name: String,
    data: Option<Vec<u8>>,
}

pub fn init_db_schema(conn: &Connection) -> Result<(), AppError> {
    conn.execute(
        r"
        CREATE SEQUENCE IF NOT EXISTS users_id_seq;",
        params![],
    )?;

    conn.execute(
        r"
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY DEFAULT NEXTVAL('users_id_seq') ,
            name TEXT NOT NULL,
            data BLOB
        )",
        params![],
    )?;

    Ok(())
}

pub fn create_user(conn: &duckdb::Connection) -> Result<(), AppError> {
    let me = User {
        id: 0,
        name: "Alice".to_string(),
        data: None,
    };

    conn.execute(
        "INSERT INTO users (name, data) VALUES (?, ?)",
        params![me.name, me.data],
    )?;

    Ok(())
}

pub fn get_users(conn: &duckdb::Connection) -> Result<(), AppError> {
    let mut stmt = conn.prepare("SELECT id, name, data FROM users")?;
    let user_iter = stmt.query_map([], |row| {
        Ok(User {
            id: row.get(0)?,
            name: row.get(1)?,
            data: row.get(2)?,
        })
    })?;

    for user in user_iter {
        println!("Found user {:?}", user.unwrap());
    }

    Ok(())
}
