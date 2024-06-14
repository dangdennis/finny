package app.services

import app.repositories.AccountRepository
import app.repositories.PlaidItemRepository
import ox._

import java.util.UUID
import scala.collection.JavaConverters._
import scala.util.Failure
import scala.util.Success

object PlaidSyncService:
  def syncTransactionsAndAccounts(itemId: UUID): Unit =
    val item = PlaidItemRepository.getItem(itemId).get

    supervised {
      fork {
        println("syncing transactions")
        val transactions = PlaidService.getTransactionsSync(accessToken = item.plaidAccessToken)

        transactions match
          case Failure(error) =>
            println(s"error syncing transactions: $error")
          case Success(response) =>
            println(s"transactions: $response")
            val accounts = response.getAccounts()

            supervised:
              for account <- accounts.asScala do
                println(s"account input: $account")
                fork:
                  val newAcct = AccountRepository.upsertAccount(
                    AccountRepository.CreateAccountInput(
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
                  )
                  println("inserted account")

            // val transactions = response.getTransactions()
            println(s"accounts: $accounts")
          // println(s"transactions: $transactions")

      }
    }
