#[macro_use]
extern crate rocket;

// #[cfg(test)]
// mod tests;

#[post("/sync")]
fn transactions_sync() -> &'static str {
    "Hello, world!"
}

#[get("/get")]
fn accounts_get() -> String {
    "".to_string()
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/accounts", routes![accounts_get])
        .mount("/transactions", routes![transactions_sync])
}
