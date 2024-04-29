@preconcurrency import Fluent
import Vapor

struct UserController: Sendable {
  let db: Database
  let userService: UserService

  func create(payload: User.CreateRequest) async throws -> User {
    let existing = await userService.fetchUser(username: payload.username)
    guard existing == nil else {
      throw Abort(.badRequest, reason: "A user with that username already exists.")
    }
    return try await userService.createUser(
      username: payload.username, password: payload.password)
  }
}

extension User {
  struct CreateRequest: Content {
    var username: String
    var password: String
    var confirmPassword: String
  }

  struct CreateResponse: Content {
    var id: UUID
    var username: String
  }
}

extension User.CreateRequest: Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("name", as: String.self, is: !.empty)
    validations.add("email", as: String.self, is: .email)
    validations.add("password", as: String.self, is: .count(8...))
  }
}
