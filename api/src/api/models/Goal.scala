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

enum GoalType(val value: String):
    case Retirement extends GoalType("retirement")
    case Custom extends GoalType("custom")

object GoalType:
    given Encoder[GoalType] = Encoder.encodeString.contramap[GoalType](_.value)

    given Decoder[GoalType] = Decoder
        .decodeString
        .emap { s =>
            GoalType.values.find(_.value == s) match
                case Some(goalType) =>
                    Right(goalType)
                case None =>
                    Left(s"Unknown GoalType: $s")
        }

    def fromString(s: String): Option[GoalType] = GoalType.values.find(_.value == s)
