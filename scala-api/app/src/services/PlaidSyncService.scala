package app.services

import app.repositories.AccountRepository
import app.repositories.PlaidItemRepository

import java.util.UUID
import scala.collection.JavaConverters._
import scala.util.Failure
import scala.util.Success

object PlaidSyncService:
  def syncTransactionsAndAccounts(itemId: UUID): Unit =
    val item = PlaidItemRepository.getItem(itemId).get
    val transactionsSyncResp = PlaidService.getTransactionsSync(accessToken = item.plaidAccessToken)

    transactionsSyncResp match
      case Failure(error) =>
        println(s"error syncing transactions: $error")
      case Success(response) =>
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
        val removed = response.getRemoved().asScala
