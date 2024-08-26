package test.services

import api.models.PlaidItemStatus
import api.repositories.AccountRepository
import api.repositories.AccountRepository.UpsertAccountInput
import api.repositories.GoalRepository
import api.repositories.PlaidItemRepository
import api.repositories.PlaidItemRepository.CreateItemInput
import api.repositories.TransactionRepository
import api.repositories.TransactionRepository.UpsertTransactionInput
import api.services.UserDeletionService
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import repositories.AuthUserRepository
import test.helpers.*

import java.util.UUID
import api.models.GoalType

class UserDeletionServiceSpec extends AnyFlatSpec, Matchers, EitherValues, BeforeAndAfterAll, BeforeAndAfterEach:
    override protected def beforeAll(): Unit = TestHelper.beforeAll()
    override protected def afterEach(): Unit = TestHelper.afterEach()

    "deleteUserEverything" should
        "delete all user data, including transaction, accounts, plaid items, goals, assets, profile, auth.user" in:
            // given
            val user =
                AuthServiceHelper.createUserViaSupabaseAuth(email = "dennis@gmail.com", password = "password").value
            val userId = UUID.fromString(user.id)
            val item =
                PlaidItemRepository
                    .getOrCreateItem(
                        CreateItemInput(
                            userId = userId,
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
                            itemId = item.id.toUUID,
                            userId = userId,
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
                    .value
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
            val goalId = UUID.randomUUID()
            val goal =
                GoalRepository
                    .createGoal(
                        GoalRepository.CreateGoalInput(
                            id = goalId,
                            userId = userId,
                            name = "Retirement Fund",
                            amount = 0.0,
                            targetDate = java.time.Instant.now(),
                            goalType = GoalType.Retirement
                        )
                    )
                    .value

            val items = PlaidItemRepository.debugGetItems().value
            items should have size 1
            val accounts = AccountRepository.getAccounts(userId = userId).value
            accounts should have size 1
            val transactions = TransactionRepository.getTransactionsByAccountId(accountId).value
            transactions should have size 1
            val identities = AuthUserRepository.getIdentities(userId).value
            identities should have size 1
            val goals = GoalRepository.getGoalsByUserId(userId).value
            goals should have size 1

            val k = UserDeletionService.deleteUserEverything(userId)

            val itemsAfterDeletion = PlaidItemRepository.debugGetItems().value
            itemsAfterDeletion should have size 0
            val accountsAfterDeletion = AccountRepository.getAccounts(userId = userId).value
            accountsAfterDeletion should have size 0
            val transactionsAfterDeletion = TransactionRepository.getTransactionsByAccountId(accountId).value
            transactionsAfterDeletion should have size 0
            val identitiesAfterDeletion = AuthUserRepository.getIdentities(userId).value
            identitiesAfterDeletion should have size 0
            val goalsAfterDeletion = GoalRepository.getGoalsByUserId(goalId).value
            goalsAfterDeletion should have size 0

            val deletedUser = AuthUserRepository.getUser(userId).value
            deletedUser should be(None)
