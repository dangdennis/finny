import Plaid
import Vapor

struct PlaidLinkController: Sendable {
    let plaidLinkService: PlaidLinkService
    let plaid: Plaid.PlaidClient

    func createLinkToken(req: Request) async throws -> LinkTokenResponse {
        let userId = try Auth.getUserId(from: req)
        let linkToken = try await plaid.createLinkToken(userId: userId)
        return LinkTokenResponse(data: .init(linkToken: linkToken.link_token))
    }

    struct LinkTokenDTO: Content { let linkToken: String }

    struct LinkTokenResponse: DataContaining { var data: LinkTokenDTO }

}
