@preconcurrency import Fluent

struct UserService {
    let db: Database

    func fetchUser(email: String) async -> User? {
        do {
            return try await User.query(on: db).filter(\.$email == email).first()
        } catch { return nil }
    }

    func fetchUser(appleSub: String) async -> User? {
        do {
            return try await User.query(on: db).filter(\.$appleSub == appleSub).first()
        } catch { return nil }
    }

    func createUser(email: String, passwordHash: String) async throws -> User {
        let user = User(email: email, passwordHash: passwordHash)
        try await user.save(on: db)
        return user
    }

    func createUser(email: String, appleSub: String) async throws -> User {
        let user = User(email: email, appleSub: appleSub)
        try await user.save(on: db)
        return user
    }
}
