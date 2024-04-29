@preconcurrency import Fluent
import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import Plaid

// typealias PlaidClient = PlaidClient

protocol PlaidLinkServiceProtocol: Sendable {
  static func createLinkToken() async throws
}

struct PlaidLinkService: PlaidLinkServiceProtocol {
  let db: Database

  init(db: Database) {
    // self.client = Client(
    //   serverURL: URL(string: "https://api.elevenlabs.io")!, transport: transport)
    self.db = db
  }

  static func createLinkToken() async throws {
  }
}
