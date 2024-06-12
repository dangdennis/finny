package app.handlers

import app.dtos.DTOs.PlaidItemCreateRequest
import app.dtos._
import app.models._
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.services.PlaidService

import scala.util.Failure
import scala.util.Success

object PlaidItemHandler:
  def handlePlaidItemCreate(user: User, input: PlaidItemCreateRequest): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] =
    println("Handling Plaid item create")

    println(s"user $user")

    val pubTokenExchangeResp = PlaidService.exchangePublicToken(input.publicToken)
    val itemGetResp = PlaidService.getItem(pubTokenExchangeResp.get.getAccessToken())

    val item = PlaidItemRepository.createItem(
      input = CreateItemInput(
        userId = user.id,
        plaidAccessToken = pubTokenExchangeResp.get.getAccessToken(),
        plaidItemId = pubTokenExchangeResp.get.getItemId(),
        plaidInstitutionId = itemGetResp.get.getItem().getInstitutionId(),
        status = PlaidItemStatus.Good,
        transactionsCursor = None
      )
    )

    // sync transactions and accounts in a task

    item match
      case Failure(error) => Left(AuthenticationError(400))
      case Success(item) =>
        Right(
          DTOs.PlaidItemCreateResponse(
            itemId = item.id,
            institutionId = item.plaidInstitutionId,
            status = item.status.toString(),
            createdAt = item.createdAt.toString()
          )
        )
