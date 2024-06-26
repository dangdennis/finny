package app.services

import app.models.PlaidItem
import app.repositories.PlaidApiEventRepository
import app.repositories.PlaidApiEventRepository.PlaidApiEventCreateInput
import app.repositories.PlaidItemRepository
import com.plaid.client.ApiClient
import com.plaid.client.model.CountryCode
import com.plaid.client.model.ItemGetRequest
import com.plaid.client.model.ItemGetResponse
import com.plaid.client.model.ItemPublicTokenExchangeRequest
import com.plaid.client.model.ItemPublicTokenExchangeResponse
import com.plaid.client.model.LinkTokenCreateRequest
import com.plaid.client.model.LinkTokenCreateRequestUser
import com.plaid.client.model.LinkTokenCreateResponse
import com.plaid.client.model.Products
import com.plaid.client.model.TransactionsSyncRequest
import com.plaid.client.model.TransactionsSyncResponse
import com.plaid.client.request.PlaidApi
import io.circe.generic.auto.*
import io.circe.parser.decode
import ox.*
import retrofit2.Response

import java.util.UUID
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

  def getTransactionsSync(item: PlaidItem) =
    val req = new TransactionsSyncRequest().accessToken(item.plaidAccessToken).cursor(item.transactionsCursor.orNull)
    val res = Try(client.transactionsSync(req).execute())

    handleResponse(
      res,
      (respBody) =>
        respBody.left
          .map(error =>
            PlaidApiEventRepository
              .create(
                PlaidApiEventCreateInput(
                  userId = Some(item.userId),
                  itemId = Some(item.id),
                  plaidMethod = "transactionsSync",
                  arguments = Map("cursor" -> item.transactionsCursor.getOrElse("")),
                  requestId = error.requestId,
                  errorType = Some(error.errorType),
                  errorCode = Some(error.errorCode)
                )
              )
          )
          .map(body =>
            PlaidApiEventRepository
              .create(
                PlaidApiEventCreateInput(
                  userId = Some(item.userId),
                  itemId = Some(item.id),
                  plaidMethod = "transactionsSync",
                  arguments = Map("cursor" -> item.transactionsCursor.getOrElse("")),
                  requestId = body.getRequestId(),
                  errorType = None,
                  errorCode = None
                )
              )
          )
    )

  def createLinkToken(userId: UUID) =
    val req = LinkTokenCreateRequest()
      .products(
        List(Products.TRANSACTIONS, Products.INVESTMENTS, /*Products.RECURRING_TRANSACTIONS,*/ Products.BALANCE).asJava
      )
      .countryCodes(List(CountryCode.US).asJava)
      .user(LinkTokenCreateRequestUser().clientUserId(userId.toString))
      .webhook("https://finny-backend.fly.dev/api/webhook/plaid")
    handleResponse(
      Try(client.linkTokenCreate(req).execute()),
      (respBody) =>
        respBody.left
          .map(error =>
            PlaidApiEventRepository
              .create(
                PlaidApiEventCreateInput(
                  userId = Some(userId),
                  itemId = None,
                  plaidMethod = "linkTokenCreate",
                  arguments = Map(
                    "userId" -> userId.toString(),
                    "products" -> req.getProducts.asScala.mkString(","),
                    "countryCodes" -> req.getCountryCodes.asScala.mkString(",")
                  ),
                  requestId = error.requestId,
                  errorType = Some(error.errorType),
                  errorCode = Some(error.errorCode)
                )
              )
          )
          .map(body =>
            PlaidApiEventRepository
              .create(
                PlaidApiEventCreateInput(
                  userId = Some(userId),
                  itemId = None,
                  plaidMethod = "linkTokenCreate",
                  arguments = Map(
                    "userId" -> userId.toString(),
                    "products" -> req.getProducts.asScala.mkString(","),
                    "countryCodes" -> req.getCountryCodes.asScala.mkString(",")
                  ),
                  requestId = body.getRequestId(),
                  errorType = None,
                  errorCode = None
                )
              )
          )
    )

  def exchangePublicToken(publicToken: String, userId: UUID) =
    val req = ItemPublicTokenExchangeRequest().publicToken(publicToken)
    handleResponse(
      Try(client.itemPublicTokenExchange(req).execute()),
      (respBody) =>
        respBody.left
          .map(error =>
            PlaidApiEventRepository
              .create(
                PlaidApiEventCreateInput(
                  userId = Some(userId),
                  itemId = None,
                  plaidMethod = "itemPublicTokenExchange",
                  arguments = Map(),
                  requestId = error.requestId,
                  errorType = Some(error.errorType),
                  errorCode = Some(error.errorCode)
                )
              )
          )
          .map(body =>
            PlaidApiEventRepository
              .create(
                PlaidApiEventCreateInput(
                  userId = Some(userId),
                  itemId = None,
                  plaidMethod = "itemPublicTokenExchange",
                  arguments = Map(),
                  requestId = body.getRequestId(),
                  errorType = None,
                  errorCode = None
                )
              )
          )
    )

  def getItem(accessToken: String, userId: UUID) =
    val req = ItemGetRequest().accessToken(accessToken)
    handleResponse(
      Try(client.itemGet(req).execute()),
      (respBody) =>
        respBody.left
          .map(error =>
            PlaidApiEventRepository
              .create(
                PlaidApiEventCreateInput(
                  userId = Some(userId),
                  itemId = None,
                  plaidMethod = "getItem",
                  arguments = Map(),
                  requestId = error.requestId,
                  errorType = Some(error.errorType),
                  errorCode = Some(error.errorCode)
                )
              )
          )
          .map(body =>
            PlaidItemRepository
              .getByItemId(body.getItem().getItemId())
              .map(plaidItem =>
                PlaidApiEventRepository
                  .create(
                    PlaidApiEventCreateInput(
                      userId = Some(userId),
                      itemId = Some(plaidItem.id),
                      plaidMethod = "getItem",
                      arguments = Map(),
                      requestId = body.getRequestId(),
                      errorType = None,
                      errorCode = None
                    )
                  )
              )
          )
    )

  case class PlaidError(requestId: String, errorType: String, errorCode: String, errorMessage: String)

  object PlaidError {
    def fromJson(json: String): Either[io.circe.Error, PlaidError] = decode[PlaidError](json)
  }

  private def handleResponse[T: ClassTag](
      responseTry: Try[Response[T]],
      recordEvent: (Either[PlaidError, T]) => Unit
  ): Either[PlaidError, T] = {
    responseTry match {
      case Success(response) if response.isSuccessful =>
        val body = response.body()
        supervised {
          forkUser {
            recordEvent(Right(body))
          }
        }
        Right(body)
      case Success(response) =>
        val errorBody = response.errorBody().string()
        val plaidError = PlaidError.fromJson(errorBody) match {
          case Right(plaidError) => Left(plaidError)
          case Left(e)           => Left(PlaidError("unknown_request_id", "API_ERROR", "PARSE_ERROR", e.getMessage))
        }
        supervised {
          forkUser {
            recordEvent(plaidError)
          }
        }
        plaidError
      case Failure(exception) =>
        val plaidError = PlaidError("unknown_request_id", "API_ERROR", "UNKNOWN_ERROR", exception.getMessage)
        Left(plaidError)
    }
  }
