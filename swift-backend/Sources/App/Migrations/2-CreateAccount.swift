import Fluent

struct CreateAccount: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("accounts")
      .id()
      .field("account_id", .string, .required)
      .field("mask", .string)
      .field("name", .string, .required)
      .field("official_name", .string)
      .field("type", .string, .required)
      .field("subtype", .string)
      .field("balance", .double, .required)
      .field("created_at", .datetime, .required)
      .field("updated_at", .datetime)
      .field("deleted_at", .datetime)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("accounts").delete()
  }
}
