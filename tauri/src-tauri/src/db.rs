use duckdb::{params, Connection, Result};

#[derive(Debug)]
struct Person {
    id: i32,
    name: String,
    data: Option<Vec<u8>>,
}

pub fn run_query() -> Result<(), duckdb::Error> {
    let conn = Connection::open_in_memory()?;

    let me = Person {
        id: 0,
        name: "Alice".to_string(),
        data: None,
    };

    conn.execute(
        r"
        CREATE SEQUENCE IF NOT EXISTS person_id_seq;",
        params![],
    )?;

    conn.execute(
        r"
        CREATE TABLE IF NOT EXISTS person (
            id INTEGER PRIMARY KEY DEFAULT NEXTVAL('person_id_seq') ,
            name TEXT NOT NULL,
            data BLOB
        )",
        params![],
    )?;

    conn.execute(
        "INSERT INTO person (name, data) VALUES (?, ?)",
        params![me.name, me.data],
    )?;

    let mut stmt = conn.prepare("SELECT id, name, data FROM person")?;
    let person_iter = stmt.query_map([], |row| {
        Ok(Person {
            id: row.get(0)?,
            name: row.get(1)?,
            data: row.get(2)?,
        })
    })?;

    for person in person_iter {
        println!("Found person {:?}", person.unwrap());
    }

    Ok(())
}
