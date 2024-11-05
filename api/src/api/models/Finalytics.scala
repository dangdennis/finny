package api.models

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
        "target_savings_and_investments_this_month"
      case ActualSavingsAtRetirement =>
        "actual_savings_at_retirement"
      case TargetSavingsAtRetirement =>
        "target_savings_at_retirement"
