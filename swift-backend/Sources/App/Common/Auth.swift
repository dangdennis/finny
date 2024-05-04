import Vapor

struct Auth {
    static func getUserID(from req: Request) throws -> UUID {
        let sessionToken = try req.auth.require(SessionToken.self)
        return UUID(uuidString: sessionToken.sub.value)!
    }
}
