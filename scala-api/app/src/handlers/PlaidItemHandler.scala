package app.handlers

import app.dtos.DTOs.PlaidItemCreateRequest
import app.dtos._
import app.models._
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.services.PlaidService

import scala.util.Failure
import scala.util.Success
import ox._

object PlaidItemHandler:
  def handlePlaidItemCreate(user: User, input: PlaidItemCreateRequest): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] =
    val result = for
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

    // sync transactions and accounts in a task

    result match
      case Failure(error) => Left(AuthenticationError(400))
      case Success(item) =>
        supervised {
          fork {
            println("syncing transactions")
          }
        }

        Right(
          DTOs.PlaidItemCreateResponse(
            itemId = item.id,
            institutionId = item.plaidInstitutionId,
            status = item.status.toString(),
            createdAt = item.createdAt.toString()
          )
        )
