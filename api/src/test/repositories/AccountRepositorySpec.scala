package test.repositories

import api.models.PlaidItemStatus
import api.repositories.AccountRepository
import api.repositories.AccountRepository.UpsertAccountInput
import api.repositories.PlaidItemRepository
import api.repositories.PlaidItemRepository.CreateItemInput
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import test.helpers.*

class AccountRepositorySpec extends AnyFlatSpec, Matchers, EitherValues, BeforeAndAfterAll, BeforeAndAfterEach:
    override protected def beforeAll(): Unit = TestHelper.beforeAll()

    override protected def afterEach(): Unit = TestHelper.afterEach()

    "upsertAccount" should "upsert accounts" in {
        // given
        val user = AuthServiceHelper.createUser()
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
