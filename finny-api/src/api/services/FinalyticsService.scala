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
import api.repositories.GoalRepository.getAssignedBalanceOnRetirementGoal

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
      dbClient: DbClient.DataSource
  ): Either[AppError, Int] =
    val annualInterestRate = 0.08
    for
      profile <- ProfileRepository.getProfile(userId)
      fv <- getFreedomFutureValueOfCurrentExpenses(expCalc, userId)
      pv <- GoalRepository.getAssignedBalanceOnRetirementGoal(userId)
      pmt <- calculateActualSavingsThisMonth(userId)
      currentAge <- Right(profile.age.getOrElse(0))
    yield calculatePeriodFromFutureValue(fv, pv, pmt, annualInterestRate)

  end getActualRetirementAge

  /** Recalculates the actual savings and investments this month and persists
    * the value in the database
    */
  def recalculateActualSavingsAndInvestmentsThisMonth(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      value <- calculateActualSavingsThisMonth(userId)
      _ <- updateFinalytics(
        userId,
        FinalyticKeys.ActualSavingsAndInvestmentsThisMonth,
        value.toString()
      )
    yield value
  end recalculateActualSavingsAndInvestmentsThisMonth

  def recalculateTargetSavingsAndInvestmentsThisMonth(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      value <- calculateTargetSavingsAndInvestmentsThisMonth(userId)
      _ <- updateFinalytics(
        userId,
        FinalyticKeys.TargetSavingsAndInvestmentsThisMonth,
        value.toString()
      )
    yield value
  end recalculateTargetSavingsAndInvestmentsThisMonth

  def recalculateActualSavingsAtRetirement(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      value <- calculateActualSavingsAtRetirement(
        userId,
        ExpenseCalculation.Average
      )
      _ <- updateFinalytics(
        userId,
        FinalyticKeys.ActualSavingsAtRetirement,
        value.toString()
      )
    yield value
  end recalculateActualSavingsAtRetirement

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

  def calculateActualSavingsThisMonth(
      userId: UUID
  )(using dbClient: DbClient.DataSource): Either[AppError, Double] =
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
    .toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def calculateTargetSavingsAndInvestmentsThisMonth(userId: UUID)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      profile <- ProfileRepository.getProfile(userId)
      retirementGoalCurrentBalance <- GoalRepository
        .getAssignedBalanceOnRetirementGoal(userId)
      pv = -(retirementGoalCurrentBalance.abs)
      fv <- getFreedomFutureValueOfCurrentExpensesAtRetirement(
        ExpenseCalculation.Average,
        userId
      )
      years <- calculateYearsToRetirement(userId)
      yearlySavingsTarget = calculatePaymentFromFutureValue(
        pv = pv,
        fv = fv,
        rate = 0.08,
        years = years
      )
    yield yearlySavingsTarget / 12

  def calculateActualSavingsAtRetirement(
      userId: UUID,
      expCalc: ExpenseCalculation
  )(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      profile <- ProfileRepository.getProfile(userId)
      annualInterestRate = 0.08
      yearsToRetirement <- calculateYearsToRetirement(userId)
      retirementGoalCurrentBalance <- getAssignedBalanceOnRetirementGoal(userId)
      pv = -(retirementGoalCurrentBalance.abs)
      savings <- calculateActualSavingsThisMonth(userId)
      pmt = -(savings.abs)
    yield calculateFutureValue(
      rate = annualInterestRate,
      years = yearsToRetirement,
      pv = pv,
      pmt = pmt
    )

  def calculateExpectedSavingsAtRetirement(
      exp: ExpenseCalculation,
      userId: UUID
  )(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    for
      profile <- ProfileRepository.getProfile(userId)
      yearsToRetirement <- calculateYearsToRetirement(userId)
      freedomFVCurrentExpense <- getFreedomFutureValueOfCurrentExpenses(
        exp,
        userId
      )
      fv = freedomFVCurrentExpense.abs
      rate = 0.02 // 2% annual inflation rate
      pv = freedomFVCurrentExpense.abs
    yield calculateFutureValue(
      rate = rate,
      years = yearsToRetirement,
      pv = pv,
      pmt = 0
    )

  /** How much it costs to maintain the current lifestyle at retirement
    */
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

  private def getFreedomFutureValueOfCurrentExpensesAtRetirement(
      expCalc: ExpenseCalculation,
      userId: UUID
  )(using dbClient: DbClient.DataSource): Either[AppError, Double] =
    for
      profile <- ProfileRepository.getProfile(userId)
      freedomFutureValueOfCurrentExpenses <-
        getFreedomFutureValueOfCurrentExpenses(expCalc, userId)
      yearsToRetirement <- calculateYearsToRetirement(userId)
    yield calculateFutureValue(
      pv = freedomFutureValueOfCurrentExpenses,
      pmt = 0,
      rate = 0.02, // 2% annual inflation rate
      yearsToRetirement
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
                date_trunc('month', date) AS month,
                sum(
                  CASE WHEN amount < 0 THEN
                    abs(amount)
                  ELSE
                    0
                  END) AS monthly_inflows,
                sum(
                  CASE WHEN amount > 0 THEN
                    amount
                  ELSE
                    0
                  END) AS monthly_outflows
              FROM
                transactions
                JOIN accounts ON transactions.account_id = accounts.id
              WHERE
                date >= (CURRENT_DATE - INTERVAL '12 months')
                AND category NOT IN ('TRANSFER_IN', 'TRANSFER_OUT')
                AND accounts.user_id = $userId
              GROUP BY
                date_trunc('month', date)
            ),
            monthly_transfer_transactions AS (
              SELECT
                date_trunc('month', date) AS month,
                sum(
                  CASE WHEN category = 'TRANSFER_IN' THEN
                    amount
                  ELSE
                    - amount
                  END) AS net_transfer
              FROM
                transactions join accounts on transactions.account_id = accounts.id
              WHERE
                date >= (CURRENT_DATE - INTERVAL '12 months')
                AND category IN ('TRANSFER_IN', 'TRANSFER_OUT')
                AND accounts.user_id = $userId
              GROUP BY
                date_trunc('month', date)
            ),
            adjusted_monthly_totals AS (
              SELECT
                mrt.month,
                CASE WHEN coalesce(mtt.net_transfer, 0) > 0 THEN
                  mrt.monthly_inflows + coalesce(mtt.net_transfer, 0)
                ELSE
                  mrt.monthly_inflows
                END AS adjusted_inflows,
                CASE WHEN coalesce(mtt.net_transfer, 0) < 0 THEN
                  mrt.monthly_outflows - coalesce(mtt.net_transfer, 0)
                ELSE
                  mrt.monthly_outflows
                END AS adjusted_outflows
              FROM
                monthly_regular_transactions mrt
                LEFT JOIN monthly_transfer_transactions mtt ON mrt.month = mtt.month
            )
            SELECT
              avg(adjusted_inflows) AS inflows,
              avg(adjusted_outflows) AS outflows
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

  def calculateYearsToRetirement(userId: UUID)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Int] =
    for
      profile <- ProfileRepository.getProfile(userId)
      retirementAge <- profile.retirementAge.toRight(
        AppError.NotFoundError("Retirement age not found")
      )
      age <- profile.age.toRight(AppError.NotFoundError("Age not found"))
    yield retirementAge - age

  /** Calculates the future value of an investment with a given present value,
    * yearly investment, annual interest rate, and number of years.
    *
    * @param presentValue
    *   The initial amount of money.
    * @param yearlyInvestment
    *   The amount of money added to the investment each year.
    * @param annualInterestRate
    *   The annual interest rate as a decimal. Example: 0.08 for 8%
    * @param years
    *   The number of years the investment will grow.
    * @return
    *   The future value of the investment.
    */
  def calculateFutureValue(
      pv: Double,
      pmt: Double,
      rate: Double,
      years: Int
  ): Double =
    val futureValue = pv * math.pow(1 + rate, years) +
      pmt * ((math.pow(
        1 + rate,
        years
      ) - 1) / rate)

    if (pmt < 0 && pv < 0) then -futureValue
    else futureValue

  /** Calculates the payment from the future value of an investment.
    *
    * @param fv
    *   The future value of the investment.
    * @param pv
    *   The present value of the investment.
    * @param rate
    *   The annual interest rate as a decimal. Example: 0.08 for 8%
    * @param years
    *   The number of years the investment will grow.
    * @return
    */
  def calculatePaymentFromFutureValue(
      fv: Double,
      pv: Double,
      rate: Double,
      years: Int
  ): Double =
    // Calculate the payment using the future value formula for annual payments
    val payment =
      if (rate == 0) then
        // If interest rate is 0, use simple division
        (fv - pv) / years
      else
        (fv - pv * math.pow(1 + rate, years)) /
          ((math.pow(1 + rate, years) - 1) / rate)

    // Adjust the sign if both FV and PV are negative
    val adjustedPayment = if (fv < 0 && pv < 0) then -payment else payment

    // Round to 2 decimal places
    BigDecimal(adjustedPayment)
      .setScale(2, BigDecimal.RoundingMode.HALF_UP)
      .toDouble
