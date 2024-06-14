package app.services

import com.plaid.client.ApiClient
import com.plaid.client.model.CountryCode
import com.plaid.client.model.ItemGetRequest
import com.plaid.client.model.ItemGetResponse
import com.plaid.client.model.ItemPublicTokenExchangeRequest
import com.plaid.client.model.ItemPublicTokenExchangeResponse
import com.plaid.client.model.LinkTokenCreateRequest
import com.plaid.client.model.LinkTokenCreateResponse
import com.plaid.client.model.Products
import com.plaid.client.model.TransactionsSyncRequest
import com.plaid.client.model.TransactionsSyncResponse
import com.plaid.client.request.PlaidApi

import scala.collection.JavaConverters._
import scala.util.Failure
import scala.util.Success
import scala.util.Try

object PlaidService:
  private lazy val client = makePlaidClient()

  private def makePlaidClient() =
    val apiClient = new ApiClient(
      Map(
        "clientId" -> "661ac9375307a3001ba2ea46",
        "secret" -> "57ebac97c0bcf92f35878135d68793",
        "plaidVersion" -> "2020-09-14"
      ).asJava
    )
    apiClient.setPlaidAdapter(ApiClient.Sandbox)
    apiClient.createService(classOf[PlaidApi])

  def getTransactionsSync(accessToken: String): Try[TransactionsSyncResponse] =
    val req = TransactionsSyncRequest().accessToken(accessToken)
    val response = Try(client.transactionsSync(req).execute())
    response match
      case Failure(e) => Failure(e)
      case Success(response) =>
        response.isSuccessful() match
          case true  => Success(response.body())
          case false => Failure(new Exception(response.errorBody().string()))

  def createLinkToken(): Try[LinkTokenCreateResponse] =
    val req = LinkTokenCreateRequest()
      .products(
        List(Products.TRANSACTIONS, Products.INVESTMENTS, Products.RECURRING_TRANSACTIONS, Products.BALANCE).asJava
      )
      .countryCodes(List(CountryCode.US).asJava)
    val response = client.linkTokenCreate(req).execute()
    response.isSuccessful() match
      case true  => Success(response.body())
      case false => Failure(new Exception(response.errorBody().string()))

  def exchangePublicToken(publicToken: String): Try[ItemPublicTokenExchangeResponse] =
    val req = ItemPublicTokenExchangeRequest().publicToken(publicToken)
    val response = Try(client.itemPublicTokenExchange(req).execute())
    response match
      case Failure(e) => Failure(e)
      case Success(response) =>
        response.isSuccessful() match
          case true  => Success(response.body())
          case false => Failure(new Exception(response.errorBody().string()))

  def getItem(accessToken: String): Try[ItemGetResponse] =
    val req = ItemGetRequest().accessToken(accessToken)
    val response = Try(client.itemGet(req).execute())
    response match
      case Failure(e) => Failure(e)
      case Success(response) =>
        response.isSuccessful() match
          case true  => Success(response.body())
          case false => Failure(new Exception(response.errorBody().string()))
