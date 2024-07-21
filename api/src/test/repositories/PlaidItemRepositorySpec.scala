package test.repositories

import api.common.Time
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import org.scalatest.BeforeAndAfterAll
import api.repositories.PlaidItemRepository
import api.repositories.PlaidItemRepository.CreateItemInput
import api.models.PlaidItemStatus
import test.helpers.*
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import scalikejdbc.DB

import scala.util.Try
import api.repositories.AccountRepository
import api.repositories.AccountRepository.UpsertAccountInput
import api.repositories.TransactionRepository
import api.repositories.TransactionRepository.UpsertTransactionInput

class PlaidItemRepositorySpec extends AnyFlatSpec, Matchers, EitherValues, BeforeAndAfterAll, BeforeAndAfterEach:
    override protected def beforeAll(): Unit = TestHelper.beforeAll()

    override protected def afterEach(): Unit = TestHelper.afterEach()

    "updateSyncSuccess" should "update item sync success time" in {
        // given
        val user = AuthUserRepositoryHelper.createUser()
        val item =
            PlaidItemRepository
                .getOrCreateItem(
                    CreateItemInput(
                        userId = user.id,
                        plaidAccessToken = "somePlaid",
                        plaidInstitutionId = "institutionId",
                        plaidItemId = "somePlaidItemId",
                        status = PlaidItemStatus.Bad,
                        transactionsCursor = None
                    )
                )
                .value
        val currentTime = Time.now()

        // when
        PlaidItemRepository.updateSyncSuccess(item.id, currentTime = currentTime)

        // then
        val updatedItem = PlaidItemRepository.getById(id = item.id).value
        updatedItem.lastSyncedAt should be(Some(currentTime))
        updatedItem.lastSyncError should be(None)
        updatedItem.lastSyncErrorAt should be(None)
        updatedItem.retryCount should be(0)
    }

    "updateSyncError" should "update item sync error columns" in {
        // given
        val user = AuthUserRepositoryHelper.createUser()
        val item =
            PlaidItemRepository
                .getOrCreateItem(
                    CreateItemInput(
                        userId = user.id,
                        plaidAccessToken = "somePlaid",
                        plaidInstitutionId = "institutionId",
                        plaidItemId = "somePlaidItemId",
                        status = PlaidItemStatus.Bad,
                        transactionsCursor = None
                    )
                )
                .value
        val currentTime = Time.now()
        val error = "got an error from plaid"

        // when
        PlaidItemRepository.updateSyncError(item.id, error = error, currentTime = currentTime)

        // then
        val updatedItem = PlaidItemRepository.getById(id = item.id).value
        updatedItem.lastSyncedAt should be(None)
        updatedItem.lastSyncError should be(Some(error))
        updatedItem.lastSyncErrorAt should be(Some(currentTime))
        updatedItem.retryCount should be(1)
    }

    "getItemsPendingSync" should "only return items that need to be synced" in {
        // given
        val user = AuthUserRepositoryHelper.createUser()
        val item1 =
            PlaidItemRepository
                .getOrCreateItem(
                    CreateItemInput(
                        userId = user.id,
                        plaidAccessToken = "somePlaid1",
                        plaidInstitutionId = "institutionId",
                        plaidItemId = "somePlaidItemId1",
                        status = PlaidItemStatus.Good,
                        transactionsCursor = None
                    )
                )
                .value
        val item2 =
            PlaidItemRepository
                .getOrCreateItem(
                    CreateItemInput(
                        userId = user.id,
                        plaidAccessToken = "somePlaid2",
                        plaidInstitutionId = "institutionId",
                        plaidItemId = "somePlaidItemId2",
                        status = PlaidItemStatus.Good,
                        transactionsCursor = None
                    )
                )
                .value
        val item3 =
            PlaidItemRepository
                .getOrCreateItem(
                    CreateItemInput(
                        userId = user.id,
                        plaidAccessToken = "somePlaid",
                        plaidInstitutionId = "institutionId",
                        plaidItemId = "somePlaidItemId3",
                        status = PlaidItemStatus.Good,
                        transactionsCursor = None
                    )
                )
                .value

        val currentTime = java.time.Instant.now()

        // alter last_synced_at times on items
        // should be fetched
        val lastSyncedExactly12HoursAgo = currentTime.minus(java.time.Duration.ofHours(12))
        PlaidItemRepository.updateSyncSuccess(item1.id, currentTime = lastSyncedExactly12HoursAgo)

        // should not be fetched
        val lastSyncedLess12HoursBy1Sec = currentTime
            .minus(java.time.Duration.ofHours(12))
            .plus(java.time.Duration.ofSeconds(1))
        PlaidItemRepository.updateSyncSuccess(item2.id, currentTime = lastSyncedLess12HoursBy1Sec)

        // should be fetched
        val lastSyncedGreater12HoursBy1Sec = currentTime
            .minus(java.time.Duration.ofHours(12))
            .minus(java.time.Duration.ofSeconds(1))
        PlaidItemRepository.updateSyncError(item3.id, currentTime = lastSyncedGreater12HoursBy1Sec, error = "error")

        // when
        val items = PlaidItemRepository.getItemsPendingSync(now = currentTime).get

        // then
        items.size should be(2)
    }

    "deleteItemById" should "delete plaid item as well as associated accounts and transactions in db transaction" in:
        // given
        val user = AuthUserRepositoryHelper.createUser()
        val item =
            PlaidItemRepository
                .getOrCreateItem(
                    CreateItemInput(
                        userId = user.id,
                        plaidAccessToken = "somePlaid",
                        plaidInstitutionId = "institutionId",
                        plaidItemId = "somePlaidItemId",
                        status = PlaidItemStatus.Bad,
                        transactionsCursor = None
                    )
                )
                .value
        val accountId =
            AccountRepository
                .upsertAccount(
                    UpsertAccountInput(
                        itemId = item.id,
                        userId = user.id,
                        accountSubtype = Some("checking"),
                        accountType = Some("depository"),
                        availableBalance = 100.0,
                        currentBalance = 100.0,
                        isoCurrencyCode = Some("USD"),
                        mask = Some("1234"),
                        name = "Alice",
                        officialName = Some("Alice's Checking"),
                        plaidAccountId = "somePlaidAccountId",
                        unofficialCurrencyCode = Some("USD")
                    )
                )
                .get
        val transaction = TransactionRepository.upsertTransaction(input =
            UpsertTransactionInput(
                accountId = accountId,
                plaidTransactionId = "somePlaidTransactionId2",
                category = Some("someOtherCategory"),
                subcategory = Some("someOtherSubcategory"),
                transactionType = "someType",
                name = "someName",
                amount = 100.0,
                isoCurrencyCode = Some("USD"),
                unofficialCurrencyCode = Some("USD"),
                date = java.time.Instant.now(),
                pending = false,
                accountOwner = Some("Dennis")
            )
        )

        val items = PlaidItemRepository.getItemsDebug().value
        items should have size 1
        val accounts = AccountRepository.getAccounts(userId = user.id).get
        accounts should have size 1
        val transactions = TransactionRepository.getTransactionsByAccountId(accountId).get
        transactions should have size 1

        // test rollback on exception
        val res = Try(
            DB localTx { implicit session =>
                PlaidItemRepository.deleteItemById(item.id)
                throw new Exception("rollback")
            }
        )

        val itemsAfterException = PlaidItemRepository.getItemsDebug().value
        itemsAfterException should have size 1
        val accountsAfterException = AccountRepository.getAccounts(userId = user.id).get
        accountsAfterException should have size 1
        val transactionsAfterException = TransactionRepository.getTransactionsByAccountId(accountId).get
        transactionsAfterException should have size 1

        // delete the item and associated accounts and transactions
        DB localTx { implicit session =>
            PlaidItemRepository.deleteItemById(item.id)
        }

        val itemsAfterDeletion = PlaidItemRepository.getItemsDebug().value
        itemsAfterDeletion should have size 0
        val accountsAfterDeletion = AccountRepository.getAccounts(userId = user.id).get
        accountsAfterDeletion should have size 0
        val transactionsAfterDeletion = TransactionRepository.getTransactionsByAccountId(accountId).get
        transactionsAfterDeletion should have size 0
