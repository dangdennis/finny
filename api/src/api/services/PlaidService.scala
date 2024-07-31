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
import io.circe.Decoder
import io.circe.HCursor
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

    def getAccounts(client: PlaidApi, item: PlaidItem): Either[AppError, AccountsGetResponse] =
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
                                requestId = Some(error.requestId),
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

    def getTransactionsSync(client: PlaidApi, item: PlaidItem): Either[AppError, TransactionsSyncResponse] =
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
                                requestId = Some(error.requestId),
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

    def createLinkToken(client: PlaidApi, userId: UUID): Either[AppError, LinkTokenCreateResponse] =
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
                                requestId = Some(error.requestId),
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

    def exchangePublicToken(
        client: PlaidApi,
        publicToken: String,
        userId: UUID
    ): Either[AppError, ItemPublicTokenExchangeResponse] =
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
                                requestId = Some(error.requestId),
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

    def getItem(client: PlaidApi, accessToken: String, userId: UUID): Either[AppError, ItemGetResponse] =
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
                                requestId = Some(error.requestId),
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

    def deleteItem(client: PlaidApi, itemId: PlaidItemId): Either[AppError, Unit] = PlaidItemRepository
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
                                .map(ex => AppError.DatabaseError(ex.getMessage))
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
                                                    requestId = Some(error.requestId),
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
                            ).left
                                .map(
                                    _.match {
                                        case AppError.ServiceError(error) =>
                                            throw new Exception(error.errorMessage)
                                        case ex =>
                                            ex
                                    }
                                )
                        yield response
                }
            ).toEither
        )

    def getInvestmentTransactions(
        client: PlaidApi,
        itemId: PlaidItemId
    ): Either[AppError, InvestmentsTransactionsGetResponse] = PlaidItemRepository
        .getById(itemId.toUUID)
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
                                    requestId = Some(error.requestId),
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

    def getInvestmentHoldings(client: PlaidApi, item: PlaidItem): Either[AppError, InvestmentsHoldingsGetResponse] =
        PlaidItemRepository
            .getById(item.id.toUUID)
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
                                        requestId = Some(error.requestId),
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

    case class PlaidError(
        errorType: String,
        errorCode: String,
        errorMessage: String,
        displayMessage: String,
        requestId: String,
        status: Int,
        documentationUrl: String,
        suggestedAction: String
    )

    object PlaidError:
        implicit val decoder: Decoder[PlaidError] =
            new Decoder[PlaidError] {
                final def apply(c: HCursor): Decoder.Result[PlaidError] =
                    for {
                        errorType <- c.downField("error_type").as[String]
                        errorCode <- c.downField("error_code").as[String]
                        errorMessage <- c.downField("error_message").as[String]
                        displayMessage <- c.downField("display_message").as[String]
                        requestId <- c.downField("request_id").as[String]
                        status <- c.downField("status").as[Int]
                        documentationUrl <- c.downField("documentation_url").as[String]
                        suggestedAction <- c.downField("suggested_action").as[String]
                    } yield {
                        PlaidError(
                            errorType,
                            errorCode,
                            errorMessage,
                            displayMessage,
                            requestId,
                            status,
                            documentationUrl,
                            suggestedAction
                        )
                    }
            }

        def fromJson(json: String): Either[io.circe.Error, PlaidError] = io.circe.parser.decode[PlaidError](json)

    private def handlePlaidResponse[T: ClassTag](
        responseTry: Try[Response[T]],
        recordEvent: (Either[PlaidError, T]) => Unit
    ): Either[AppError, T] =
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
                val appError =
                    PlaidError.fromJson(errorBody) match {
                        case Right(plaidError) =>
                            Left(AppError.ServiceError(plaidError))
                        case Left(e) =>
                            Left(AppError.ValidationError(e.getMessage))
                    }
                Future {
                    appError match {
                        case Left(AppError.ServiceError(plaidError)) =>
                            recordEvent(Left(plaidError))
                    }
                }(using ExecutionContext.global)
                appError
            case Failure(exception) =>
                Logger.root.error(s"Unexpected exception on plaid call", exception)
                Left(AppError.NetworkError(exception.getMessage))
        }
