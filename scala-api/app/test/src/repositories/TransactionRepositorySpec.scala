package test.repositories

import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import app.repositories.AccountRepository
import app.repositories.AccountRepository.UpsertAccountInput
import org.scalatest.BeforeAndAfterAll
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.models.PlaidItemStatus
import app.models.Transaction
import test.helpers.*
import scalikejdbc.*
import app.repositories.TransactionRepository
import app.repositories.TransactionRepository.UpsertTransactionInput
import org.scalatest.BeforeAndAfterEach

class TransactionRepositorySpec extends AnyFlatSpec with Matchers with EitherValues with BeforeAndAfterAll with BeforeAndAfterEach:
  override protected def beforeAll(): Unit =
    TestHelper.beforeAll()

  override protected def beforeEach(): Unit =
    TestHelper.beforeEach()

  "upsertTransaction" should "upsert transactions" in {
    // given
    val user = AuthUserRepositoryHelper.createUser()
    val item = PlaidItemRepository
      .getOrCreateItem(
        CreateItemInput(
          userId = user.id,
          plaidAccessToken = "somePlaid",
          plaidInstitutionId = "institutionId",
          plaidItemId = "somePlaidItemId",
          status = PlaidItemStatus.Bad,
          transactionsCursor = None
        )
      ).value

    // when
    AccountRepository.upsertAccount(
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

    val accountId = AccountRepository
      .upsertAccount(
        UpsertAccountInput(
          itemId = item.id,
          userId = user.id,
          accountSubtype = Some("checking"),
          accountType = Some("depository"),
          availableBalance = 200.0,
          currentBalance = 150.0,
          isoCurrencyCode = Some("USD"),
          mask = Some("1234"),
          name = "Alice",
          officialName = Some("Alice's Checking"),
          plaidAccountId = "somePlaidAccountId",
          unofficialCurrencyCode = Some("USD")
        )
      )
      .get

    TransactionRepository.upsertTransaction(
      input = UpsertTransactionInput(
        accountId = accountId,
        plaidTransactionId = "somePlaidTransactionId",
        category = Some("someCategory"),
        subcategory = Some("someSubcategory"),
        transactionType = "someType",
        name = "someName",
        amount = 50.0,
        isoCurrencyCode = Some("USD"),
        unofficialCurrencyCode = Some("USD"),
        date = java.time.Instant.now(),
        pending = true,
        accountOwner = Some("Alice")
      )
    )

    TransactionRepository.upsertTransaction(
      input = UpsertTransactionInput(
        accountId = accountId,
        plaidTransactionId = "somePlaidTransactionId",
        category = Some("someOtherCategory"),
        subcategory = Some("someOtherSubcategory"),
        transactionType = "someType",
        name = "someName",
        amount = 55.0,
        isoCurrencyCode = Some("USD"),
        unofficialCurrencyCode = Some("USD"),
        date = java.time.Instant.now(),
        pending = false,
        accountOwner = Some("Alice")
      )
    )

    TransactionRepository.upsertTransaction(
      input = UpsertTransactionInput(
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

    // then
    val transactions = DB.readOnly { implicit session =>
      sql"SELECT * FROM transactions"
        .map(TransactionRepository.toModel)
        .list
        .apply()
    }

    transactions.size should be(2)

    val transaction = transactions.head
    transaction.accountId should be(accountId)
    transaction.plaidTransactionId should be("somePlaidTransactionId")
    transaction.category should be(Some("someOtherCategory"))
    transaction.subcategory should be(Some("someOtherSubcategory"))
    transaction.transactionType should be("someType")
    transaction.name should be("someName")
    transaction.amount should be(55.0)
    transaction.isoCurrencyCode should be(Some("USD"))
    transaction.unofficialCurrencyCode should be(Some("USD"))
    transaction.pending should be(false)
    transaction.accountOwner should be(Some("Alice"))

    TransactionRepository.delete(List(transaction.plaidTransactionId))

    val transactionsAfterDelete = DB.readOnly { implicit session =>
      sql"SELECT * FROM transactions"
        .map(TransactionRepository.toModel)
        .list
        .apply()
    }

    transactionsAfterDelete.size should be(1)

    val transactionAfterDelete = transactionsAfterDelete.head
    transactionAfterDelete.plaidTransactionId should be("somePlaidTransactionId2")

    PlaidItemRepository.updateTransactionCursor(item.id, Some("someCursor"))
    val updatedItem = PlaidItemRepository.getById(item.id).get
    updatedItem.transactionsCursor should be(Some("someCursor"))
  }
