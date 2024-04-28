import Fluent
import FluentPostgresDriver

struct CreateAccount: AsyncMigration {
  func prepare(on database: Database) async throws {
    try await database.schema("accounts")
      .id()
      .field("item_id", .uuid, .required, .references("plaid_items", "id"))
      .field("plaid_account_id", .string, .required)
      .unique(on: "plaid_account_id")
      .field("name", .string, .required)
      .field("mask", .string, .required)
      .field("official_name", .string)
      .field("current_balance", .double)
      .field("available_balance", .double)
      .field("iso_currency_code", .string)
      .field("unofficial_currency_code", .string)
      .field("type", .string, .required)
      .field("subtype", .string, .required)
      .field("created_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
      .field("updated_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
      .field("deleted_at", .datetime)
      .create()
  }

  func revert(on database: Database) async throws {
    try await database.schema("accounts").delete()
  }
}
