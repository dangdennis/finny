package api.models

import java.util.UUID

case class GoalAccount(
    id: UUID,
    goalId: UUID,
    accountId: UUID,
    assignedAmount: AssignedAmount,
)

enum AssignedAmount:
  case Fixed(amount: Double)
  case Percentage(percentage: Double)
