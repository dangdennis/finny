package models

import java.util.UUID

case class InvestmentHolding(
    id: String,
    accountId: UUID,
    symbol: String,
    name: String,
    quantity: Double,
    price: Double,
    value: Double,
    costBasis: Double,
    gain: Double,
    gainPercentage: Double,
    createdAt: Long,
    updatedAt: Long,
    deletedAt: Option[Long]
)
