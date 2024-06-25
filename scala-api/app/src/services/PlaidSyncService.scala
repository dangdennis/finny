package app.services

import app.models.PlaidItem
import app.repositories.AccountRepository
import app.repositories.PlaidItemRepository
import app.repositories.TransactionRepository
import app.utils.logger.Logger
import com.plaid.client.model.TransactionsSyncResponse
import ox.resilience.RetryPolicy
import ox.resilience.Schedule
import ox.resilience.retry

import java.util.UUID
import java.util.concurrent.TimeUnit
import scala.collection.JavaConverters.*
import scala.concurrent.duration.FiniteDuration
import scala.util.Failure
import scala.util.Success

object PlaidSyncService:
  def syncTransactionsAndAccountsWithRetry(itemId: UUID): Unit =
    retry(
      RetryPolicy(
        onRetry = (error, _) => Logger.root.error(s"Error syncing transactions and accounts: $error"),
        schedule = Schedule.Backoff(
          initialDelay = FiniteDuration(1, TimeUnit.SECONDS),
          maxRetries = 5,
        )
      )
    )(() => syncTransactionsAndAccounts(itemId))

  def syncTransactionsAndAccounts(itemId: UUID): Unit =
    val item = PlaidItemRepository.getById(itemId)
    item match
      case Failure(exception) =>
        Logger.root.error(f"Error getting item: $exception")
      case Success(item) =>
        var cursor = item.transactionsCursor
        var hasMore = true
        while hasMore do
          var transactionsSyncResp = PlaidService.getTransactionsSync(item)
          transactionsSyncResp match
            case Left(error) =>
              Logger.root.error(s"Error syncing transactions: $error")
            case Right(resp) =>
              sync(item, resp)
              hasMore = resp.getHasMore().booleanValue()
              cursor = Option(resp.getNextCursor())

  private def sync(item: PlaidItem, response: TransactionsSyncResponse): Unit =
    val accounts = response.getAccounts().asScala
    Logger.root.info(s"Got number of accounts: ${accounts.size}")
    for account <- accounts do
      val newAcct = AccountRepository.upsertAccount(
        AccountRepository.UpsertAccountInput(
          itemId = item.id,
          userId = item.userId,
          plaidAccountId = account.getAccountId(),
          name = account.getName(),
          mask = Option(account.getMask()),
          officialName = Option(account.getOfficialName()),
          currentBalance = account.getBalances().getCurrent(),
          availableBalance = account.getBalances().getAvailable(),
          isoCurrencyCode = Option(account.getBalances().getIsoCurrencyCode()),
          unofficialCurrencyCode = Option(account.getBalances().getUnofficialCurrencyCode()),
          accountType = Option(account.getType().getValue()),
          accountSubtype = Option(account.getSubtype().getValue())
        )
      ) match
        case Failure(error) =>
          Logger.root.error(s"Error upserting account: $error")
        case Success(accountId) =>
          Logger.root.error(s"Upserted account: ${accountId}")

    val added_or_modified = response.getAdded().asScala ++ response.getModified().asScala
    Logger.root.info(s"added_or_modified length: ${added_or_modified.size}")
    val removed = response.getRemoved().asScala
    Logger.root.info(s"removed length: ${removed.size}")

    for transaction <- added_or_modified do
      AccountRepository.getByPlaidAccountId(itemId = item.id, plaidAccountId = transaction.getAccountId()) match
        case Failure(error) =>
          Logger.root.error(s"Failed to upsert transaction ${transaction.getTransactionId()} due to missing account: $error")
        case Success(account) =>
          val _ = TransactionRepository.upsertTransaction(
            TransactionRepository.UpsertTransactionInput(
              accountId = account.id,
              plaidTransactionId = transaction.getTransactionId(),
              category = Option(transaction.getPersonalFinanceCategory().getPrimary()),
              subcategory = Option(transaction.getPersonalFinanceCategory().getDetailed()),
              transactionType = transaction.getTransactionType().getValue(),
              name = transaction.getName(),
              amount = transaction.getAmount().toDouble,
              isoCurrencyCode = Option(transaction.getIsoCurrencyCode()),
              unofficialCurrencyCode = Option(transaction.getUnofficialCurrencyCode()),
              date = transaction.getDate().atStartOfDay().toInstant(java.time.ZoneOffset.UTC),
              pending = transaction.getPending().booleanValue(),
              accountOwner = Option(transaction.getAccountOwner())
            )
          )

    TransactionRepository.delete(removed.map(_.getTransactionId()).toList)

    PlaidItemRepository.updateTransactionCursor(itemId = item.id, cursor = Option(response.getNextCursor()))
