import Fluent
import Vapor

final class AssetDb: Model, Content {
  static let schema = "assets"

  @ID(key: .id)
  var id: UUID?

  @Parent(key: "user_id")
  var user: UserDb

  @Field(key: "value")
  var value: Decimal

  @Field(key: "description")
  var description: String

  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?

  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?

  @Timestamp(key: "deleted_at", on: .delete)
  var deletedAt: Date?

  init() {}

  init(
    id: UUID? = nil, userId: UUID, value: Decimal, description: String
  ) {
    self.id = id
    self.$user.id = userId
    self.value = value
    self.description = description
  }
}
