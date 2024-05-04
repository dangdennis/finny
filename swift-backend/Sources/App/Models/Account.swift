import Fluent
import Vapor

final class Account: Model, Content {
    static let schema = "accounts"

    @ID(key: .id) var id: UUID?

    @Parent(key: "item_id") var item: PlaidItem

    @Field(key: "plaid_account_id") var plaidAccountId: String

    @Field(key: "name") var name: String

    @Field(key: "mask") var mask: String?

    @OptionalField(key: "official_name") var officialName: String?

    @OptionalField(key: "current_balance") var currentBalance: Decimal?

    @OptionalField(key: "available_balance") var availableBalance: Decimal?

    @OptionalField(key: "iso_currency_code") var isoCurrencyCode: String?

    @OptionalField(key: "unofficial_currency_code") var unofficialCurrencyCode: String?

    @OptionalField(key: "type") var type: String?

    @OptionalField(key: "subtype") var subtype: String?

    @Timestamp(key: "created_at", on: .create) var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update) var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete) var deletedAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        itemId: UUID,
        plaidAccountId: String,
        name: String,
        mask: String?,
        officialName: String?,
        currentBalance: Decimal?,
        availableBalance: Decimal?,
        isoCurrencyCode: String?,
        unofficialCurrencyCode: String?,
        type: String?,
        subtype: String?
    ) {
        self.id = id
        self.$item.id = itemId
        self.plaidAccountId = plaidAccountId
        self.name = name
        self.mask = mask
        self.officialName = officialName
        self.currentBalance = currentBalance
        self.availableBalance = availableBalance
        self.isoCurrencyCode = isoCurrencyCode
        self.unofficialCurrencyCode = unofficialCurrencyCode
        self.type = type
        self.subtype = subtype
    }

}
