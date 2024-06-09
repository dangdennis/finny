use crate::errors::AppError;
use ::entity::{users, users::Entity as User};
use sea_orm::*;

pub async fn get_users(db: &DbConn) -> Result<Vec<users::Model>, AppError> {
    let users = User::find().all(db).await?;
    Ok(users)
}

pub async fn create_user(db: &DbConn) -> Result<users::ActiveModel, AppError> {
    let user = users::ActiveModel {
        email: Set(Some("dennis.dang@hello.com".to_owned())),
        ..Default::default()
    }
    .save(db)
    .await?;

    Ok(user)
}
