@preconcurrency import Fluent
import Vapor

struct UserAuthenticatorService: AsyncBearerAuthenticator {
  typealias User = App.User
  let db: Database

  func generateToken(user: User) throws -> UserToken {
    try .init(
      value: [UInt8].random(count: 16).base64,
      userId: user.requireID()
    )
  }

  func authenticate(
    bearer: BearerAuthorization,
    for request: Request
  ) async throws {
    do {
      let userToken = try await UserToken.query(on: db)
        .filter(\.$value == bearer.token)
        .first()

      guard let user = userToken?.user else {
        throw Abort(.unauthorized)
      }
      request.auth.login(user)
    } catch {
      throw Abort(.unauthorized)
    }
  }
}
