package app.handlers

import app.dtos._
import app.models._

object PlaidItemHandler:
  def handlePlaidItemCreate(user: User): Either[AuthenticationError, DTOs.PlaidItemCreateResponse] = Right(
    DTOs.PlaidItemCreateResponse(
      itemId = "123456",
      institutionId = "ins_123456",
      status = "success",
      createdAt = "2021-01-01T00:00:00Z"
    )
  )
