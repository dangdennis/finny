package api.models

import java.time.Instant
import java.util.UUID

/** PlaidItemId is the internal database ID for a Plaid item. It is not the actual Plaid-generated item ID.
  */
opaque type PlaidItemId = UUID

object PlaidItemId:
    def apply(uuid: UUID): PlaidItemId = uuid

    extension (itemId: PlaidItemId)
        def toUUID: UUID = itemId

enum PlaidItemStatus:
    case Good,
        Bad,
        Unknown

    override def toString(): String =
        this match
            case Good =>
                "good"
            case Bad =>
                "bad"
            case Unknown =>
                "unknown"

object PlaidItemStatus:
    def fromString(s: String): PlaidItemStatus =
        s match
            case "good" =>
                PlaidItemStatus.Good
            case "bad" =>
                PlaidItemStatus.Bad
            case "unknown" =>
                PlaidItemStatus.Unknown

case class PlaidItem(
    id: PlaidItemId,
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
    retryCount: Int,
    errorType: Option[String],
    errorCode: Option[String],
    errorMessage: Option[String],
    errorDisplayMessage: Option[String],
    errorRequestId: Option[String],
    documentationUrl: Option[String],
    suggestedAction: Option[String]
)
