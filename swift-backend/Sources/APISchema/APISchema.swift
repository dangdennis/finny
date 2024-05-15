import Foundation
import Vapor

public protocol DataContaining: Content {
    associatedtype DataType: Content
    var data: DataType { get }
}

public struct ListAccountsResponse: DataContaining {
    public let data: [AccountDTO]

    public init(data: [AccountDTO]) {
        self.data = data
    }
}

public struct ListItemsResponse: DataContaining {
    public let data: [PlaidItemDTO]

    public init(data: [PlaidItemDTO]) {
        self.data = data
    }
}

public struct CreateItemRequest: Content {
    public let publicToken: String
    public let institutionID: String

    public init(publicToken: String, institutionID: String) {
        self.publicToken = publicToken
        self.institutionID = institutionID
    }
}

public struct CreateItemResponse: DataContaining {
    public let data: PlaidItemDTO

    public init(data: PlaidItemDTO) {
        self.data = data
    }
}

public struct SyncItemRequest: Content {
    public let itemID: UUID

    public init(itemID: UUID) {
        self.itemID = itemID
    }
}

public struct SyncItemResponse: DataContaining {
    public let data: PlaidItemDTO

    public init(data: PlaidItemDTO) {
        self.data = data
    }
}

public struct AccountDTO: Content {
    public let id: UUID
    public let itemID: UUID
    public let name: String
    public let officialName: String?
    public let mask: String?
    public let currentBalance: Double
    public let availableBalance: Double
    public let isoCurrencyCode: String?
    public let type: String?
    public let subtype: String?

    public init(
        id: UUID,
        itemID: UUID,
        name: String,
        officialName: String?,
        mask: String?,
        currentBalance: Double,
        availableBalance: Double,
        isoCurrencyCode: String?,
        type: String?,
        subtype: String?
    ) {
        self.id = id
        self.itemID = itemID
        self.name = name
        self.officialName = officialName
        self.mask = mask
        self.currentBalance = currentBalance
        self.availableBalance = availableBalance
        self.isoCurrencyCode = isoCurrencyCode
        self.type = type
        self.subtype = subtype
    }
}

public struct PlaidItemDTO: Content {
    public let id: UUID
    public let institutionID: String
    public let status: String
    public let createdAt: Date

    public init(
        id: UUID,
        institutionID: String,
        status: String,
        createdAt: Date
    ) {
        self.id = id
        self.institutionID = institutionID
        self.status = status
        self.createdAt = createdAt
    }
}

public struct LinkTokenDTO: Content {
    public let linkToken: String

    public init(linkToken: String) {
        self.linkToken = linkToken
    }
}

public struct LinkTokenResponse: DataContaining {
    public let data: LinkTokenDTO

    public init(data: LinkTokenDTO) {
        self.data = data
    }
}

public struct TransactionDTO: Content {
    public let id: UUID
    public let accountID: UUID
    public let plaidTransactionID: String
    public let category: String?
    public let subcategory: String?
    public let type: String
    public let name: String
    public let amount: Double
    public let isoCurrencyCode: String?
    public let unofficialCurrencyCode: String?
    public let date: Date
    public let pending: Bool
    public let accountOwner: String?

    public init(
        id: UUID,
        accountID: UUID,
        plaidTransactionID: String,
        category: String?,
        subcategory: String?,
        type: String,
        name: String,
        amount: Double,
        isoCurrencyCode: String?,
        unofficialCurrencyCode: String?,
        date: Date,
        pending: Bool,
        accountOwner: String?
    ) {
        self.id = id
        self.accountID = accountID
        self.plaidTransactionID = plaidTransactionID
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

public struct ListTransactionsResponse: DataContaining {
    public let data: [TransactionDTO]

    public init(data: [TransactionDTO]) {
        self.data = data
    }
}

public enum AuthMethod: String, Content {
    case password = "password"
    case apple = "apple"
}

public struct RegisterRequest: Content {
    public let method: AuthMethod
    public let email: String?
    public let password: String?
    public let confirmPassword: String?
    public let appleToken: String?

    public init(
        method: AuthMethod,
        email: String?,
        password: String?,
        confirmPassword: String?,
        appleToken: String?
    ) {
        self.method = method
        self.email = email
        self.password = password
        self.confirmPassword = confirmPassword
        self.appleToken = appleToken
    }
}

public struct RegisterResponse: Content {
    public let id: UUID
    public let email: String
    public let sessionToken: String

    public init(id: UUID, email: String, sessionToken: String) {
        self.id = id
        self.email = email
        self.sessionToken = sessionToken
    }
}

public struct LoginRequest: Content {
    public let method: AuthMethod
    public let email: String?
    public let password: String?
    public let appleToken: String?

    public init(
        method: AuthMethod,
        email: String?,
        password: String?,
        appleToken: String?
    ) {
        self.method = method
        self.email = email
        self.password = password
        self.appleToken = appleToken
    }
}

public struct LoginResponse: Content {
    public let email: String
    public let sessionToken: String

    public init(email: String, sessionToken: String) {
        self.email = email
        self.sessionToken = sessionToken
    }
}
