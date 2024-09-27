package test.handlers

import api.handlers.PowerSyncHandler
import api.repositories.GoalRepository
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import test.helpers.*

import java.util.UUID

class PowerSyncHandlerSpec
    extends AnyFlatSpec,
      Matchers,
      EitherValues,
      BeforeAndAfterAll,
      BeforeAndAfterEach:
  override protected def beforeAll(): Unit = TestHelper.beforeAll()
  override protected def afterEach(): Unit = TestHelper.afterEach()

  "handleEventUpload" should "handle PUT and DELETE goals ops" in {
    // given
    val user = AuthServiceHelper.createUser()
    val _ = PowerSyncHandler.handleEventUpload(
      """
            {
              "data": [
                {
                  "op_id": 1,
                  "op": "PUT",
                  "type": "goals",
                  "id": "f0a7a643-5582-4f64-b462-beb63ff12e60",
                  "tx_id": 1,
                  "data": {
                    "amount": 0.0,
                    "name": "Retirement Fund",
                    "target_date": "2059-07-23",
                    "goal_type": "retirement"
                  }
                }
              ]
            }

            """,
      user
    )

    val _ = GoalRepository
      .getGoal(UUID.fromString("f0a7a643-5582-4f64-b462-beb63ff12e60"), user.id)
      .value
      .get

    // when
    val _ = PowerSyncHandler.handleEventUpload(
      """
            {
              "data": [
                {
                  "op_id": 1,
                  "op": "DELETE",
                  "type": "goals",
                  "id": "f0a7a643-5582-4f64-b462-beb63ff12e60",
                  "tx_id": 1
                }
              ]
            }

            """,
      user
    )

    val goal = GoalRepository
      .getGoal(UUID.fromString("f0a7a643-5582-4f64-b462-beb63ff12e60"), user.id)
      .value
    goal should be(None)
  }
