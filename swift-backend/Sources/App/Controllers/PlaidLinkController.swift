import APISchema
import Plaid
import Vapor

struct PlaidLinkController: Sendable {
    let plaidLinkService: PlaidLinkService
    let plaid: Plaid.PlaidClient

    func createLinkToken(req: Request) async throws -> LinkTokenResponse {
        let userID = try Auth.getUserID(from: req)
        let linkToken = try await plaid.createLinkToken(userID: userID)
        return .init(data: .init(linkToken: linkToken.link_token))
    }
}
