import Fluent

struct CreateTransaction: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("transactions")
      .id()
      .field("transaction_id", .string, .required)
      .field("account_id", .uuid, .required, .references("accounts", "id"))
      .field("amount", .double, .required)
      .field("iso_currency_code", .string, .required)
      .field("merchant_name", .string)
      .field("date", .datetime, .required)
      .field("category", .array(of: .string), .required)
      .field("location", .json)
      .field("created_at", .datetime)
      .field("updated_at", .datetime)
      .field("deleted_at", .datetime)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("transactions").delete()
  }
}
