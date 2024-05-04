import Fluent
import Vapor

final class Asset: Model {
    static let schema = "assets"

    @ID(key: .id) var id: UUID?

    @Parent(key: "user_id") var user: User

    @Field(key: "value") var value: Double

    @Field(key: "description") var description: String

    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, userID: UUID, value: Double, description: String) {
        self.id = id
        self.$user.id = userID
        self.value = value
        self.description = description
    }
}
