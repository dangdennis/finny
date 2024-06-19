package app.handlers

import app.dtos.DTOs.PlaidItemCreateRequest
import app.dtos._
import app.models._
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.services.PlaidService
import app.services.PlaidSyncService

import scala.util.Failure
import scala.util.Success
import scala.util.Try

object PlaidItemHandler:
  def handlePlaidItemCreate(user: Profile, input: PlaidItemCreateRequest): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] =
    val result: Try[PlaidItem] = for
      pubTokenData <- PlaidService.exchangePublicToken(input.publicToken)
      itemData <- PlaidService.getItem(pubTokenData.getAccessToken())
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
      case Failure(error) =>
        println(s"error creating item: $error")
        Left(AuthenticationError(400))
      case Success(item) =>
        PlaidSyncService.syncTransactionsAndAccounts(item.id)

        Right(
          DTOs.PlaidItemCreateResponse(
            itemId = item.id.toString(),
            institutionId = item.plaidInstitutionId,
            status = item.status.toString(),
            createdAt = item.createdAt.toString()
          )
        )
