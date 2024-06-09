package app.handlers

import app.dtos._

object PlaidItemHandler:
  def handlePlaidItemCreate(): Either[Unit, DTOs.PlaidItemCreateResponse] = Right(
    DTOs.PlaidItemCreateResponse(
      itemId = "123456",
      institutionId = "ins_123456",
      status = "success",
      createdAt = "2021-01-01T00:00:00Z"
    )
  )
