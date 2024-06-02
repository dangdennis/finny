import APISchema
@preconcurrency import Fluent
import Vapor

struct UserController: Sendable {
    let db: Database
    let userService: UserService

    func register(req: Request) async throws -> RegisterResponse {
        let registerReq = try req.content.decode(RegisterRequest.self)

        switch registerReq.method {
        case .password:
            return try await registerPassword(req: req)
        case .apple:
            return try await registerApple(req: req)
        }
    }

    func registerPassword(req: Request) async throws -> RegisterResponse {
        try RegisterPasswordRequest.validate(content: req)

        let payload = try req.content.decode(RegisterPasswordRequest.self)

        try await verifyUserDoesNotExist(email: payload.email)

        let passwordHash = try Bcrypt.hash(payload.password)

        let user = User(email: payload.email.lowercased(), passwordHash: passwordHash)

        try await user.create(on: db)

        let sessionToken = try SessionToken(user: user)

        return try .init(
            id: user.id!,
            email: user.email,
            sessionToken: req.jwt.sign(sessionToken)
        )
    }

    func registerApple(req: Request) async throws -> RegisterResponse {
        let appleAccessToken = try await req.jwt.apple.verify()

        guard let email = appleAccessToken.email else {
            throw Abort(.badRequest, reason: "Apple token does not contain email.")
        }

        let user = User(
            email: email.lowercased(),
            appleSub: appleAccessToken.subject.value
        )

        try await user.create(on: db)

        let sessionToken = try SessionToken(user: user)

        return try .init(
            id: user.id!,
            email: user.email,
            sessionToken: req.jwt.sign(sessionToken)
        )
    }

    func login(req: Request) async throws -> LoginResponse {
        try LoginRequest.validate(content: req)

        let payload = try req.content.decode(LoginRequest.self)

        switch payload.method {
        case .password:
            return try await loginPassword(req: req)
        case .apple:
            return try await loginApple(req: req)
        }
    }

    func loginPassword(req: Request) async throws -> LoginResponse {
        try LoginPasswordRequest.validate(content: req)

        let payload = try req.content.decode(LoginPasswordRequest.self)

        let user = await userService.fetchUser(email: payload.email)
        guard let user = user else {
            throw Abort(.unauthorized, reason: "Invalid email or password.")
        }

        guard let passwordHash = user.passwordHash else {
            throw Abort(.unauthorized, reason: "Invalid email or password.")
        }

        guard try Bcrypt.verify(payload.password, created: passwordHash) else {
            throw Abort(.unauthorized, reason: "Invalid email or password.")
        }

        let sessionToken = try SessionToken(user: user)

        return try .init(
            email: user.email,
            sessionToken: req.jwt.sign(sessionToken)
        )
    }

    func loginApple(req: Request) async throws -> LoginResponse {
        let appleAccessToken = try await req.jwt.apple.verify()

        let user = await userService.fetchUser(
            appleSub: appleAccessToken.subject.value
        )
        guard let user = user else {
            throw Abort(.unauthorized, reason: "User not found.")
        }

        let sessionToken = try SessionToken(user: user)

        return try .init(
            email: user.email,
            sessionToken: req.jwt.sign(sessionToken)
        )
    }

    private func verifyUserDoesNotExist(email: String) async throws {
        let email = email.lowercased()
        guard await userService.fetchUser(email: email) == nil else {
            throw Abort(.badRequest, reason: "User already exists.")
        }
    }
}

extension UserController {
    struct RegisterPasswordRequest: Content {
        let email: String
        let password: String
        let confirmPassword: String
    }

    struct LoginPasswordRequest: Content {
        let email: String
        let password: String
    }

    struct LoginAppleRequest: Content {
        let appleToken: String
    }

    struct LoginResponse: Content {
        let email: String
        let sessionToken: String
    }
}

extension APISchema.LoginRequest: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "method",
            as: String.self,
            is: .in(
                AuthMethod.apple.rawValue,
                AuthMethod.password.rawValue
            )
        )
    }
}

extension UserController.LoginPasswordRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension APISchema.RegisterRequest: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "method",
            as: String.self,
            is: .in(
                AuthMethod.apple.rawValue,
                AuthMethod.password.rawValue
            )
        )
    }
}

extension UserController.RegisterPasswordRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("confirmPassword", as: String.self, is: .count(8...))
    }
}
