package api.models

import java.time.Instant
import java.util.UUID

case class InvestmentSecurity(
    id: UUID,
    plaidSecurityId: String,
    plaidInstitutionSecurityId: Option[String],
    plaidInstitutionId: Option[String],
    plaidProxySecurityId: Option[String],
    name: Option[String],
    tickerSymbol: Option[String],
    securityType: Option[SecurityType],
    createdAt: Instant,
    updatedAt: Instant,
    deletedAt: Option[Instant]
)

enum SecurityType:
  case Cash
  case Cryptocurrency
  case Derivative
  case Equity
  case ETF
  case FixedIncome
  case Loan
  case Mutual
  case Other

object SecurityType:
  def toString(securityType: SecurityType): String =
    securityType match
      case SecurityType.Cash =>
        "cash"
      case SecurityType.Cryptocurrency =>
        "cryptocurrency"
      case SecurityType.Derivative =>
        "derivative"
      case SecurityType.Equity =>
        "equity"
      case SecurityType.ETF =>
        "etf"
      case SecurityType.FixedIncome =>
        "fixed income"
      case SecurityType.Loan =>
        "loan"
      case SecurityType.Mutual =>
        "mutual fund"
      case SecurityType.Other =>
        "other"

  def fromString(s: String): Either[String, SecurityType] =
    s match
      case "cash" =>
        Right(SecurityType.Cash)
      case "cryptocurrency" =>
        Right(SecurityType.Cryptocurrency)
      case "derivative" =>
        Right(SecurityType.Derivative)
      case "equity" =>
        Right(SecurityType.Equity)
      case "etf" =>
        Right(SecurityType.ETF)
      case "fixed income" =>
        Right(SecurityType.FixedIncome)
      case "loan" =>
        Right(SecurityType.Loan)
      case "mutual fund" =>
        Right(SecurityType.Mutual)
      case "other" =>
        Right(SecurityType.Other)
      case _ =>
        Left(s"Invalid security type: $s")
