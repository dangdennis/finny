package api.handlers

import api.common.*
import api.dtos.*
import api.models.*
import api.services.PlaidService

object PlaidLinkHandler:
    def handler(userId: UserId): Either[HttpError, DTOs.PlaidLinkCreateResponse] =
        PlaidService.createLinkToken(client = PlaidService.makePlaidClientFromEnv(), userId = userId) match
            case Left(error) =>
                Logger.root.error(s"Error creating Plaid link token", error)
                Left(HttpError(400))
            case Right(response) =>
                Right(DTOs.PlaidLinkCreateResponse(token = response.getLinkToken()))
