package api.models

import java.time.Instant
import java.util.UUID
import java.time.LocalDate

case class Profile(
    id: UserId,
    age: Option[Int],
    dateOfBirth: Option[LocalDate],
    retirementAge: Option[Int],
    deletedAt: Option[Instant]
)

case class AuthUser(id: UserId, deletedAt: Option[Instant])

opaque type UserId = UUID

object UserId:
    def apply(uuid: UUID): UserId = uuid
    def toUUID(userId: UserId): UUID = userId
    given Conversion[UUID, UserId] = UserId.apply
    given Conversion[UserId, UUID] = toUUID
