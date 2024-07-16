package app.models

import java.time.Instant
import java.util.UUID

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
    id: UUID,
    userId: UUID,
    plaidAccessToken: String,
    plaidItemId: String,
    plaidInstitutionId: String,
    status: PlaidItemStatus,
    transactionsCursor: Option[String],
    createdAt: Instant,
    lastSyncedAt: Option[Instant],
    lastSyncError: Option[String],
    lastSyncErrorAt: Option[Instant],
    retryCount: Int
)

case class PlaidItemWithAccounts(
    plaidItem: PlaidItem,
    accounts: List[Account]
)