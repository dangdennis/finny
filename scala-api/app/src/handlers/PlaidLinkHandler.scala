package app.handlers

import app.dtos._
import app.models._

object PlaidLinkHandler:
  def handler(): Either[AuthenticationError, DTOs.PlaidLinkCreateResponse] = Right(
    DTOs.PlaidLinkCreateResponse(
      token = "123456",
      hostedLinkUrl = "https://sandbox.plaid.com/link/token/create"
    )
  )
