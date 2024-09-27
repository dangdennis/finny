package api.services

import scalikejdbc.*
import api.common.*
import java.util.UUID
import scala.util.Try

object FinalyticService:
  def calculateRetirementSavingsForCurrentMonth(
      userId: UUID
  ): Either[AppError, Double] =
    val result = Try:
      DB.readOnly:
        implicit session =>
          sql"${retirementSavingsQuery(userId)}"
            .map(rs => rs.double("net_balance_change"))
            .single
            .apply()
            .get

    result.toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  private def retirementSavingsQuery(userId: UUID): SQL[Nothing, NoExtractor] =
    sql"""
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
    """
