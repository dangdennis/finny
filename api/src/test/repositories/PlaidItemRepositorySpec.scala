package test.repositories

import api.common.Time
import api.models.PlaidItemStatus
import api.repositories.PlaidItemRepository
import api.repositories.PlaidItemRepository.CreateItemInput
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import test.helpers.*

class PlaidItemRepositorySpec extends AnyFlatSpec, Matchers, EitherValues, BeforeAndAfterAll, BeforeAndAfterEach:
    override protected def beforeAll(): Unit = TestHelper.beforeAll()

    override protected def afterEach(): Unit = TestHelper.afterEach()

    "updateSyncSuccess" should "update item sync success time" in {
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
        val user = AuthServiceHelper.createUser()
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
