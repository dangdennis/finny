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
import io.circe.generic.auto.*
import io.circe.parser.decode
import retrofit2.Response

import scala.collection.JavaConverters.*
import scala.reflect.ClassTag
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

  def getTransactionsSync(accessToken: String, cursor: Option[String]) = {
    val req = new TransactionsSyncRequest().accessToken(accessToken).cursor(cursor.orNull)
    handleResponse(Try(client.transactionsSync(req).execute()))
  }

  def createLinkToken() =
    val req = LinkTokenCreateRequest()
      .products(
        List(Products.TRANSACTIONS, Products.INVESTMENTS, Products.RECURRING_TRANSACTIONS, Products.BALANCE).asJava
      )
      .countryCodes(List(CountryCode.US).asJava)
    handleResponse(Try(client.linkTokenCreate(req).execute()))

  def exchangePublicToken(publicToken: String) =
    val req = ItemPublicTokenExchangeRequest().publicToken(publicToken)
    handleResponse(Try(client.itemPublicTokenExchange(req).execute()))

  def getItem(accessToken: String) =
    val req = ItemGetRequest().accessToken(accessToken)
    handleResponse(Try(client.itemGet(req).execute()))

  private def handleResponse[T: ClassTag](responseTry: Try[Response[T]]): Either[PlaidError, T] = {
    responseTry match {
      case Success(response) if response.isSuccessful =>
        Right(response.body())
      case Success(response) =>
        // Read the error body and parse it into a PlaidError
        val errorBody = response.errorBody().string()
        PlaidError.fromJson(errorBody) match {
          case Right(plaidError) => Left(plaidError)
          case Left(e)           => Left(PlaidError("unknown_request_id", "API_ERROR", "PARSE_ERROR", e.getMessage))
        }
      case Failure(exception) =>
        // Handle unexpected exceptions and convert them to a PlaidError
        val plaidError = PlaidError("unknown_request_id", "API_ERROR", "UNKNOWN_ERROR", exception.getMessage)
        Left(plaidError)
    }
  }

case class PlaidError(requestId: String, errorType: String, errorCode: String, errorMessage: String)

object PlaidError {
  def fromJson(json: String): Either[io.circe.Error, PlaidError] = decode[PlaidError](json)
}
