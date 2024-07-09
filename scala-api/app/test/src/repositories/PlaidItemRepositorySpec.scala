package test.repositories

import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import org.scalatest.BeforeAndAfterAll
import app.repositories.PlaidItemRepository
import app.repositories.PlaidItemRepository.CreateItemInput
import app.models.PlaidItemStatus
import test.helpers.*
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues

class PlaidItemRepositorySpec extends AnyFlatSpec with Matchers with EitherValues with BeforeAndAfterAll with BeforeAndAfterEach:
  override protected def beforeAll(): Unit =
    TestHelper.beforeAll()

  override protected def beforeEach(): Unit =
    TestHelper.beforeEach()

  "updateSyncSuccess" should "update item sync success time" in {
    // given
    val user = AuthUserRepositoryHelper.createUser()
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
      .value
    val currentTime = java.time.Instant.now()

    // when
    PlaidItemRepository.updateSyncSuccess(item.id, currentTime = currentTime)

    // then
    val updatedItem = PlaidItemRepository.getById(id = item.id).get
    updatedItem.lastSyncedAt should be(Some(currentTime))
    updatedItem.lastSyncError should be(None)
    updatedItem.lastSyncErrorAt should be(None)
    updatedItem.retryCount should be(0)
  }

  "updateSyncError" should "update item sync error columns" in {
    // given
    val user = AuthUserRepositoryHelper.createUser()
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
      .value
    val currentTime = java.time.Instant.now()
    val error = "got an error from plaid"

    // when
    PlaidItemRepository.updateSyncError(item.id, error = error, currentTime = currentTime)

    // then
    val updatedItem = PlaidItemRepository.getById(id = item.id).get
    updatedItem.lastSyncedAt should be(None)
    updatedItem.lastSyncError should be(Some(error))
    updatedItem.lastSyncErrorAt should be(Some(currentTime))
    updatedItem.retryCount should be(1)
  }
