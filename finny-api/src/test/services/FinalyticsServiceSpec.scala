package test.services

import api.common.Environment.DatabaseConfig
import api.repositories.TransactionRepository
import org.scalatest.flatspec.AnyFlatSpec
import java.util.UUID
import org.scalatest.matchers.should.Matchers
import org.scalatest.EitherValues
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import api.services.FinalyticsService
import api.database.DatabaseScalaSql
import scalasql.*, PostgresDialect.*
import scalasql.core.*
import scalasql.core.SqlStr.*
import scalasql.core.DbClient.DataSource

// To run this test, run `docker compose up` and then `make restore-prod-db`.
// This ensures we have a database with prod data.

class FinalyticsServiceSpec
    extends AnyFlatSpec,
      Matchers,
      EitherValues,
      BeforeAndAfterAll,
      BeforeAndAfterEach:

  var dbClient: DataSource = scala.compiletime.uninitialized
  given DataSource = dbClient

  override protected def beforeAll(): Unit = {
    dbClient = DatabaseScalaSql
      .init(
        DatabaseConfig(
          host = "jdbc:postgresql://localhost:5432/postgres",
          user = "postgres",
          password = "postgres"
        )
      )
      .value
  }

  "Using scalasql" should "be able to query transactions from the prod dump db" in:
    val userId = UUID.fromString("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")
    val accountId = UUID.fromString("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")

    val results = dbClient.transaction: db =>
      db.runSql[Double](
        sql"""select count(*) from transactions where account_id = ${accountId}"""
      )

    assert(results(0) == 337)

  "calculateRetirementSavingsForCurrentMonth" should "return the correct retirement savings for the current month" in:

    val userId = UUID.fromString("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")
    val result =
      FinalyticsService
        .calculateRetirementSavingsForCurrentMonth(userId)
    assert(result.isRight)
    assert(result.value == -7238.82)
