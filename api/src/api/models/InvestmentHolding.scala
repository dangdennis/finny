package api.models

import java.util.UUID
import java.time.Instant

case class InvestmentHolding(
    id: String,
    accountId: UUID,
    securityId: String,
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
