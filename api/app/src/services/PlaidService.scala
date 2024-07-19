package app.services

import app.common.*
import app.common.Environment
import app.common.Environment.AppEnv
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
import com.plaid.client.model.ItemRemoveRequest
import com.plaid.client.model.ItemRemoveResponse
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
import scalikejdbc.DB

import java.util.UUID
import scala.collection.JavaConverters.*
import scala.concurrent.ExecutionContext
import scala.concurrent.Future
import scala.reflect.ClassTag
import scala.util.Failure
import scala.util.Success
import scala.util.Try

object PlaidService:
    def makePlaidClient(clientId: String, secret: String, env: AppEnv) =
        val apiClient =
            new ApiClient(Map("clientId" -> clientId, "secret" -> secret, "plaidVersion" -> "2020-09-14").asJava)

        apiClient.setPlaidAdapter(
            env match
                case AppEnv.Production =>
                    ApiClient.Production
                case AppEnv.Development =>
                    ApiClient.Sandbox
        )

        apiClient.createService(classOf[PlaidApi])

    def makePlaidClientFromEnv() =
        val apiClient =
            new ApiClient(
                Map(
                    "clientId" -> Environment.getPlaidClientId,
                    "secret" -> Environment.getPlaidSecret,
                    "plaidVersion" -> "2020-09-14"
                ).asJava
            )

        Environment.getAppEnv match
            case Environment.AppEnv.Production =>
                apiClient.setPlaidAdapter(ApiClient.Production)
            case Environment.AppEnv.Development =>
                apiClient.setPlaidAdapter(ApiClient.Sandbox)

        apiClient.createService(classOf[PlaidApi])

    def getTransactionsSync(client: PlaidApi, item: PlaidItem) =
        val req = new TransactionsSyncRequest()
            .accessToken(item.plaidAccessToken)
            .cursor(item.transactionsCursor.orNull)
        val res = Try(client.transactionsSync(req).execute())

        handleResponse(
            res,
            respBody =>
                respBody
                    .left
                    .map(error =>
                        PlaidApiEventRepository.create(
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
                        PlaidApiEventRepository.create(
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
        case Credit,
            Depository,
            Investment,
            Loan

    def createLinkToken(client: PlaidApi, userId: UUID) =
        val req = LinkTokenCreateRequest()
            .products(List(Products.TRANSACTIONS).asJava)
            .requiredIfSupportedProducts(List(Products.INVESTMENTS, Products.LIABILITIES).asJava)
            .countryCodes(List(CountryCode.US).asJava)
            .user(LinkTokenCreateRequestUser().clientUserId(userId.toString))
            .webhook(f"${Environment.getBaseUrl}/webhooks/plaid")
            .language("en")
            .clientName("Finny")
            .transactions(LinkTokenTransactions().daysRequested(360))
            .redirectUri(f"${Environment.getBaseUrl}/oauth/plaid")

        handleResponse(
            Try(client.linkTokenCreate(req).execute()),
            respBody =>
                respBody
                    .left
                    .map(error =>
                        PlaidApiEventRepository.create(
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
                        PlaidApiEventRepository.create(
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

    def exchangePublicToken(client: PlaidApi, publicToken: String, userId: UUID) =
        val req = ItemPublicTokenExchangeRequest().publicToken(publicToken)
        handleResponse(
            Try(client.itemPublicTokenExchange(req).execute()),
            respBody =>
                respBody
                    .left
                    .map(error =>
                        PlaidApiEventRepository.create(
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
                        PlaidApiEventRepository.create(
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

    def getItem(client: PlaidApi, accessToken: String, userId: UUID) =
        val req = ItemGetRequest().accessToken(accessToken)
        handleResponse(
            Try(client.itemGet(req).execute()),
            respBody =>
                respBody
                    .left
                    .map(error =>
                        PlaidApiEventRepository.create(
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
                                PlaidApiEventRepository.create(
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

    def removeItem(client: PlaidApi, itemId: UUID): Either[Throwable, Unit] = PlaidItemRepository
        .getById(itemId)
        .map(plaidItem =>
            val req = ItemRemoveRequest().accessToken(plaidItem.plaidAccessToken)
            Try(
                DB.localTx { implicit session =>
                    val result =
                        for
                            _ <- PlaidItemRepository
                                .deleteItemById(itemId)
                                .left
                                .map(ex => PlaidError(None, "DB_ERROR", "DELETE_ERROR", ex.getMessage))
                            response <- handleResponse(
                                Try(client.itemRemove(req).execute()),
                                respBody =>
                                    respBody
                                        .left
                                        .foreach { error =>
                                            PlaidApiEventRepository.create(
                                                PlaidApiEventRepository.PlaidApiEventCreateInput(
                                                    userId = None,
                                                    itemId = Some(itemId),
                                                    plaidMethod = "itemRemove",
                                                    arguments = Map(),
                                                    requestId = error.requestId,
                                                    errorType = Some(error.errorType),
                                                    errorCode = Some(error.errorCode)
                                                )
                                            )
                                        }
                                    respBody.map { body =>
                                        PlaidApiEventRepository.create(
                                            PlaidApiEventRepository.PlaidApiEventCreateInput(
                                                userId = None,
                                                itemId = Some(itemId),
                                                plaidMethod = "itemRemove",
                                                arguments = Map(),
                                                requestId = Some(body.getRequestId()),
                                                errorType = None,
                                                errorCode = None
                                            )
                                        )
                                    }
                            ).left.map(error => throw new Exception(error.errorMessage))
                        yield response
                }
            )
        )

    case class PlaidError(requestId: Option[String], errorType: String, errorCode: String, errorMessage: String)

    object PlaidError {
        def fromJson(json: String): Either[io.circe.Error, PlaidError] = decode[PlaidError](json)
    }

    private def handleResponse[T: ClassTag](
        responseTry: Try[Response[T]],
        recordEvent: (Either[PlaidError, T]) => Unit
    ): Either[PlaidError, T] =
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
                val plaidError =
                    PlaidError.fromJson(errorBody) match {
                        case Right(plaidError) =>
                            Left(plaidError)
                        case Left(e) =>
                            Left(PlaidError(None, "API_ERROR", "PARSE_ERROR", e.getMessage))
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
