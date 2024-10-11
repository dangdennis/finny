package test.services

import api.common.Environment
import api.common.Environment.DatabaseConfig
import api.database.DatabaseJdbc
import api.database.DatabaseScalaSql
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import scalasql.*
import scalikejdbc.DBSession

// To run this test, run `docker compose up` and then `make restore-prod-db`.
// This ensures we have a database with prod data.

class FinalyticsServiceSpec
    extends AnyFlatSpec,
      Matchers,
      EitherValues,
      BeforeAndAfterAll,
      BeforeAndAfterEach:

  var dbClient: Option[DbClient.DataSource] = None
  given DbClient.DataSource = dbClient.getOrElse(
    throw new IllegalStateException("DB Client not initialized")
  )

  var scalikejdbc: Option[DBSession] = None
  given DBSession = scalikejdbc.getOrElse(
    throw new IllegalStateException("Scalikejdbc not initialized")
  )

  override protected def beforeAll(): Unit = {
    dbClient = Some(
      DatabaseScalaSql
        .init(
          DatabaseConfig(
            host = "jdbc:postgresql://localhost:5432/postgres",
            user = "postgres",
            password = "postgres"
          )
        )
        .value
    )

    DatabaseJdbc
      .init(
        Environment.DatabaseConfig(
          host = "jdbc:postgresql://localhost:5432/postgres",
          user = "postgres",
          password = "postgres"
        )
      )
  }

  // "recalculateActualSavingsAndInvestmentsThisMonth" should "persist the retirement savings for the current month" in:
  //   val userId = UUID.fromString("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")
  //   val accountId = UUID.fromString("495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9")
  //   val result =
  //     FinalyticsService.recalculateActualSavingsAndInvestmentsThisMonth(userId)
  //   assert(result.isRight)
  //   assert(result.value == -7238.82)
  //   val result2 = FinalyticsService.getFinalytics(
  //     userId,
  //     FinalyticKeys.ActualSavingsAndInvestmentsThisMonth
  //   )
  //   assert(result2.value == "-7238.82")

  // "getActualRetirementAge" should "return the actual retirement age" in:
  //   val userId = UUID.fromString("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")
  //   val result = FinalyticsService.getActualRetirementAge(
  //     userId,
  //     ExpenseCalculation.Last12Months
  //   )
  //   assert(result.isRight)
  //   assert(result.value == 65)

  // "updateFinalytics" should "update the finalytics table" in:
  //   val userId = UUID.fromString("5eaa8ae7-dbcb-445e-8058-dbd51a912c8d")
  //   val value = 1000.00
  //   val result = FinalyticsService.updateFinalytics(
  //     userId,
  //     FinalyticKeys.ActualSavingsAndInvestmentsThisMonth,
  //     value.toString()
  //   )
  //   println(result)
  //   assert(result.value == 1)

  //   val result2 = FinalyticsService.getFinalytics(
  //     userId,
  //     FinalyticKeys.ActualSavingsAndInvestmentsThisMonth
  //   )
  //   println(result2)
  //   assert(result2.value == value.toString())
