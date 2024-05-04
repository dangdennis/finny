import Fluent
import Vapor

final class PlaidLinkEvent: Model {
    static let schema = "plaid_link_events"

    @ID(key: .id) var id: UUID?

    @Field(key: "type") var type: String

    @Parent(key: "user_id") var user: User

    @OptionalField(key: "link_session_id") var linkSessionID: String?

    @OptionalField(key: "request_id") var requestID: String?

    @OptionalField(key: "error_type") var errorType: String?

    @OptionalField(key: "error_code") var errorCode: String?

    @OptionalField(key: "status") var status: String?

    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        type: String,
        userID: UUID,
        linkSessionID: String?,
        requestID: String?,
        errorType: String?,
        errorCode: String?,
        status: String?
    ) {
        self.id = id
        self.type = type
        self.$user.id = userID
        self.linkSessionID = linkSessionID
        self.requestID = requestID
        self.errorType = errorType
        self.errorCode = errorCode
        self.status = status
    }
}
