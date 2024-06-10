package app.dtos

import sttp.tapir.Schema
import upickle.default.ReadWriter

object DTOs:
  case class PlaidItemCreateRequest(publicToken: String) derives Schema, ReadWriter
  case class PlaidItemCreateResponse(itemId: String, institutionId: String, status: String, createdAt: String) derives Schema, ReadWriter
  case class PlaidLinkCreateResponse(token: String, hostedLinkUrl: String) derives Schema, ReadWriter
