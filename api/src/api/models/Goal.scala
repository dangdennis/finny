package api.models

import api.models.UserId

import java.time.Instant
import java.util.UUID
import io.circe.Encoder
import io.circe.Decoder

case class Goal(
    id: UUID,
    name: String,
    amount: Double,
    targetDate: Instant,
    userId: UserId,
    progress: Double,
    goalType: GoalType,
    createdAt: Instant,
    updatedAt: Instant,
    deletedAt: Option[Instant],
    assignedAccounts: List[GoalAccount]
)

enum GoalType:
    case Retirement

object GoalType:
    val RetirementStr = "retirement"

    given Encoder[GoalType] = Encoder.encodeString.contramap[GoalType](GoalType.toString)

    given Decoder[GoalType] = Decoder
        .decodeString
        .emap {
            case RetirementStr =>
                Right(GoalType.Retirement)
            case s =>
                Left(s"Unknown GoalType: $s")
        }

    def toString(profile: GoalType): String =
        profile match
            case Retirement =>
                RetirementStr
