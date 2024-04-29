@preconcurrency import Fluent
import Vapor

struct UserController: Sendable {
  let db: Database
  let userService: UserService

  func create(payload: User.CreateRequest) async throws -> User {
    guard payload.password == payload.confirmPassword else {
      throw Abort(.badRequest, reason: "Passwords do not match.")
    }
    let lname = payload.username.lowercased()
    let existing = await userService.fetchUser(username: lname)
    guard existing == nil else {
      throw Abort(.badRequest, reason: "A user with that username already exists.")
    }
    return try await userService.createUser(
      username: lname, passwordHash: try Bcrypt.hash(payload.password))
  }
}

extension User {
  struct CreateRequest: Content {
    let username: String
    let password: String
    let confirmPassword: String
  }

  struct CreateResponse: Content {
    let id: UUID
    let username: String
  }
}

extension User.CreateRequest: Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("username", as: String.self, is: !.empty)
    validations.add("password", as: String.self, is: .count(8...))
    validations.add("confirmPassword", as: String.self, is: .count(8...))
  }
}
