package api.models

import java.time.Instant
import java.util.UUID

case class GoalAccount(
    id: UUID,
    goalId: UUID,
    accountId: UUID,
    assignedAmount: AssignedAmount,
    createdAt: Instant,
    updatedAt: Instant,
    deletedAt: Option[Instant]
)

enum AssignedAmount:
    case Fixed(amount: Double)
    case Percentage(percentage: Double)
