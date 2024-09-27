package api.models

import java.util.UUID

enum FinalyticKeys:
  case ActualRetirementAge
  case ActualSavingsAndInvestmentsThisMonth
  case TargetSavingsAndInvestmentsThisMonth
  case ActualSavingsAtRetirement
  case TargetSavingsAtRetirement

  override def toString: String =
    this match
      case ActualRetirementAge =>
        "actual_retirement_age"
      case ActualSavingsAndInvestmentsThisMonth =>
        "actual_savings_and_investments_this_month"
      case TargetSavingsAndInvestmentsThisMonth =>
        "TargetSavingsAndInvestmentsThisMonth"
      case ActualSavingsAtRetirement =>
        "ActualSavingsAtRetirement"
      case TargetSavingsAtRetirement =>
        "TargetSavingsAtRetirement"

case class Finalytic(userId: UUID, key: FinalyticKeys, value: String)
