package api.models

import java.time.Instant
import java.util.UUID

case class InvestmentHolding(
    id: UUID,
    accountId: UUID,
    investmentSecurityId: String,
    institutionPrice: Double,
    institutionPriceAsOf: Option[Instant],
    institutionPriceDateTime: Option[Instant],
    institutionValue: Double,
    costBasis: Option[Double],
    quantity: Double,
    isoCurrencyCode: Option[String],
    unofficialCurrencyCode: Option[String],
    vestedValue: Option[Double],
    createdAt: Instant,
    updatedAt: Instant,
    deletedAt: Option[Instant]
)
