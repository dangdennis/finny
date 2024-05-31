use ::plaid::model::TransactionsSyncResponse;
use rocket::{http::Status, response::Redirect};

use std::io;

#[macro_use]
extern crate rocket;

// #[cfg(test)]
// mod tests;
mod plaid;

#[get("/redir/<name>")]
fn maybe_redir(name: &str) -> Result<&'static str, Redirect> {
    match name {
        "Sergio" => Ok("Hello, Sergio!"),
        _ => Err(Redirect::to(uri!(""))),
    }
}

#[post("/sync")]
async fn transactions_sync() -> Result<TransactionsSyncResponse, Redirect> {
    let transactions = plaid::get_plaid_transactions()
        .await
        .map_err(|err| Status::BadRequest);

    (Status::BadRequest, Err(()))
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
