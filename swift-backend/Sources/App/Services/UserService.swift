@preconcurrency import Fluent

struct UserService {
    let db: Database

    func fetchUser(username: String) async -> User? {
        do {
            return try await User.query(on: db)
                .filter(\.$username == username)
                .first()
        } catch {
            return nil
        }
    }

    func createUser(username: String, passwordHash: String) async throws -> User {
        let user = User(username: username, passwordHash: passwordHash)
        try await user.save(on: db)
        return user
    }
}
