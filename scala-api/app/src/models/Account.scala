package app.models

import java.time.Instant
import java.util.UUID

case class AccountSimple(
    id: UUID,
    itemId: UUID,
    plaidAccountId: String,
    userId: UUID
)

case class Account(
    id: UUID,
    itemId: UUID,
    userId: UUID,
    plaidAccountId: String,
    name: String,
    mask: Option[String],
    officialName: Option[String],
    currentBalance: Double,
    availableBalance: Double,
    isoCurrencyCode: Option[String],
    unofficialCurrencyCode: Option[String],
    accountType: Option[String],
    accountSubtype: Option[String],
    createdAt: Instant
)
