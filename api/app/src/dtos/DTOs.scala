package app.dtos

import sttp.tapir.Schema
import upickle.default.ReadWriter

object DTOs:
    case class PlaidItemCreateRequest(publicToken: String) derives Schema, ReadWriter
    case class PlaidItemCreateResponse(itemId: String, institutionId: String, status: String, createdAt: String) derives Schema, ReadWriter
    case class PlaidItemSyncRequest(itemId: String) derives Schema, ReadWriter
    case class PlaidLinkCreateResponse(token: String) derives Schema, ReadWriter
    case class PlaidItemsGetResponse(items: List[PlaidItemDTO]) derives Schema, ReadWriter
    case class PlaidItemDeleteRequest(itemId: String) derives Schema, ReadWriter
    case class PlaidItemDTO(
        id: String,
        institutionId: String,
        status: String,
        createdAt: String,
        lastSyncedAt: Option[String],
        lastSyncError: Option[String],
        lastSyncErrorAt: Option[String],
        retryCount: Int,
        accounts: List[PlaidAccountDTO]
    ) derives Schema,
          ReadWriter
    case class PlaidAccountDTO(
        id: String,
        itemId: String,
        name: String,
        mask: Option[String],
        officialName: Option[String],
        currentBalance: Double,
        availableBalance: Double,
        isoCurrencyCode: Option[String],
        unofficialCurrencyCode: Option[String],
        accountType: Option[String],
        accountSubtype: Option[String],
        createdAt: String
    ) derives Schema,
          ReadWriter
