package api.models

import io.circe.*
import io.circe.generic.semiauto.*

import java.time.Instant
import java.time.LocalDate
import java.util.UUID

case class Profile(
    id: UserId,
    dateOfBirth: Option[LocalDate],
    retirementAge: Option[Int],
    riskProfile: Option[RiskProfile],
    fireProfile: Option[FireProfile],
    deletedAt: Option[Instant]
)

enum RiskProfile(val value: String):
  case Conservative extends RiskProfile("conservative")
  case Balanced extends RiskProfile("balanced")
  case Aggressive extends RiskProfile("aggressive")

object RiskProfile:
  given Encoder[RiskProfile] =
    Encoder.encodeString.contramap[RiskProfile](_.value)

  given Decoder[RiskProfile] = Decoder.decodeString
    .emap { s =>
      RiskProfile.values.find(_.value == s) match
        case Some(profile) =>
          Right(profile)
        case None =>
          Left(s"Unknown RiskProfile: $s")
    }

  def fromString(s: String): Option[RiskProfile] =
    RiskProfile.values.find(_.value == s)

enum FireProfile(val value: String):
  case Lean extends FireProfile("lean")
  case Traditional extends FireProfile("traditional")
  case Fat extends FireProfile("fat")
  case Barista extends FireProfile("barista")
  case Slow extends FireProfile("slow")
  case Coast extends FireProfile("coast")

object FireProfile:
  given Encoder[FireProfile] =
    Encoder.encodeString.contramap[FireProfile](_.value)

  given Decoder[FireProfile] = Decoder.decodeString
    .emap { s =>
      FireProfile.values.find(_.value == s) match
        case Some(profile) =>
          Right(profile)
        case None =>
          Left(s"Unknown FireProfile: $s")
    }

  def fromString(s: String): Option[FireProfile] =
    FireProfile.values.find(_.value == s)

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
