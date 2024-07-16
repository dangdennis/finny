package app.services

import app.common.*
import app.jobs.Jobs
import app.models.PlaidItem
import app.repositories.AccountRepository
import app.repositories.PlaidItemRepository
import app.repositories.TransactionRepository
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
    private val rateLimiterRegistry = RateLimiterRegistry.of(rateLimiterConfig);
    private val rateLimiter = rateLimiterRegistry
        .rateLimiter("plaidSyncRateLimiter");
    private val retryConfig = RetryConfig
        .custom()
        .maxAttempts(3)
        .waitDuration(java.time.Duration.ofSeconds(20))
        .build()
    private val retryRegistry: RetryRegistry = RetryRegistry.of(retryConfig)
    private val retry = retryRegistry.retry("PlaidSyncRetry")

    def sync(itemId: UUID): Unit =
        Future {
            val decoratedTask = RateLimiter.decorateRunnable(rateLimiter, Retry.decorateRunnable(retry, () => _sync(itemId)))
            Future {
                decoratedTask.run()
            }.onComplete {
                case Success(_)  => Logger.root.info(s"Sync for item ${itemId} completed successfully.")
                case Failure(ex) => Logger.root.error(s"Sync for item ${itemId} failed.", ex)
            }
        }

    def syncHistorical(itemId: UUID) =
        PlaidItemRepository
            .updateTransactionCursor(itemId = itemId, cursor = None)
            .map { _ =>
                sync(itemId)
            }

    def runPlaidSyncPeriodically(): Unit =
        while true do
            val currentTime = java.time.Instant.now()
            Logger.root.info(s"Executing Plaid sync at ${currentTime}")
            PlaidItemRepository.getItemsPendingSync(now = currentTime).map { items =>
                items.foreach { item =>
                    Jobs.enqueueJob(
                        Jobs.JobRequest
                            .JobSyncPlaidItem(
                                itemId = item.id,
                                syncType = Jobs.SyncType.Default,
                                environment = Environment.appEnvToString(Environment.getAppEnv)
                            )
                    )
                }
            }
            Thread.sleep(60000 * 60)

    // todo: simplify error logging
    // 1. update error on any failed transaction or account upsert - done
    // 2. on item db fetch or plaid api call, log a single error
    private def _sync(itemId: UUID): Unit =
        Logger.root.info(s"Syncing transactions and accounts for item: $itemId")
        val item = PlaidItemRepository.getById(itemId)
        item match
            case Left(exception) =>
                Logger.root.error(f"Error getting item", exception)
                PlaidItemRepository.updateSyncError(itemId = itemId, error = exception.getMessage, currentTime = java.time.Instant.now())
            case Right(item) =>
                var cursor = item.transactionsCursor
                var hasMore = true
                while hasMore do
                    PlaidService.getTransactionsSync(client = PlaidService.makePlaidClientFromEnv(), item = item) match
                        case Left(error) =>
                            Logger.root.error(s"Error syncing transactions", error)
                            PlaidItemRepository.updateSyncError(
                                itemId = item.id,
                                error = error.errorMessage,
                                currentTime = java.time.Instant.now()
                            )
                        case Right(resp) =>
                            handleItemResponse(item, resp)
                            hasMore = resp.getHasMore().booleanValue()
                            cursor = Option(resp.getNextCursor())

    private def handleItemResponse(item: PlaidItem, response: TransactionsSyncResponse): Unit =
        val accounts = response.getAccounts.asScala
        var encounteredError = (false, "")
        Logger.root.info(s"Got number of accounts: ${accounts.size}")
        for account <- accounts do
            AccountRepository.upsertAccount(
                AccountRepository.UpsertAccountInput(
                    itemId = item.id,
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
            ) match
                case Failure(error) =>
                    val msg = s"Error upserting account: $error"
                    Logger.root.error(msg)
                    encounteredError = (true, msg)
                case Success(accountId) =>
                    Logger.root.info(s"Upserted account: $accountId")

        val added_or_modified = response.getAdded.asScala ++ response.getModified.asScala
        Logger.root.info(s"added_or_modified length: ${added_or_modified.size}")
        val removed = response.getRemoved.asScala
        Logger.root.info(s"removed length: ${removed.size}")

        for transaction <- added_or_modified do
            Logger.root.info(s"Upserting transaction: $transaction")
            AccountRepository.getByPlaidAccountId(itemId = item.id, plaidAccountId = transaction.getAccountId) match
                case Failure(error) =>
                    val msg = s"Failed to upsert transaction ${transaction.getTransactionId} due to missing account: $error"
                    encounteredError = (true, msg)
                    Logger.root.error(msg)
                case Success(account) =>
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

        TransactionRepository.deleteTransactionsByPlaidIds(removed.map(_.getTransactionId()).toList)

        encounteredError match
            case (false, _) =>
                PlaidItemRepository.updateSyncSuccess(itemId = item.id, currentTime = java.time.Instant.now())
                PlaidItemRepository.updateTransactionCursor(itemId = item.id, cursor = Option(response.getNextCursor))
            case (true, msg) =>
                PlaidItemRepository.updateSyncError(itemId = item.id, error = msg, currentTime = java.time.Instant.now())
