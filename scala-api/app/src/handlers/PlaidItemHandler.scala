package app.handlers

import app.dtos.*
import app.dtos.DTOs.PlaidItemCreateRequest
import app.models.*
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.services.PlaidService
import app.services.PlaidSyncService

object PlaidItemHandler:
  def handlePlaidItemCreate(user: Profile, input: PlaidItemCreateRequest): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] =
    val result = for
      pubTokenData <- PlaidService.exchangePublicToken(publicToken = input.publicToken, userId = user.id)
      itemData <- PlaidService.getItem(accessToken = pubTokenData.getAccessToken(), userId = user.id)
      item <- PlaidItemRepository.createItem(
        input = CreateItemInput(
          userId = user.id,
          plaidAccessToken = pubTokenData.getAccessToken(),
          plaidItemId = pubTokenData.getItemId(),
          plaidInstitutionId = itemData.getItem().getInstitutionId(),
          status = PlaidItemStatus.Good,
          transactionsCursor = None
        )
      )
    yield item

    result match
      case Left(value) => Left(AuthenticationError(400))
      case Right(item) =>
        PlaidSyncService.syncTransactionsAndAccounts(item.id)

        Right(
          DTOs.PlaidItemCreateResponse(
            itemId = item.id.toString(),
            institutionId = item.plaidInstitutionId,
            status = item.status.toString(),
            createdAt = item.createdAt.toString()
          )
        )
