package api.services

import api.common.*
import api.common.Environment.AppEnv
import api.models.PlaidItem
import api.models.PlaidItemId
import api.repositories.PlaidApiEventRepository
import api.repositories.PlaidApiEventRepository.PlaidApiEventCreateInput
import api.repositories.PlaidItemRepository
import com.plaid.client.ApiClient
import com.plaid.client.model.*
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

    def getAccounts(client: PlaidApi, item: PlaidItem) =
        val req = new AccountsGetRequest().accessToken(item.plaidAccessToken)
        val res = Try(client.accountsGet(req).execute())

        handlePlaidResponse(
            res,
            respBody =>
                respBody
                    .left
                    .map(error =>
                        PlaidApiEventRepository.create(
                            PlaidApiEventCreateInput(
                                userId = Some(item.userId),
                                itemId = Some(item.id.toUUID),
                                plaidMethod = "accountsGet",
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
                                userId = Some(item.userId),
                                itemId = Some(item.id.toUUID),
                                plaidMethod = "accountsGet",
                                arguments = Map(),
                                requestId = Some(body.getRequestId),
                                errorType = None,
                                errorCode = None
                            )
                        )
                    )
        )

    def getTransactionsSync(client: PlaidApi, item: PlaidItem) =
        val req = new TransactionsSyncRequest()
            .accessToken(item.plaidAccessToken)
            .cursor(item.transactionsCursor.orNull)
            .count(500)
        val res = Try(client.transactionsSync(req).execute())

        handlePlaidResponse(
            res,
            respBody =>
                respBody
                    .left
                    .map(error =>
                        PlaidApiEventRepository.create(
                            PlaidApiEventCreateInput(
                                userId = Some(item.userId),
                                itemId = Some(item.id.toUUID),
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
                                itemId = Some(item.id.toUUID),
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

        handlePlaidResponse(
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
        handlePlaidResponse(
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
        handlePlaidResponse(
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
                                        itemId = Some(plaidItem.id.toUUID),
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

    def deleteItem(client: PlaidApi, itemId: PlaidItemId): Either[Throwable, Unit] = PlaidItemRepository
        .getById(itemId.toUUID)
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
                            response <- handlePlaidResponse(
                                Try(client.itemRemove(req).execute()),
                                respBody =>
                                    respBody
                                        .left
                                        .foreach { error =>
                                            PlaidApiEventRepository.create(
                                                PlaidApiEventRepository.PlaidApiEventCreateInput(
                                                    userId = None,
                                                    itemId = Some(itemId.toUUID),
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
                                                itemId = Some(itemId.toUUID),
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

    def getInvestmentTransactions(
        client: PlaidApi,
        itemId: PlaidItemId
    ): Either[PlaidError, InvestmentsTransactionsGetResponse] = PlaidItemRepository
        .getById(itemId.toUUID)
        .left
        .map(ex => PlaidError(None, "DB_ERROR", "DELETE_ERROR", ex.getMessage))
        .flatMap(plaidItem =>
            val today = Time.nowUtc()
            val yearAgo = today.minusYears(1)
            val req = InvestmentsTransactionsGetRequest()
                .accessToken(plaidItem.plaidAccessToken)
                .startDate(yearAgo.toLocalDate())
                .endDate(today.toLocalDate())
            handlePlaidResponse(
                Try(client.investmentsTransactionsGet(req).execute()),
                respBody =>
                    respBody
                        .left
                        .map(error =>
                            PlaidApiEventRepository.create(
                                PlaidApiEventCreateInput(
                                    userId = Some(plaidItem.userId),
                                    itemId = None,
                                    plaidMethod = "investmentsTransactionsGet",
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
                                    userId = Some(plaidItem.userId),
                                    itemId = None,
                                    plaidMethod = "investmentsTransactionsGet",
                                    arguments = Map(),
                                    requestId = Some(body.getRequestId()),
                                    errorType = None,
                                    errorCode = None
                                )
                            )
                        )
            )
        )

    def getInvestmentHoldings(
        client: PlaidApi,
        item: PlaidItem
    ): Either[PlaidError, InvestmentsHoldingsGetResponse] = PlaidItemRepository
        .getById(item.id.toUUID)
        .left
        .map(ex => PlaidError(None, "DB_ERROR", "DELETE_ERROR", ex.getMessage))
        .flatMap(plaidItem =>
            val req = InvestmentsHoldingsGetRequest().accessToken(plaidItem.plaidAccessToken)
            handlePlaidResponse(
                Try(client.investmentsHoldingsGet(req).execute()),
                respBody =>
                    respBody
                        .left
                        .map(error =>
                            PlaidApiEventRepository.create(
                                PlaidApiEventCreateInput(
                                    userId = Some(plaidItem.userId),
                                    itemId = None,
                                    plaidMethod = "investmentsHoldingsGet",
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
                                    userId = Some(plaidItem.userId),
                                    itemId = None,
                                    plaidMethod = "investmentsHoldingsGet",
                                    arguments = Map(),
                                    requestId = Some(body.getRequestId()),
                                    errorType = None,
                                    errorCode = None
                                )
                            )
                        )
            )
        )

    case class PlaidError(requestId: Option[String], errorType: String, errorCode: String, errorMessage: String)

    object PlaidError {
        def fromJson(json: String): Either[io.circe.Error, PlaidError] = decode[PlaidError](json)
    }

    private def handlePlaidResponse[T: ClassTag](
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
