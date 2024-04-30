import Vapor

struct PlaidLinkController: Sendable {
  let plaidLinkService: PlaidLinkService

  func createLinkToken(req: Request) async throws -> LinkTokenResponse {
    //  make a request to /link/token/create
    return LinkTokenResponse(data: .init(linkToken: ""))

  }

  struct LinkTokenDTO: Content {
    let linkToken: String
  }

  struct LinkTokenResponse: DataContaining {
    var data: LinkTokenDTO
  }

}
