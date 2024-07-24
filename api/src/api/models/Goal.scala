package models

import java.util.UUID
import java.time.Instant
import api.models.UserId

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
