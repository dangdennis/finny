package api.models

import java.util.UUID
import java.time.Instant

case class InvestmentSecurity(
    id: UUID,
    plaidDecurityId: String,
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

    def fromString(s: String): Option[SecurityType] =
        s match
            case "cash" =>
                Some(SecurityType.Cash)
            case "cryptocurrency" =>
                Some(SecurityType.Cryptocurrency)
            case "derivative" =>
                Some(SecurityType.Derivative)
            case "equity" =>
                Some(SecurityType.Equity)
            case "etf" =>
                Some(SecurityType.ETF)
            case "fixed income" =>
                Some(SecurityType.FixedIncome)
            case "loan" =>
                Some(SecurityType.Loan)
            case "mutual fund" =>
                Some(SecurityType.Mutual)
            case "other" =>
                Some(SecurityType.Other)
            case _ =>
                None
