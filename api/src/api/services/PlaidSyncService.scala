package api.services

import api.common.*
import api.jobs.Jobs
import api.models.PlaidItem
import api.models.PlaidItemId
import api.models.SecurityType
import api.repositories.AccountRepository
import api.repositories.InvestmentRepository
import api.repositories.PlaidItemRepository
import api.repositories.TransactionRepository
import api.services.PlaidService.PlaidError
import com.plaid.client.model.AccountBase
import com.plaid.client.model.TransactionsSyncResponse
import io.github.resilience4j.ratelimiter.*
import io.github.resilience4j.retry.*

import java.util.UUID
import scala.concurrent.ExecutionContext
import scala.concurrent.Future
import scala.jdk.CollectionConverters.*
import scala.util.Failure
import scala.util.Success

object PlaidSyncService:
    given ec: ExecutionContext = ExecutionContext.global

    private val rateLimiterConfig = RateLimiterConfig
        .custom()
        .timeoutDuration(java.time.Duration.ofMillis(500))
        .limitForPeriod(45)
        .limitRefreshPeriod(java.time.Duration.ofMinutes(1))
        .build()
    private val rateLimiterRegistry = RateLimiterRegistry.of(rateLimiterConfig)
    private val rateLimiter = rateLimiterRegistry.rateLimiter("plaidSyncRateLimiter")
    private val retryConfig = RetryConfig.custom().maxAttempts(3).waitDuration(java.time.Duration.ofSeconds(20)).build()
    private val retryRegistry: RetryRegistry = RetryRegistry.of(retryConfig)
    private val retry = retryRegistry.retry("PlaidSyncRetry")

    def sync(itemId: PlaidItemId): Future[Unit] = Future {
        val decoratedTask = RateLimiter.decorateRunnable(
            rateLimiter,
            Retry.decorateRunnable(
                retry,
                () =>
                    Logger.root.info(s"Syncing transactions and accounts for item: $itemId")
                    (
                        for
                            item <- PlaidItemRepository.getById(itemId.toUUID)
                            _ <- syncAccounts(item)
                            _ <- syncNonInvestmentAccounts(item)
                            _ <- syncInvestmentAccounts(item)
                        yield ()
                    ) match
                        case Right(_) =>
                            Logger.root.info(s"Sync for item ${itemId} completed successfully.")
                        case Left(error) =>
                            error match
                                case AppError.DatabaseError(message) =>
                                    Logger.root.error(s"Sync for item ${itemId} failed.", message)
                                case AppError.ValidationError(message) =>
                                    Logger.root.error(s"Sync for item ${itemId} failed.", message)
                                case AppError.ServiceError(error) =>
                                    Logger.root.error(s"Sync for item ${itemId} failed.", error.errorMessage)
                                case AppError.NetworkError(message) =>
                                    Logger.root.error(s"Sync for item ${itemId} failed.", message)
                                case AppError.NotFoundError(error) =>
                                    Logger.root.error(s"Sync for item ${itemId} failed.", "Item not found.")
            )
        )

        Future {
            decoratedTask.run()
        }.onComplete {
            case Success(_) =>
                Logger.root.info(s"Sync for item ${itemId} completed successfully.")
            case Failure(ex) =>
                Logger.root.error(s"Sync for item ${itemId} failed.", ex)
        }
    }

    def syncAccounts(item: PlaidItem) = PlaidService
        .getAccounts(PlaidService.makePlaidClientFromEnv(), item)
        .map(accountsResp => accountsResp.getAccounts.asScala.map(account => upsertAccount(item, account)))

    def syncHistorical(itemId: PlaidItemId) = PlaidItemRepository
        .updateTransactionCursor(itemId = itemId.toUUID, cursor = None)
        .map { _ =>
            sync(itemId)
        }

    def runPlaidSyncPeriodically(): Unit =
        while true do
            val currentTime = java.time.Instant.now()
            Logger.root.info(s"Executing Plaid sync at ${currentTime}")
            PlaidItemRepository
                .getItemsPendingSync(now = currentTime)
                .map { items =>
                    items.foreach { item =>
                        Jobs.enqueueJob(
                            Jobs.JobRequest
                                .JobSyncPlaidItem(
                                    itemId = item.id.toUUID,
                                    syncType = Jobs.SyncType.Default,
                                    environment = Environment.appEnvToString(Environment.getAppEnv)
                                )
                        )
                    }
                }
            Thread.sleep(60000 * 60)

    private def syncNonInvestmentAccounts(item: PlaidItem): Either[AppError, Unit] =
        Logger.root.info(s"Syncing non-investment accounts and transactions for item: ${item.id}")
        var cursor = item.transactionsCursor
        var hasMore = true
        while hasMore do
            PlaidService.getTransactionsSync(client = PlaidService.makePlaidClientFromEnv(), item = item) match
                case Left(appError) =>
                    Logger.root.error(s"Error syncing transactions", appError)
                    PlaidItemRepository.updateSyncError(
                        itemId = item.id.toUUID,
                        error =
                            appError match {
                                case AppError.DatabaseError(error) =>
                                    error
                                case AppError.ServiceError(error) =>
                                    error.errorMessage
                                case AppError.ValidationError(error) =>
                                    error
                                case AppError.NetworkError(error) =>
                                    error
                                case AppError.NotFoundError(error) =>
                                    error
                            },
                        currentTime = java.time.Instant.now()
                    )
                    return Left(appError)
                case Right(resp) =>
                    handleItemResponse(item, resp)
                    hasMore = resp.getHasMore().booleanValue()
                    Logger.root.info(s"Sync ${item.id} hasMore: $hasMore")
                    cursor = Option(resp.getNextCursor())
                    Logger.root.info(s"Sync ${item.id} cursor: $cursor")

        Right(())

    private def syncInvestmentAccounts(item: PlaidItem): Either[AppError, Unit] =
        Logger.root.info(s"Attempt investment accounts and holdings for item: ${item.id}")
        AccountRepository
            .getAccounts(item.userId)
            .flatMap(accounts =>
                val investmentAccounts = accounts.filter(account => {
                    account.accountType match
                        case Some(actType) =>
                            actType == "investment"
                        case None =>
                            false
                })
                Logger.root.info(s"Found ${investmentAccounts.size} investment accounts for item: ${item.id}")
                Logger.root.info(s"Is investmentAccounts empty: ${investmentAccounts.isEmpty}")
                if investmentAccounts.isEmpty then
                    Logger.root.info(s"No investment accounts found for item: ${item.id}")
                    Logger.root.info("Skipping investment account sync")
                    Right(())
                else
                    Logger.root.info(s"Syncing investment accounts and holdings for item: ${item.id}")
                    PlaidService.getInvestmentHoldings(client = PlaidService.makePlaidClientFromEnv(), item) match
                        case Left(appError) =>
                            Logger.root.error(s"Error syncing investment holdings", appError)
                            PlaidItemRepository.updateSyncError(
                                itemId = item.id.toUUID,
                                error = appError.toString(),
                                currentTime = java.time.Instant.now()
                            )
                            Left(appError)
                        case Right(resp) =>
                            resp.getAccounts()
                                .asScala
                                .map(account =>
                                    upsertAccount(item, account) match
                                        case Left(error) =>
                                            Logger.root.error(s"Error upserting account: $error")
                                        case Right(accountId) =>
                                            Logger.root.info(s"Upserted account: $accountId")
                                )
                            resp.getSecurities()
                                .asScala
                                .map(security =>
                                    InvestmentRepository.upsertInvestmentSecurity(
                                        InvestmentRepository.InvestmentSecurityInput(
                                            plaidSecurityId = security.getSecurityId(),
                                            plaidInstitutionSecurityId = Option(security.getInstitutionSecurityId),
                                            plaidInstitutionId = Option(security.getInstitutionId),
                                            plaidProxySecurityId = Option(security.getProxySecurityId),
                                            name = Option(security.getName),
                                            tickerSymbol = Option(security.getTickerSymbol),
                                            securityType =
                                                SecurityType.fromString(security.getType()) match
                                                    case Right(securityType) =>
                                                        Some(securityType)
                                                    case Left(error) =>
                                                        Logger.root.error(s"Error parsing security type: $error")
                                                        None
                                        )
                                    )
                                )
                            resp.getHoldings()
                                .asScala
                                .map(holding =>
                                    for
                                        account <- AccountRepository.getByPlaidAccountId(
                                            itemId = item.id.toUUID,
                                            plaidAccountId = holding.getAccountId()
                                        )
                                        security <-
                                            for
                                                securityOpt <- InvestmentRepository
                                                    .getInvestmentSecurityByPlaidSecurityId(holding.getSecurityId())
                                                security <- securityOpt
                                                    .map(Right(_))
                                                    .getOrElse(
                                                        Left(
                                                            AppError.DatabaseError(
                                                                s"Security ${holding.getSecurityId()} not found"
                                                            )
                                                        )
                                                    )
                                            yield security
                                        res <-
                                            Logger.root.info(s"Upserting holding for account: ${account.id}")
                                            InvestmentRepository.upsertInvestmentHoldings(
                                                InvestmentRepository.InvestmentHoldingInput(
                                                    accountId = account.id,
                                                    investmentSecurityId = security.id,
                                                    institutionPrice = holding.getInstitutionPrice,
                                                    institutionPriceAsOf = Option(holding.getInstitutionPriceAsOf),
                                                    institutionPriceDateTime = Option(
                                                        holding.getInstitutionPriceDatetime
                                                    ).map(_.toInstant()),
                                                    institutionValue = holding.getInstitutionValue,
                                                    costBasis = Option(holding.getCostBasis),
                                                    quantity = holding.getQuantity,
                                                    isoCurrencyCode = Option(holding.getIsoCurrencyCode),
                                                    unofficialCurrencyCode = Option(holding.getUnofficialCurrencyCode),
                                                    vestedValue = Option(holding.getVestedValue)
                                                )
                                            )
                                    do
                                        (
                                    )
                                )
                            Right(())
            )

    private def handleItemResponse(item: PlaidItem, response: TransactionsSyncResponse): Unit =
        val accounts = response.getAccounts.asScala
        var encounteredError = (false, "")
        Logger.root.info(s"Got number of accounts: ${accounts.size}")
        for account <- accounts do
            Logger.root.info(s"Upserting account: ${account.getAccountId}")
            upsertAccount(item, account) match
                case Left(error) =>
                    val msg = s"Error upserting account: $error"
                    Logger.root.error(msg)
                    encounteredError = (true, msg)
                case Right(accountId) =>
                    Logger.root.info(s"Upserted account: $accountId")

        val added_or_modified = response.getAdded.asScala ++ response.getModified.asScala
        Logger.root.info(s"added_or_modified length: ${added_or_modified.size}")
        val removed = response.getRemoved.asScala
        Logger.root.info(s"removed length: ${removed.size}")

        for transaction <- added_or_modified do
            AccountRepository
                .getByPlaidAccountId(itemId = item.id.toUUID, plaidAccountId = transaction.getAccountId) match
                case Left(error) =>
                    val msg =
                        s"Failed to upsert transaction ${transaction.getTransactionId} due to missing account: $error"
                    encounteredError = (true, msg)
                    Logger.root.error(msg)
                case Right(account) =>
                    val _ = TransactionRepository.upsertTransaction(
                        TransactionRepository.UpsertTransactionInput(
                            accountId = account.id,
                            plaidTransactionId = transaction.getTransactionId,
                            category = Option(transaction.getPersonalFinanceCategory.getPrimary),
                            subcategory = Option(transaction.getPersonalFinanceCategory.getDetailed),
                            transactionType = transaction.getTransactionType.getValue,
                            name = transaction.getName,
                            amount = transaction.getAmount.toDouble,
                            isoCurrencyCode = Option(transaction.getIsoCurrencyCode),
                            unofficialCurrencyCode = Option(transaction.getUnofficialCurrencyCode),
                            date = transaction.getDate.atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
                            pending = transaction.getPending.booleanValue(),
                            accountOwner = Option(transaction.getAccountOwner)
                        )
                    )

        TransactionRepository.deleteTransactionsByPlaidTransactionIds(removed.map(_.getTransactionId).toList)

        encounteredError match
            case (false, _) =>
                PlaidItemRepository.updateSyncSuccess(itemId = item.id.toUUID, currentTime = java.time.Instant.now())
                PlaidItemRepository
                    .updateTransactionCursor(itemId = item.id.toUUID, cursor = Option(response.getNextCursor))
            case (true, msg) =>
                PlaidItemRepository
                    .updateSyncError(itemId = item.id.toUUID, error = msg, currentTime = java.time.Instant.now())

    def upsertAccount(item: PlaidItem, account: AccountBase): Either[AppError.DatabaseError, UUID] = AccountRepository
        .upsertAccount(
            AccountRepository.UpsertAccountInput(
                itemId = item.id.toUUID,
                userId = item.userId,
                plaidAccountId = account.getAccountId,
                name = account.getName,
                mask = Option(account.getMask),
                officialName = Option(account.getOfficialName),
                currentBalance = account.getBalances.getCurrent(),
                availableBalance = account.getBalances.getAvailable(),
                isoCurrencyCode = Option(account.getBalances.getIsoCurrencyCode),
                unofficialCurrencyCode = Option(account.getBalances.getUnofficialCurrencyCode),
                accountType = Option(account.getType.getValue),
                accountSubtype = Option(account.getSubtype.getValue)
            )
        )
