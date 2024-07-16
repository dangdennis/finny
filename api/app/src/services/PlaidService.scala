package app.services

import app.common.*
import app.common.Environment
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
import com.plaid.client.model.LinkTokenTransactions
import com.plaid.client.model.Products
import com.plaid.client.model.TransactionsSyncRequest
import com.plaid.client.model.TransactionsSyncResponse
import com.plaid.client.request.PlaidApi
import io.circe.generic.auto.*
import io.circe.parser.decode
import retrofit2.Response

import java.util.UUID
import scala.collection.JavaConverters.*
import scala.concurrent.ExecutionContext
import scala.concurrent.Future
import scala.reflect.ClassTag
import scala.util.Failure
import scala.util.Success
import scala.util.Try
import com.plaid.client.model.ItemRemoveRequest
import scalikejdbc.DB
import com.plaid.client.model.ItemRemoveResponse

object PlaidService:
    private lazy val client = makePlaidClient()

    private def makePlaidClient() =
        val apiClient = new ApiClient(
            Map(
                "clientId" -> Environment.getPlaidClientId,
                "secret" -> Environment.getPlaidSecret,
                "plaidVersion" -> "2020-09-14"
            ).asJava
        )

        Environment.getAppEnv match
            case Environment.AppEnv.Production  => apiClient.setPlaidAdapter(ApiClient.Production)
            case Environment.AppEnv.Development => apiClient.setPlaidAdapter(ApiClient.Sandbox)

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
                                    requestId = Some(body.getRequestId()),
                                    errorType = None,
                                    errorCode = None
                                )
                            )
                    )
        )

    enum AccountType:
        case Credit, Depository, Investment, Loan

    def createLinkToken(userId: UUID) =
        val req = LinkTokenCreateRequest()
            .products(
                List(
                    Products.TRANSACTIONS
                ).asJava
            )
            .requiredIfSupportedProducts(
                List(
                    Products.INVESTMENTS,
                    Products.LIABILITIES
                ).asJava
            )
            .countryCodes(List(CountryCode.US).asJava)
            .user(LinkTokenCreateRequestUser().clientUserId(userId.toString))
            .webhook(f"${Environment.getBaseUrl}/webhooks/plaid")
            .language("en")
            .clientName("Finny")
            .transactions(LinkTokenTransactions().daysRequested(360))
            .redirectUri(f"${Environment.getBaseUrl}/oauth/plaid")

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
                                    requestId = Some(body.getRequestId()),
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
                                    requestId = Some(body.getRequestId()),
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
                                    plaidMethod = "itemGet",
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
                                            plaidMethod = "itemGet",
                                            arguments = Map(),
                                            requestId = Some(body.getRequestId()),
                                            errorType = None,
                                            errorCode = None
                                        )
                                    )
                            )
                    )
        )

    def removeItem(id: UUID): Either[PlaidError, ItemRemoveResponse] =
        val body = PlaidItemRepository
            .getById(id)
            .map(plaidItem =>
                val req = ItemRemoveRequest().accessToken(plaidItem.plaidAccessToken)
                client.itemRemove(req).execute()
            )
            .toTry

        val b = DB localTx { implicit session =>
            PlaidItemRepository
                .deleteItem(id)
                .map(_ =>
                    handleResponse(
                        body,
                        (respBody) =>
                            respBody.left
                                .map(error =>
                                    PlaidApiEventRepository
                                        .create(
                                            PlaidApiEventCreateInput(
                                                userId = None,
                                                itemId = None,
                                                plaidMethod = "itemRemove",
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
                                                userId = None,
                                                itemId = None,
                                                plaidMethod = "itemRemove",
                                                arguments = Map(),
                                                requestId = Some(body.getRequestId()),
                                                errorType = None,
                                                errorCode = None
                                            )
                                        )
                                )
                    )
                )
                .left
                .map(error => throw error)
        }

        // todo: how do i unnest b without using getOrElse?
        b.getOrElse(Left(PlaidError(None, "API_ERROR", "UNKNOWN_ERROR", "Unknown error")))

    case class PlaidError(requestId: Option[String], errorType: String, errorCode: String, errorMessage: String)

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
                Future {
                    recordEvent(Right(body))

                }(using ExecutionContext.global)
                Right(body)
            case Success(response) =>
                val errorBody = response.errorBody().string()
                Logger.root.error(s"Plaid API error: $errorBody")
                val plaidError = PlaidError.fromJson(errorBody) match {
                    case Right(plaidError) => Left(plaidError)
                    case Left(e)           => Left(PlaidError(None, "API_ERROR", "PARSE_ERROR", e.getMessage))
                }
                Future {
                    recordEvent(plaidError)
                }(using ExecutionContext.global)
                plaidError
            case Failure(exception) =>
                Logger.root.error(s"Unexpected exception on plaid call", exception)
                val plaidError = PlaidError(None, "API_ERROR", "UNKNOWN_ERROR", exception.getMessage)
                Left(plaidError)
        }
    }
