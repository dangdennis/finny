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
import api.repositories.ProfileRepository
import api.repositories.GoalRepository
import scalikejdbc.DBSession

case class FinalyticsTable[T[_]](
    id: T[UUID],
    user_id: T[UUID],
    key: T[String],
    value: T[String]
)

object FinalyticsTable extends Table[FinalyticsTable]() {
  override def tableName: String = "finalytics"
}

enum ExpenseCalculation:
  case Last12Months, Average

object FinalyticsService:
  def getActualRetirementAge(userId: UserId, expCalc: ExpenseCalculation)(using
      dbClient: DbClient.DataSource,
      scalikejdc: DBSession
  ): Either[AppError, Int] =
    val annualInterestRate = 0.08
    for
      profile <- ProfileRepository.getProfile(userId)
      fv <- getFreedomFutureValueOfCurrentExpenses(expCalc, userId)
      pv <- GoalRepository.getAssignedBalanceOnRetirementGoal(userId)
      pmt <- calculateActualSavingsAndInvestmentsThisMonth(userId).toEither.left
        .map(e => AppError.DatabaseError(e.getMessage))
      currentAge <- Right(profile.age.getOrElse(0))
    yield calculatePeriodFromFutureValue(fv, pv, pmt, annualInterestRate)

  end getActualRetirementAge

  def recalculateActualSavingsAndInvestmentsThisMonth(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      value <- calculateActualSavingsAndInvestmentsThisMonth(
        userId
      ).toEither.left
        .map(e => AppError.DatabaseError(e.getMessage))
      _ <- updateFinalytics(
        userId,
        FinalyticKeys.ActualSavingsAndInvestmentsThisMonth,
        value.toString()
      )
    yield value
  end recalculateActualSavingsAndInvestmentsThisMonth

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
      .map(r => r.value)

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

  def calculateActualSavingsAndInvestmentsThisMonth(
      userId: UUID
  )(using dbClient: DbClient.DataSource): Try[Double] =
    Try:
      val result = dbClient.transaction: db =>
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
      result.headOption.getOrElse(0.0)

  private def getFreedomFutureValueOfCurrentExpenses(
      expCalc: ExpenseCalculation,
      userId: UUID
  )(using dbClient: DbClient.DataSource): Either[AppError, Double] =
    expCalc match
      case ExpenseCalculation.Last12Months =>
        getLast12MonthsInflowOutflow(userId)
      case ExpenseCalculation.Average =>
        getAverageMonthlyInflowOutflow(userId).map(
          _.outflow * 12 / 0.04 // 4% withdrawal rate
        )

  def getLast12MonthsInflowOutflow(userId: UUID)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    val result =
      Try:
        dbClient.transaction: db =>
          db.runSql[Double](sql"""
            WITH regular_transactions AS (
                SELECT
                    SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS total_inflows,
                    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_outflows
                FROM
                    transactions
                    JOIN accounts ON transactions.account_id = accounts.id
                WHERE
                    date >= (CURRENT_DATE - INTERVAL '12 months')
                    AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT')
                    AND accounts.user_id = $userId
            ),
            transfer_transactions AS (
                SELECT
                    SUM(CASE WHEN category = 'TRANSFER_IN' THEN amount ELSE -amount END) AS net_transfer
                FROM
                    transactions
                JOIN accounts on transactions.account_id = accounts.id
                WHERE
                    date >= (CURRENT_DATE - INTERVAL '12 months')
                    AND category IN ('TRANSFER_IN', 'TRANSFER_OUT')
                    AND accounts.user_id = $userId
            )
            SELECT
                CASE
                    WHEN tt.net_transfer > 0 THEN rt.total_inflows + tt.net_transfer
                    ELSE rt.total_inflows
                END AS adjusted_inflows,
                CASE
                    WHEN tt.net_transfer < 0 THEN rt.total_outflows - tt.net_transfer
                    ELSE rt.total_outflows
                END AS adjusted_outflows
                        FROM
                            regular_transactions rt, transfer_transactions tt;
          """)

    result.toEither.left
      .map(e => AppError.DatabaseError(e.getMessage))
      .map(rs => rs.headOption.getOrElse(0.0))

  case class AverageMonthlyInflowOutflow(
      inflow: Double,
      outflow: Double
  )

  def getAverageMonthlyInflowOutflow(userId: UUID)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, AverageMonthlyInflowOutflow] =
    val result =
      Try:
        dbClient.transaction: db =>
          db.runSql[(Double, Double)](sql"""
              WITH monthly_regular_transactions AS (
                SELECT
                  DATE_TRUNC('month', date) AS month,
                  SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS monthly_inflows,
                  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS monthly_outflows
                FROM
                  transactions
                  JOIN accounts ON transactions.account_id = accounts.id
                WHERE
                  date >= (CURRENT_DATE - INTERVAL '12 months')
                  AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT')
                GROUP BY
                  DATE_TRUNC('month', date)
              ),
              monthly_transfer_transactions AS (
                SELECT
                  DATE_TRUNC('month', date) AS month,
                  SUM(CASE WHEN category = 'TRANSFER_IN' THEN amount ELSE -amount END) AS net_transfer
                FROM
                  transactions
                WHERE
                  date >= (CURRENT_DATE - INTERVAL '12 months')
                  AND category IN ('TRANSFER_IN', 'TRANSFER_OUT')
                GROUP BY
                  DATE_TRUNC('month', date)
              ),
              adjusted_monthly_totals AS (
                SELECT
                  mrt.month,
                  CASE
                    WHEN COALESCE(mtt.net_transfer, 0) > 0 THEN mrt.monthly_inflows + COALESCE(mtt.net_transfer, 0)
                    ELSE mrt.monthly_inflows
                  END AS adjusted_inflows,
                  CASE
                    WHEN COALESCE(mtt.net_transfer, 0) < 0 THEN mrt.monthly_outflows - COALESCE(mtt.net_transfer, 0)
                    ELSE mrt.monthly_outflows
                  END AS adjusted_outflows
                FROM
                  monthly_regular_transactions mrt
                  LEFT JOIN monthly_transfer_transactions mtt ON mrt.month = mtt.month
              )
              SELECT
                AVG(adjusted_inflows) AS inflows,
                AVG(adjusted_outflows) AS outflows
              FROM
                adjusted_monthly_totals;            
          """)

    result.toEither.left
      .map(e => AppError.DatabaseError(e.getMessage))
      .map(rs =>
        rs.headOption
          .map { case (inflow, outflow) =>
            AverageMonthlyInflowOutflow(inflow, outflow)
          }
          .getOrElse(AverageMonthlyInflowOutflow(0.0, 0.0))
      )

  def calculatePeriodFromFutureValue(
      fv: Double,
      pv: Double,
      payment: Double,
      annualInterestRate: Double
  ): Int =
    if (annualInterestRate == 0) then
      // If interest rate is 0, use simple division
      ((fv - pv) / payment).round.toInt
    else
      val absFv = fv.abs
      val absPv = pv.abs
      val absPayment = payment.abs

      val n = math.log(
        (absFv * annualInterestRate + absPayment) /
          (absPv * annualInterestRate + absPayment)
      ) /
        math.log(1 + annualInterestRate)

      n.round.toInt
