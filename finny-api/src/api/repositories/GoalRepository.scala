package api.repositories

import api.common.AppError
import api.models.Goal
import api.models.GoalType
import api.models.UserId
import scalikejdbc.*

import java.time.Instant
import java.util.UUID
import scala.util.Try
import scalasql.core.*
import scalasql.*
import scalasql.PostgresDialect.*
import scala.util.{Failure, Success}
import api.models.GoalAccount
import api.models.AssignedAmount
import api.repositories.AccountRepository2.MinimalAccountBalance

case class GoalTable[T[_]](
    id: T[UUID],
    name: T[String],
    amount: T[Double],
    target_date: T[Instant],
    user_id: T[UUID],
    progress: T[Double],
    goal_type: T[String]
)

object GoalTable extends Table[GoalTable]() {
  override def tableName: String = "goals"
}

case class GoalAccountTable[T[_]](
    id: T[UUID],
    goal_id: T[UUID],
    account_id: T[UUID],
    amount: T[Double],
    percentage: T[Double]
)

object GoalAccountTable extends Table[GoalAccountTable]() {
  override def tableName: String = "goal_accounts"
}
object GoalRepository:
  def getGoal(
      id: UUID,
      userId: UserId
  ): Either[AppError.DatabaseError, Option[Goal]] = Try(
    DB readOnly { implicit session =>
      sql"""select * from goals where id = ${id} and user_id = ${userId}"""
        .map(rs =>
          Goal(
            id = UUID.fromString(rs.string("id")),
            name = rs.string("name"),
            amount = rs.double("amount"),
            targetDate = rs.timestamp("target_date").toInstant,
            userId = UserId(UUID.fromString(rs.string("user_id"))),
            goalType = GoalType.fromString(rs.string("goal_type")).get,
            progress = rs.double("progress"),
            assignedAccounts = List()
          )
        )
        .single
        .apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def getGoalsByUserId(
      userId: UserId
  ): Either[AppError.DatabaseError, List[Goal]] = Try(
    DB readOnly { implicit session =>
      sql"""select * from goals where user_id = ${userId}"""
        .map(rs =>
          Goal(
            id = UUID.fromString(rs.string("id")),
            name = rs.string("name"),
            amount = rs.double("amount"),
            targetDate = rs.timestamp("target_date").toInstant,
            userId = UserId(UUID.fromString(rs.string("user_id"))),
            goalType = GoalType.fromString(rs.string("goal_type")).get,
            progress = rs.double("progress"),
            assignedAccounts = List()
          )
        )
        .list
        .apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  case class CreateGoalInput(
      id: UUID,
      userId: UserId,
      name: String,
      amount: Double,
      targetDate: Instant,
      goalType: GoalType
  )

  def createGoal(input: CreateGoalInput): Either[AppError.DatabaseError, Goal] =
    Try(
      DB autoCommit { implicit session =>
        sql"""insert into goals (id, user_id, name, amount, target_date, goal_type)
                    values (${input.id}, ${input.userId}, ${input.name}, ${input.amount}, ${input.targetDate}, ${input.goalType.value})
                    returning id, name, amount, target_date, user_id, progress, goal_type, created_at, updated_at, deleted_at
                  """
          .map(rs =>
            Goal(
              id = UUID.fromString(rs.string("id")),
              name = rs.string("name"),
              amount = rs.double("amount"),
              targetDate = rs.timestamp("target_date").toInstant,
              userId = UserId(UUID.fromString(rs.string("user_id"))),
              goalType = GoalType.fromString(rs.string("goal_type")).get,
              progress = rs.double("progress"),
              assignedAccounts = List()
            )
          )
          .single
          .apply()
      }
    ).map(g => g.get)
      .toEither
      .left
      .map(e => AppError.DatabaseError(e.getMessage))

  def deleteGoal(
      id: UUID,
      userId: UserId
  ): Either[AppError.DatabaseError, Int] = Try(
    DB autoCommit { implicit session =>
      sql"""delete from goals where id = ${id} and user_id = ${userId}""".update
        .apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def updateGoal(
      id: UUID,
      name: Option[String],
      amount: Option[Double],
      targetDate: Option[Instant],
      goalType: Option[GoalType],
      userId: UUID
  ): Either[AppError.DatabaseError, Int] = Try {
    DB autoCommit { implicit session =>
      val setClause = Seq(
        name.map(n => sqls"name = ${n}"),
        amount.map(a => sqls"amount = ${a}"),
        targetDate.map(td => sqls"target_date = ${td}"),
        goalType.map(gt => sqls"goal_type = ${gt.value}")
      ).flatten.reduceOption((a, b) => sqls"$a, $b").getOrElse(sqls"1 = 1")

      val query =
        sql"""
                    update goals
                    set $setClause
                    where id = ${id} and user_id = ${userId}
                """

      query.update.apply()
    }

  }.toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def createGoalAccount(
      id: UUID,
      goalId: UUID,
      accountId: UUID,
      amount: Double,
      percentage: Double
  ): Either[AppError.DatabaseError, Int] = Try {
    DB autoCommit { implicit session =>
      sql"""
            INSERT INTO goal_accounts (id, goal_id, account_id, amount, percentage)
            VALUES ($id, $goalId, $accountId, $amount, $percentage)
            """.update.apply()
    }
  }.toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def updateGoalAccount(
      goalAccountId: UUID,
      amount: Option[Double],
      percentage: Option[Double],
      userId: UserId
  ): Either[AppError, Int] =
    for
      goal <- findGoalByGoalAccountAndUser(goalAccountId, userId)
      result <- executeUpdateGoalAccount(goalAccountId, amount, percentage)
    yield result

  private def findGoalByGoalAccountAndUser(
      goalAccountId: UUID,
      userId: UserId
  ): Either[AppError, Goal] = Try(
    DB readOnly { implicit session =>
      sql"""
                SELECT g.id, g.name, g.amount, g.target_date, g.user_id, g.progress, g.goal_type, g.created_at, g.updated_at, g.deleted_at
                FROM goals g
                JOIN goal_accounts ga ON g.id = ga.goal_id
                WHERE ga.id = ${goalAccountId} AND g.user_id = ${userId}
            """
        .map(rs =>
          Goal(
            id = UUID.fromString(rs.string("id")),
            name = rs.string("name"),
            amount = rs.double("amount"),
            targetDate = rs.timestamp("target_date").toInstant,
            userId = UserId(UUID.fromString(rs.string("user_id"))),
            progress = rs.double("progress"),
            goalType = GoalType.fromString(rs.string("goal_type")).get,
            assignedAccounts = List()
          )
        )
        .single
        .apply()
    }
  ).toEither.left
    .map(e => AppError.DatabaseError(e.getMessage))
    .flatMap {
      case Some(goal) =>
        Right(goal)
      case _ =>
        Left(AppError.NotFoundError("Goal not found"))
    }

  private def executeUpdateGoalAccount(
      goalAccountId: UUID,
      amount: Option[Double],
      percentage: Option[Double]
  ): Either[AppError.DatabaseError, Int] = Try {
    DB.autoCommit { implicit session =>
      val setClause = Seq(
        amount.map(a => sqls"amount = ${a}"),
        percentage.map(p => sqls"percentage = ${p}")
      ).flatten
        .reduceOption((a, b) => sqls"$a, $b")
        .getOrElse(sqls"1 = 1")

      val query =
        sql"""
                UPDATE goal_accounts
                SET $setClause
                WHERE id = ${goalAccountId}
                """
      query.update.apply()
    }
  }.toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def deleteGoalAccount(
      id: UUID,
      userId: UserId
  ): Either[AppError.DatabaseError, Int] = Try(
    DB autoCommit { implicit session =>
      sql"""
                DELETE FROM goal_accounts
                USING goals
                WHERE goal_accounts.goal_id = goals.id
                    AND goal_accounts.id = ${id}
                    AND goals.user_id = ${userId};
                """.update.apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def getAssignedAccountsOnGoal(goalId: UUID)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, List[GoalAccount]] =
    val query = GoalAccountTable.select
      .filter(f => f.goal_id === goalId)

    val result = Try(dbClient.transaction: db =>
      db.run(query))

    result match
      case Failure(exception) =>
        Left(AppError.DatabaseError(exception.getMessage()))
      case Success(goalAccounts) =>
        Right(
          goalAccounts
            .map(ga =>
              GoalAccount(
                id = ga.id,
                goalId = ga.goal_id,
                accountId = ga.account_id,
                assignedAmount = AssignedAmount.Percentage(ga.percentage)
              )
            )
            .toList
        )

  def getAssignedBalanceOnRetirementGoal(userId: UserId)(using
      dbClient: DbClient.DataSource
  ): Either[AppError, Double] =
    val retirementGoalType = GoalType.Retirement.value

    val query = GoalTable.select
      .filter(f =>
        f.goal_type === retirementGoalType && f.user_id === UserId.toUUID(
          userId
        )
      )
      .single

    val result = Try(dbClient.transaction: db =>
      db.run(query))

    result match
      case Failure(exception) =>
        Left(AppError.DatabaseError(exception.getMessage()))
      case Success(goal) =>
        val goalAccounts = getAssignedAccountsOnGoal(goal.id).getOrElse(List())
        var balance = 0.0

        for ga <- goalAccounts do
          val account = AccountRepository2
            .getMinimalAccountById(ga.accountId)
            .getOrElse(MinimalAccountBalance(ga.accountId, 0.0))
          ga.assignedAmount match
            case AssignedAmount.Fixed(amount) =>
              balance += amount
            case AssignedAmount.Percentage(percentage) =>
              balance += account.balance * percentage

        Right(balance)
