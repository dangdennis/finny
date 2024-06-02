import APISchema
@preconcurrency import Fluent
import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import Plaid

struct PlaidLinkService {
    let db: Database
    let plaid: Plaid.PlaidClient

    func createLinkToken(
        userID: UUID
    ) async throws -> Plaid.Components.Schemas.LinkTokenCreateResponse {
        let linkToken = try await plaid.createLinkToken(userID: userID)
        return linkToken
    }

    func createLinkEvent(
        userID: UUID,
        type: PlaidLinkStatus,
        linkSessionID: String?,
        requestID: String?,
        errorType: String?,
        errorCode: String?,
        status: String?
    ) async throws {
        let plaidLinkEvent = PlaidLinkEvent(
            type: type.rawValue,
            userID: userID,
            linkSessionID: linkSessionID,
            requestID: requestID,
            errorType: errorType,
            errorCode: errorCode,
            status: status
        )
        try await plaidLinkEvent.save(on: db)
    }
}
