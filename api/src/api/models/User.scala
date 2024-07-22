package api.models

import java.util.UUID
import java.time.Instant

case class Profile(id: UserId, deletedAt: Option[Instant] = None)

opaque type UserId = UUID

object UserId:
    // Method to create a UserId from a UUID
    def apply(uuid: UUID): UserId = uuid

    // Method to extract the UUID from a UserId
    def toUUID(userId: UserId): UUID = userId

    // Implicit conversions (optional)
    given Conversion[UUID, UserId] = UserId.apply
    given Conversion[UserId, UUID] = toUUID
