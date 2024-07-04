package app.handlers

import app.dtos.*
import app.models.*
import app.services.PlaidService
import java.util.UUID

object PlaidLinkHandler:
  def handler(userId: UUID): Either[AuthenticationError, DTOs.PlaidLinkCreateResponse] =
    PlaidService.createLinkToken(userId = userId) match
      case Left(error) => Left(AuthenticationError(500))
      case Right(response) =>
        Right(
          DTOs.PlaidLinkCreateResponse(
            token = "123456",
            hostedLinkUrl = "https://sandbox.plaid.com/link/token/create"
          )
        )
