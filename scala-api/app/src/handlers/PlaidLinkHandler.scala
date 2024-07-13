package app.handlers

import app.dtos.*
import app.models.*
import app.services.PlaidService
import app.common.logger.Logger

import java.util.UUID
import common.utils.logger.Logger

object PlaidLinkHandler:
  def handler(userId: UUID): Either[AuthenticationError, DTOs.PlaidLinkCreateResponse] =
    PlaidService.createLinkToken(userId = userId) match
      case Left(error) => 
        Logger.root.error(s"Error creating Plaid link token", error)
        Left(AuthenticationError(400))
      case Right(response) =>
        Right(
          DTOs.PlaidLinkCreateResponse(
            token = response.getLinkToken(),
          )
        )
