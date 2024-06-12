package app.handlers

import app.dtos._
import app.models._
import app.repositories.PlaidItemRepository

import scala.util.Failure
import scala.util.Success
import app.repositories.PlaidItemRepository.CreateItemInput
import app.dtos.DTOs.PlaidItemCreateRequest

object PlaidItemHandler:
  def handlePlaidItemCreate(user: User, input: PlaidItemCreateRequest): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] =
    println("Handling Plaid item create")

    println(s"user $user")

    // exchange public token for access token
    // fetch institution id

    val item = PlaidItemRepository.createItem(
      input = CreateItemInput(
        userId = user.id,
        plaidAccessToken = "access-token",
        plaidItemId = "item-id",
        plaidInstitutionId = "institution-id",
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
