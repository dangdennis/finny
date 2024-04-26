import Fluent
import Vapor

final class Transaction: Model, Content {
  static let schema = "transactions"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "transaction_id")
  var transactionId: String

  @Parent(key: "account_id")
  var account: Account

  @Field(key: "amount")
  var amount: Double

  @Field(key: "iso_currency_code")
  var isoCurrencyCode: String

  @OptionalField(key: "merchant_name")
  var merchantName: String?

  @Field(key: "date")
  var date: Date

  @Field(key: "category")
  var category: [String]

  @OptionalField(key: "location")
  var location: Location?

  // Timestamps
  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?
}

struct Location: Codable {
  var street: String?
  var city: String?
  var postalCode: String?
  var country: String?
}
