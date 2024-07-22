package api.handlers

import api.common.*
import api.dtos.*
import api.models.*
import api.services.PlaidService

object PlaidLinkHandler:
    def handler(userId: UserId): Either[AuthenticationError, DTOs.PlaidLinkCreateResponse] =
        PlaidService.createLinkToken(client = PlaidService.makePlaidClientFromEnv(), userId = userId) match
            case Left(error) =>
                Logger.root.error(s"Error creating Plaid link token", error)
                Left(AuthenticationError(400))
            case Right(response) =>
                Right(DTOs.PlaidLinkCreateResponse(token = response.getLinkToken()))
