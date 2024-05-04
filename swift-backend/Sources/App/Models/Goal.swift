@preconcurrency import Fluent

final class Goal: Model {
    static let schema = "goals"

    @ID(key: .id) var id: UUID?

    @Field(key: "name") var name: String

    @Field(key: "amount") var amount: Double

    @Field(key: "target_date") var targetDate: Date

    @Field(key: "user_id") var user: User

    @Field(key: "progress") var progress: Double

    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        amount: Double,
        targetDate: Date,
        userId: User.IDValue,
        progress: Double = 0
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.targetDate = targetDate
        self.user.id = userId
        self.progress = progress
    }
}
