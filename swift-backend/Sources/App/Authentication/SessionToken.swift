import JWT
import Vapor

struct SessionToken: Content, Authenticatable, JWTPayload {
    let duration: TimeInterval = 60 * 60 * 24 * 7  // 1 week
    let iss = IssuerClaim(value: "com.belmont.finnyapp")
    let iat: IssuedAtClaim
    let exp: ExpirationClaim
    let sub: SubjectClaim

    enum CodingKeys: String, CodingKey {
        case iss
        case iat
        case duration
        case exp
        case sub
    }

    init(sub: UUID) {
        self.sub = SubjectClaim(value: sub.uuidString)
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(duration))
        self.iat = IssuedAtClaim(value: Date())
    }

    init(user: User) throws {
        self.sub = SubjectClaim(value: user.id!.uuidString)
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(duration))
        self.iat = IssuedAtClaim(value: Date())
    }

    func verify(using signer: JWTSigner) throws { try exp.verifyNotExpired() }
}
