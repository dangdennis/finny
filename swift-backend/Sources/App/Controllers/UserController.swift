@preconcurrency import Fluent
import Vapor

struct UserController: Sendable {
  let db: Database
  let userService: UserService
  let userAuthenticatorService: UserAuthenticatorService

  func create(req: Request) async throws -> User.CreateResponse {
    try User.CreateRequest.validate(content: req)
    let payload = try req.content.decode(User.CreateRequest.self)
    guard payload.password == payload.confirmPassword else {
      throw Abort(.badRequest, reason: "Passwords do not match.")
    }
    let lname = payload.username.lowercased()
    let existing = await userService.fetchUser(username: lname)
    guard existing == nil else {
      throw Abort(.badRequest, reason: "A user with that username already exists.")
    }
    let user = try await userService.createUser(
      username: lname, passwordHash: try Bcrypt.hash(payload.password))

    return try User.CreateResponse(id: user.requireID(), username: user.username)
  }

  func login(req: Request) async throws -> User.LoginResponse {
    try User.LoginRequest.validate(content: req)
    let payload = try req.content.decode(User.LoginRequest.self)
    let lname = payload.username.lowercased()
    guard let user = await userService.fetchUser(username: lname) else {
      throw Abort(.unauthorized, reason: "Invalid username or password.")
    }
    guard try Bcrypt.verify(payload.password, created: user.passwordHash) else {
      throw Abort(.unauthorized, reason: "Invalid username or password.")
    }
    let userToken = try userAuthenticatorService.generateToken(user: user)
    return User.LoginResponse(
      user: User.CreateResponse(id: try user.requireID(), username: user.username),
      token: UserToken.CreateResponse(
        value: userToken.value
      ))
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

  struct LoginRequest: Content {
    let username: String
    let password: String
  }

  struct LoginResponse: Content {
    let user: CreateResponse
    let token: UserToken.CreateResponse
  }
}

extension UserToken {
  struct CreateResponse: Content {
    let value: String
  }

}

extension User.CreateRequest: Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("username", as: String.self, is: !.empty)
    validations.add("password", as: String.self, is: .count(8...))
    validations.add("confirmPassword", as: String.self, is: .count(8...))
  }
}

extension User.LoginRequest: Validatable {
  static func validations(_ validations: inout Validations) {
    validations.add("username", as: String.self, is: !.empty)
    validations.add("password", as: String.self, is: .count(8...))
  }
}
