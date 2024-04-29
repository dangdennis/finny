import Fluent
import Vapor

final class PlaidItem: Model, Content {
  static let schema = "plaid_items"

  @ID(key: .id)
  var id: UUID?

  @Parent(key: "user_id")
  var user: User

  @Field(key: "plaid_access_token")
  var plaidAccessToken: String

  @Field(key: "plaid_item_id")
  var plaidItemId: String

  @Field(key: "plaid_institution_id")
  var plaidInstitutionId: String

  @Field(key: "status")
  var status: String

  @OptionalField(key: "transactions_cursor")
  var transactionsCursor: String?

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?

  init() {}

  init(
    id: UUID? = nil, userId: User.IDValue, plaidAccessToken: String, plaidItemId: String,
    plaidInstitutionId: String, status: String, transactionsCursor: String?
  ) {
    self.id = id
    self.$user.id = userId
    self.plaidAccessToken = plaidAccessToken
    self.plaidItemId = plaidItemId
    self.plaidInstitutionId = plaidInstitutionId
    self.status = status
    self.transactionsCursor = transactionsCursor
  }
}
