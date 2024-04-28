import Fluent
import Vapor

final class TransactionDb: Model, Content {
  static let schema = "transactions"

  @ID(key: .id)
  var id: UUID?

  @Parent(key: "account_id")
  var account: AccountDb

  @Field(key: "plaid_transaction_id")
  var plaidTransactionId: String

  @OptionalField(key: "plaid_category_id")
  var plaidCategoryId: String?

  @OptionalField(key: "category")
  var category: String?

  @OptionalField(key: "subcategory")
  var subcategory: String?

  @Field(key: "type")
  var type: String

  @Field(key: "name")
  var name: String

  @Field(key: "amount")
  var amount: Decimal

  @OptionalField(key: "iso_currency_code")
  var isoCurrencyCode: String?

  @OptionalField(key: "unofficial_currency_code")
  var unofficialCurrencyCode: String?

  @Field(key: "date")
  var date: Date

  @Field(key: "pending")
  var pending: Bool

  @OptionalField(key: "account_owner")
  var accountOwner: String?

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?

  init() {}

  init(
    id: UUID? = nil, accountId: UUID, plaidTransactionId: String, plaidCategoryId: String?,
    category: String?,
    subcategory: String?, type: String, name: String, amount: Decimal, isoCurrencyCode: String?,
    unofficialCurrencyCode: String?, date: Date, pending: Bool, accountOwner: String?
  ) {
    self.id = id
    self.$account.id = accountId
    self.plaidTransactionId = plaidTransactionId
    self.plaidCategoryId = plaidCategoryId
    self.category = category
    self.subcategory = subcategory
    self.type = type
    self.name = name
    self.amount = amount
    self.isoCurrencyCode = isoCurrencyCode
    self.unofficialCurrencyCode = unofficialCurrencyCode
    self.date = date
    self.pending = pending
    self.accountOwner = accountOwner
  }
}
