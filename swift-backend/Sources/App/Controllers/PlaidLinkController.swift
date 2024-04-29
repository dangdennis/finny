import Vapor

struct PlaidLinkController: Sendable {
  let plaidLinkService: PlaidLinkServiceProtocol

  struct CreateLinkTokenRequest: Content {
    let clientName: String
    let products: [String]
    let countryCodes: [String]
    let language: String
  }

  struct CreateLinkTokenResponse: Content {
    let linkToken: String
  }

  func createLinkToken() -> String {
    return "link-token"
  }
}
