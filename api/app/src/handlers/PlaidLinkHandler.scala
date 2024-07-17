package app.handlers

import app.common.*
import app.dtos.*
import app.models.*
import app.services.PlaidService

import java.util.UUID

object PlaidLinkHandler:
    def handler(userId: UUID): Either[AuthenticationError, DTOs.PlaidLinkCreateResponse] =
        PlaidService.createLinkToken(
            client = PlaidService.makePlaidClientFromEnv(),
            userId = userId
        ) match
            case Left(error) =>
                Logger.root.error(s"Error creating Plaid link token", error)
                Left(AuthenticationError(400))
            case Right(response) =>
                Right(
                    DTOs.PlaidLinkCreateResponse(
                        token = response.getLinkToken()
                    )
                )
