package api.models

import java.time.Instant
import java.util.UUID
import java.time.LocalDate
import io.circe.*
import io.circe.generic.semiauto.*

case class Profile(
    id: UserId,
    age: Option[Int],
    dateOfBirth: Option[LocalDate],
    retirementAge: Option[Int],
    riskProfile: Option[RiskProfile],
    fireProfile: Option[FireProfile],
    deletedAt: Option[Instant]
)

enum RiskProfile:
    case Conservative,
        Balanced,
        Aggressive

object RiskProfile:
    given Encoder[RiskProfile] = deriveEncoder
    given Decoder[RiskProfile] = deriveDecoder

enum FireProfile:
    case Lean,
        Traditional,
        Fat,
        Barista,
        Slow,
        Coast

object FireProfile:
    given Encoder[FireProfile] = deriveEncoder
    given Decoder[FireProfile] = deriveDecoder

case class AuthUser(id: UserId, deletedAt: Option[Instant])

opaque type UserId = UUID

object UserId:
    def apply(uuid: UUID): UserId = uuid
    def toUUID(userId: UserId): UUID = userId
    given Conversion[UUID, UserId] = UserId.apply
    given Conversion[UserId, UUID] = toUUID

// enum RiskProfile:
//     case Conservative, Balanced, Aggressive

// object RiskProfile:
//     given Encoder[RiskProfile] = Encoder.encodeString.contramap[RiskProfile](_.toString)
//     given Decoder[RiskProfile] = Decoder.decodeString.map[RiskProfile](RiskProfile.valueOf)

// enum FireProfile:
//     case Lean, Traditional, Fat, Barista, Slow, Coast

// object FireProfile:
//     given Encoder[FireProfile] = Encoder.encodeString.contramap[FireProfile](_.toString)
//     given Decoder[FireProfile] = Decoder.decodeString.map[FireProfile](FireProfile.valueOf)
