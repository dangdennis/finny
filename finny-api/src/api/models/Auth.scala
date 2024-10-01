package api.models

import java.util.UUID

case class AuthenticationToken(value: String)
case class HttpError(code: Int)

case class AuthIdentity(
    id: UUID,
    userId: UUID,
    providerId: String,
    provider: String
)
