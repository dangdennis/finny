package api.models

import io.circe.*
import io.circe.generic.semiauto.*

import java.time.Instant
import java.time.LocalDate
import java.util.UUID

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
    given Encoder[RiskProfile] = Encoder.encodeString.contramap[RiskProfile](RiskProfile.toString)

    given Decoder[RiskProfile] = Decoder
        .decodeString
        .emap {
            case "conservative" =>
                Right(RiskProfile.Conservative)
            case "balanced" =>
                Right(RiskProfile.Balanced)
            case "aggressive" =>
                Right(RiskProfile.Aggressive)
            case s =>
                Left(s"Unknown RiskProfile: $s")
        }

    def toString(profile: RiskProfile): String =
        profile match
            case Conservative =>
                "conservative"
            case Balanced =>
                "balanced"
            case Aggressive =>
                "aggressive"

enum FireProfile:
    case Lean,
        Traditional,
        Fat,
        Barista,
        Slow,
        Coast

object FireProfile:
    given Encoder[FireProfile] = Encoder.encodeString.contramap[FireProfile](FireProfile.toString)

    given Decoder[FireProfile] = Decoder
        .decodeString
        .emap {
            case "lean" =>
                Right(FireProfile.Lean)
            case "traditional" =>
                Right(FireProfile.Traditional)
            case "fat" =>
                Right(FireProfile.Fat)
            case "barista" =>
                Right(FireProfile.Barista)
            case "slow" =>
                Right(FireProfile.Slow)
            case "coast" =>
                Right(FireProfile.Coast)
            case s =>
                Left(s"Unknown FireProfile: $s")
        }

    def toString(profile: FireProfile): String =
        profile match
            case Lean =>
                "lean"
            case Traditional =>
                "traditional"
            case Fat =>
                "fat"
            case Barista =>
                "barista"
            case Slow =>
                "slow"
            case Coast =>
                "coast"

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
