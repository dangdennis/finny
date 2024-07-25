package api.models

import java.util.UUID
import java.time.Instant

case class InvestmentTransaction(
    id: UUID,
    plaidInvestmentTransactionId: String,
    accountId: UUID,
    investmentSecurityId: UUID,
    date: Instant,
    name: String,
    quantity: Double,
    amount: Double,
    price: Double,
    fees: Option[Double],
    investmentTransactionType: InvestmentTransactionType,
    isoCurrencyCode: Option[String],
    unofficialCurrencyCode: Option[String],
    createdAt: Instant,
    updatedAt: Instant,
    deletedAt: Option[Instant]
)

enum InvestmentTransactionType:
    case Buy
    case Sell
    case Cancel
    case Cash
    case Fee
    case Transfer

object InvestmentTransactionType:
    def toString(investmentTransactionType: InvestmentTransactionType): String =
        investmentTransactionType match
            case InvestmentTransactionType.Buy =>
                "buy"
            case InvestmentTransactionType.Sell =>
                "sell"
            case InvestmentTransactionType.Cancel =>
                "cancel"
            case InvestmentTransactionType.Cash =>
                "cash"
            case InvestmentTransactionType.Fee =>
                "fee"
            case InvestmentTransactionType.Transfer =>
                "transfer"

    def fromString(s: String): Either[String, InvestmentTransactionType] =
        s match
            case "buy" =>
                Right(InvestmentTransactionType.Buy)
            case "sell" =>
                Right(InvestmentTransactionType.Sell)
            case "cancel" =>
                Right(InvestmentTransactionType.Cancel)
            case "cash" =>
                Right(InvestmentTransactionType.Cash)
            case "fee" =>
                Right(InvestmentTransactionType.Fee)
            case "transfer" =>
                Right(InvestmentTransactionType.Transfer)
            case _ =>
                Left(s"Invalid InvestmentTransactionType: $s")
