import Fluent
import Vapor

final class Account: Model, Content {
  static let schema = "accounts"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "account_id")
  var accountId: String

  @Field(key: "mask")
  var mask: String

  @Field(key: "name")
  var name: String

  @OptionalField(key: "official_name")
  var officialName: String?

  @Field(key: "type")
  var type: String

  @OptionalField(key: "subtype")
  var subtype: String?

  @Field(key: "balance")
  var balance: Double

  @Children(for: \.$account)
  var transactions: [Transaction]

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?
}
