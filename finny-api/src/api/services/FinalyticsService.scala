package api.services

import api.common.*
import scalasql.*
import scalasql.core.*
import scalasql.core.SqlStr.*

import java.util.UUID
import scala.util.Try

import PostgresDialect.*
import api.models.UserId
import api.models.FinalyticKeys

case class FinalyticsTable[T[_]](
    id: T[UUID],
    user_id: T[UUID],
    key: T[String],
    value: T[String]
)

object FinalyticsTable extends Table[FinalyticsTable]() {
  override def tableName: String = "finalytics"
}

object FinalyticsService:
  def getActualRetirementAge(): Either[Throwable, Int] =
    Right(67)

  def getActualSavingsAndInvestmentsThisMonth(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    getFinalytics(userId, FinalyticKeys.ActualSavingsAndInvestmentsThisMonth)
      .map(value => value.toDouble)

  def recalculateActualSavingsAndInvestmentsThisMonth(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      value <- calculateActualSavingsAndInvestmentsThisMonth(userId)
      _ <- updateFinalytics(
        userId,
        FinalyticKeys.ActualSavingsAndInvestmentsThisMonth,
        value.toString()
      )
    yield value

  def getFinalytics(userId: UserId, key: FinalyticKeys)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, String] =
    val query = FinalyticsTable.select
      .filter(r =>
        r.user_id === UserId.toUUID(userId) && r.key === key.toString()
      )
      .single

    val result = Try:
      dbClient.transaction: db =>
        db.run(query)

    result.toEither.left
      .map(e => AppError.DatabaseError(e.getMessage))
      .map(rows => rows.value)

  def updateFinalytics(
      userId: UserId,
      key: FinalyticKeys,
      value: String
  )(using dbClient: DbClient.DataSource): Either[AppError, Int] =
    val query = FinalyticsTable.insert
      .columns(
        _.user_id := UserId.toUUID(userId),
        _.key := key.toString(),
        _.value := value
      )
      .onConflictUpdate(_.user_id, _.key)(_.value := value)

    val result = Try:
      dbClient.transaction: db =>
        db.run(query)

    result.toEither.left
      .map(e => AppError.DatabaseError(e.getMessage))
      .map(rows => rows)

  private def calculateActualSavingsAndInvestmentsThisMonth(
      userId: UUID
  )(using dbClient: DbClient.DataSource): Either[AppError, Double] =
    val result =
      Try:
        dbClient.transaction: db =>
          db.runSql[Double](sql"""
            WITH retirement_goal AS (
              SELECT id
              FROM goals
              WHERE goals.goal_type = 'retirement' AND goals.user_id = $userId
              LIMIT 1
            ),
            assigned_accounts AS (
              SELECT account_id
              FROM goal_accounts
              JOIN retirement_goal ON retirement_goal.id = goal_accounts.goal_id
            ),
            start_of_month_balances AS (
              -- Get the earliest balance in the current month for each account
              SELECT DISTINCT ON (ab.account_id)
                ab.account_id,
                ab.balance_date AS start_balance_date,
                ab.current_balance AS start_balance
              FROM account_balances ab
              WHERE ab.balance_date >= date_trunc('month', CURRENT_DATE)
                AND ab.account_id IN (SELECT account_id FROM assigned_accounts)
              ORDER BY ab.account_id, ab.balance_date
            ),
            most_recent_balances AS (
              -- Get the most recent balance for each account
              SELECT DISTINCT ON (ab.account_id)
                ab.account_id,
                ab.balance_date AS most_recent_balance_date,
                ab.current_balance AS most_recent_balance
              FROM account_balances ab
              WHERE ab.account_id IN (SELECT account_id FROM assigned_accounts)
              ORDER BY ab.account_id, ab.balance_date DESC
            )
            SELECT
              SUM(mr.most_recent_balance - som.start_balance) AS net_balance_change
            FROM most_recent_balances mr
            JOIN start_of_month_balances som ON mr.account_id = som.account_id
            JOIN accounts ON mr.account_id = accounts.id
            WHERE mr.most_recent_balance_date >= som.start_balance_date
          """)

    result.toEither.left
      .map(e => AppError.DatabaseError(e.getMessage))
      .map(rs => rs.headOption.getOrElse(0.0))

  enum ExpenseCalculation:
    case Last12Months, Average

  private def getFreedomFutureValueOfCurrentExpenses(
      expCalc: ExpenseCalculation
  ) =
    ()
