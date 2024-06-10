package app.handlers

import app.dtos._
import app.models._
import app.repositories.PlaidItemRepository

import scala.util.Failure
import scala.util.Success

object PlaidItemHandler:
  def handlePlaidItemCreate(user: User): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] =
    println("Handling Plaid item create")

    println(s"user $user")

    PlaidItemRepository.createItem(user = user) match
      case Failure(error) => Left(AuthenticationError(400))
      case Success(_) =>
        Right(
          DTOs.PlaidItemCreateResponse(
            itemId = "123456",
            institutionId = "ins_123456",
            status = "success",
            createdAt = "2021-01-01T00:00:00Z"
          )
        )
