package app.models

import java.time.Instant
import java.util.UUID

case class Transaction(
    id: UUID,
    accountId: UUID,
    plaidTransactionId: String,
    category: Option[String],
    subcategory: Option[String],
    transactionType: String,
    name: String,
    amount: Double,
    isoCurrencyCode: Option[String],
    unofficialCurrencyCode: Option[String],
    date: Instant,
    pending: Boolean,
    accountOwner: Option[String]
)
