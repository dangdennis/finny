package app.handlers

import app.dtos.DTOs

object PlaidLinkHandler:
  def handler(): Either[Unit, DTOs.PlaidLinkCreateResponse] = Right(
    DTOs.PlaidLinkCreateResponse(
      token = "123456",
      hostedLinkUrl = "https://sandbox.plaid.com/link/token/create"
    )
  )
