import Fluent
import Vapor

final class PlaidApiEvent: Model, Content {
    static let schema = "plaid_api_events"

    @ID(key: .id)
    var id: UUID?

    @OptionalParent(key: "item_id")
    var item: PlaidItem?

    @OptionalParent(key: "user_id")
    var user: User?

    @Field(key: "plaid_method")
    var plaidMethod: String

    @OptionalField(key: "arguments")
    var arguments: String?

    @OptionalField(key: "request_id")
    var requestId: String?

    @OptionalField(key: "error_type")
    var errorType: String?

    @OptionalField(key: "error_code")
    var errorCode: String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() {}

    init(
        id: UUID? = nil, itemId: PlaidItem.IDValue?, userId: User.IDValue?, plaidMethod: String,
        arguments: String?,
        requestId: String?, errorType: String?, errorCode: String?
    ) {
        self.id = id
        self.$item.id = itemId
        self.$user.id = userId
        self.plaidMethod = plaidMethod
        self.arguments = arguments
        self.requestId = requestId
        self.errorType = errorType
        self.errorCode = errorCode
    }
}
