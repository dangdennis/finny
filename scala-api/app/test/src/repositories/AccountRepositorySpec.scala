package test.repositories

import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import app.repositories.AccountRepository
import app.repositories.AccountRepository.UpsertAccountInput
import org.scalatest.BeforeAndAfterAll
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.models.PlaidItemStatus
import test.helpers._
import org.scalatest.BeforeAndAfterEach

class AccountRepositorySpec extends AnyFlatSpec with Matchers with BeforeAndAfterAll with BeforeAndAfterEach:
  override protected def beforeAll(): Unit =
    TestHelper.beforeAll()

  override protected def beforeEach(): Unit =
    TestHelper.beforeEach()

  it should "upsert accounts" in {
    // given
    val user = UserRepositoryHelper.createUser()
    val item = PlaidItemRepository
      .createItem(
        CreateItemInput(
          userId = user.id,
          plaidAccessToken = "somePlaid",
          plaidInstitutionId = "institutionId",
          plaidItemId = "somePlaidItemId",
          status = PlaidItemStatus.Bad,
          transactionsCursor = None
        )
      )
      .get

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

    AccountRepository.upsertAccount(
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

    // then
    val accounts = AccountRepository.getAccounts(userId = user.id).get
    accounts.size should be(1)
    accounts.head.availableBalance should be(200.0)
    accounts.head.currentBalance should be(150.0)
  }
