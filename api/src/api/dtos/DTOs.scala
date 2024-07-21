package app.dtos

import io.circe.generic.auto.*
import sttp.tapir.*
import sttp.tapir.Schema
import sttp.tapir.generic.auto.*

object DTOs:
    case class PlaidItemCreateRequest(publicToken: String) derives Schema
    case class PlaidItemCreateResponse(itemId: String, institutionId: String, status: String, createdAt: String)
        derives Schema
    case class PlaidItemSyncRequest(itemId: String) derives Schema
    case class PlaidLinkCreateResponse(token: String) derives Schema
    case class PlaidItemsGetResponse(items: List[PlaidItemDTO]) derives Schema
    case class PlaidItemDeleteRequest(itemId: String) derives Schema
    case class PlaidItemDTO(
        id: String,
        institutionId: String,
        status: String,
        createdAt: String,
        lastSyncedAt: Option[String],
        lastSyncError: Option[String],
        lastSyncErrorAt: Option[String],
        retryCount: Int
    ) derives Schema
