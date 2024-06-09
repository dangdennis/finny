package app.services

import com.plaid.client.ApiClient
import com.plaid.client.model.CountryCode
import com.plaid.client.model.LinkTokenCreateRequest
import com.plaid.client.model.Products
import com.plaid.client.request.PlaidApi

import scala.collection.JavaConverters._
import scala.util.Failure
import scala.util.Success
import scala.util.Try

object PlaidService:
  lazy val client = makePlaidClient()

  def makePlaidClient() =
    val apiClient = new ApiClient(
      Map(
        "clientId" -> "661ac9375307a3001ba2ea46",
        "secret" -> "57ebac97c0bcf92f35878135d68793",
        "plaidVersion" -> "2020-09-14"
      ).asJava
    )
    apiClient.setPlaidAdapter(ApiClient.Sandbox)
    apiClient.createService(classOf[PlaidApi])

  def createLinkToken(): Try[String] =
    val req = LinkTokenCreateRequest()
      .products(
        List(Products.TRANSACTIONS, Products.INVESTMENTS, Products.RECURRING_TRANSACTIONS, Products.BALANCE).asJava
      )
      .countryCodes(List(CountryCode.US).asJava)
    val response = client.linkTokenCreate(req).execute()
    response.isSuccessful() match
      case true  => Success(response.body().getLinkToken())
      case false => Failure(new Exception(response.errorBody().string()))
