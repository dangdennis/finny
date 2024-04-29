import Fluent
import FluentPostgresDriver

extension Transaction {
  struct Migration: AsyncMigration {
    func prepare(on database: Database) async throws {
      try await database.schema("transactions")
        .id()
        .field(
          "account_id", .uuid, .required, .references("accounts", "id")
        )
        .field("plaid_transaction_id", .string, .required)
        .unique(on: "plaid_transaction_id")
        .field("plaid_category_id", .string)
        .field("category", .string)
        .field("subcategory", .string)
        .field("type", .string, .required)
        .field("name", .string, .required)
        .field("amount", .double, .required)
        .field("iso_currency_code", .string)
        .field("unofficial_currency_code", .string)
        .field("date", .date, .required)
        .field("pending", .bool, .required)
        .field("account_owner", .string)
        .field("created_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
        .field("updated_at", .datetime, .required, .sql(.default(SQLFunction("now"))))
        .field("deleted_at", .datetime)
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema("transactions").delete()
    }
  }
}
