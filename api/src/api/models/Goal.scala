package api.models

import api.models.UserId

import java.time.Instant
import java.util.UUID

case class Goal(
    id: UUID,
    name: String,
    amount: Double,
    targetDate: Instant,
    userId: UserId,
    progress: Double,
    createdAt: Instant,
    updatedAt: Instant,
    deletedAt: Option[Instant],
    assignedAccounts: List[GoalAccount]
)
