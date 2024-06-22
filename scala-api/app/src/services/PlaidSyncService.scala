package app.services

import app.models.PlaidItem
import app.repositories.AccountRepository
import app.repositories.PlaidItemRepository
import app.repositories.TransactionRepository
import com.plaid.client.model.TransactionsSyncResponse

import java.util.UUID
import scala.collection.JavaConverters.*
import scala.util.Failure
import scala.util.Success

object PlaidSyncService:
  def syncTransactionsAndAccounts(itemId: UUID): Unit =
    val item = PlaidItemRepository.getById(itemId)
    item match
      case Failure(exception) =>
        // todo: print and log exception to sentry
        println(f"Failed to get item of itemId ${itemId}. err=${exception}")
      case Success(item) =>
        var cursor = item.transactionsCursor
        var hasMore = true
        while hasMore do
          var transactionsSyncResp = PlaidService.getTransactionsSync(accessToken = item.plaidAccessToken, cursor = cursor)
          transactionsSyncResp match
            case Failure(error) =>
              println(s"error syncing transactions: $error")
            case Success(response) =>
              sync(item, response)
              hasMore = response.getHasMore().booleanValue()
              cursor = Option(response.getNextCursor())

  private def sync(item: PlaidItem, response: TransactionsSyncResponse): Unit =
    val accounts = response.getAccounts().asScala
    println(s"accounts length: ${accounts.length}")
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
          println(s"error upserting account: $error")
        case Success(accountId) =>
          println(s"upserted account: ${accountId}")

    val added_or_modified = response.getAdded().asScala ++ response.getModified().asScala
    println(s"added_or_modified length: ${added_or_modified.size}")
    val removed = response.getRemoved().asScala
    println(s"removed length: ${removed.size}")

    for transaction <- added_or_modified do
      AccountRepository.getByPlaidAccountId(itemId = item.id, plaidAccountId = transaction.getAccountId()) match
        case Failure(error) =>
          println(s"failed to upsert transaction ${transaction.getTransactionId()} due to missing account: $error")
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
