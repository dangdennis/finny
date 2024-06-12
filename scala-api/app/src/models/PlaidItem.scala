package app.models

import java.time.Instant

enum PlaidItemStatus:
  case Good, Bad, Unknown

  override def toString(): String =
    this match
      case Good    => "good"
      case Bad     => "bad"
      case Unknown => "unknown"

object PlaidItemStatus:
  def fromString(s: String): PlaidItemStatus =
    s match
      case "good"    => PlaidItemStatus.Good
      case "bad"     => PlaidItemStatus.Bad
      case "unknown" => PlaidItemStatus.Unknown

case class PlaidItem(
    id: String,
    userId: String,
    plaidAccessToken: String,
    plaidItemId: String,
    plaidInstitutionId: String,
    status: PlaidItemStatus,
    transactionsCursor: Option[String],
    createdAt: Instant
)
