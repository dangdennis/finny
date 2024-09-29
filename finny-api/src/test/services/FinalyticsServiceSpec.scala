package test.services

import api.common.Environment.DatabaseConfig
import api.repositories.TransactionRepository
import org.scalatest.flatspec.AnyFlatSpec
import test.helpers.*

import java.util.UUID
import org.scalatest.matchers.should.Matchers
import org.scalatest.EitherValues
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import api.services.FinalyticsService

// To run this test, run `docker compose up` and then `make restore-prod-db`.
// This ensures we have a database with prod data.

class FinalyticsServiceSpec
    extends AnyFlatSpec,
      Matchers,
      EitherValues,
      BeforeAndAfterAll,
      BeforeAndAfterEach:

  override protected def beforeAll(): Unit =
    FinalyticsDatabase.init(
      DatabaseConfig(
        host = "jdbc:postgresql://localhost:5432/postgres",
        user = "postgres",
        password = "postgres"
      )
    )

  "We" should "be able to query transactions from the prod dump db" in:
    val transactions = TransactionRepository
      .getTransactionsByAccountId(
        UUID.fromString("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")
      )
      .value
    assert(transactions.length == 337)

  "calculateRetirementSavingsForCurrentMonth" should "return the correct retirement savings for the current month" in:
    // given
    // hardcoded to dennis user id because we use a dump of the prod database
    val userId = UUID.fromString("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")
    val result = FinalyticsService.calculateRetirementSavingsForCurrentMonth(userId)
    assert(result.isRight)
    assert(result.value == 1000.0)
