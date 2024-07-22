package api.models

import java.time.Instant
import java.util.UUID

case class Profile(id: UserId, deletedAt: Option[Instant])

case class AuthUser(id: UserId, deletedAt: Option[Instant])

opaque type UserId = UUID

object UserId:
    def apply(uuid: UUID): UserId = uuid
    def toUUID(userId: UserId): UUID = userId
    given Conversion[UUID, UserId] = UserId.apply
    given Conversion[UserId, UUID] = toUUID
