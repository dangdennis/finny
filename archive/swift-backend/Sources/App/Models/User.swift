import Fluent
import Vapor

final class User: Model, Authenticatable {
    static let schema = "users"

    @ID(key: .id) var id: UUID?

    @Field(key: "email") var email: String

    @OptionalField(key: "password_hash") var passwordHash: String?

    @OptionalField(key: "apple_sub") var appleSub: String?

    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, email: String, passwordHash: String) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
    }

    init(id: UUID? = nil, email: String, appleSub: String) {
        self.id = id
        self.email = email
        self.appleSub = appleSub
    }
}
