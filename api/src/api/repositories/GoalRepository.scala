package api.repositories

import api.common.AppError
import api.models.Goal
import api.models.UserId
import scalikejdbc.*

import java.time.Instant
import java.util.UUID
import scala.util.Try
import api.common.Logger

object GoalRepository:
    def getGoal(id: UUID): Either[AppError.DatabaseError, Option[Goal]] = Try(
        DB readOnly { implicit session =>
            sql"""select * from goals where id = ${id}"""
                .map(rs =>
                    Goal(
                        id = UUID.fromString(rs.string("id")),
                        name = rs.string("name"),
                        amount = rs.double("amount"),
                        targetDate = rs.timestamp("target_date").toInstant,
                        userId = UserId(UUID.fromString(rs.string("user_id"))),
                        progress = rs.double("progress"),
                        createdAt = rs.timestamp("created_at").toInstant,
                        updatedAt = rs.timestamp("updated_at").toInstant,
                        deletedAt = rs.timestampOpt("created_at").map(_.toInstant),
                        assignedAccounts = List()
                    )
                )
                .single
                .apply()
        }
    ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

    def getGoalsByUserId(userId: UserId): Either[AppError.DatabaseError, List[Goal]] = Try(
        DB readOnly { implicit session =>
            sql"""select * from goals where user_id = ${userId}"""
                .map(rs =>
                    Goal(
                        id = UUID.fromString(rs.string("id")),
                        name = rs.string("name"),
                        amount = rs.double("amount"),
                        targetDate = rs.timestamp("target_date").toInstant,
                        userId = UserId(UUID.fromString(rs.string("user_id"))),
                        progress = rs.double("progress"),
                        createdAt = rs.timestamp("created_at").toInstant,
                        updatedAt = rs.timestamp("updated_at").toInstant,
                        deletedAt = rs.timestampOpt("created_at").map(_.toInstant),
                        assignedAccounts = List()
                    )
                )
                .list
                .apply()
        }
    ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

    case class CreateGoalInput(id: UUID, userId: UserId, name: String, amount: Double, targetDate: Instant)

    def createGoal(input: CreateGoalInput): Either[AppError.DatabaseError, Goal] = Try(
        DB autoCommit { implicit session =>
            sql"""insert into goals (id, user_id, name, amount, target_date)
                    values (${input.id}, ${input.userId}, ${input.name}, ${input.amount}, ${input.targetDate})
                    returning id, name, amount, target_date, user_id, progress, created_at, updated_at, deleted_at
                  """
                .map(rs =>
                    Goal(
                        id = UUID.fromString(rs.string("id")),
                        name = rs.string("name"),
                        amount = rs.double("amount"),
                        targetDate = rs.timestamp("target_date").toInstant,
                        userId = UserId(UUID.fromString(rs.string("user_id"))),
                        progress = rs.double("progress"),
                        createdAt = rs.timestamp("created_at").toInstant,
                        updatedAt = rs.timestamp("updated_at").toInstant,
                        deletedAt = rs.timestampOpt("created_at").map(_.toInstant),
                        assignedAccounts = List()
                    )
                )
                .single
                .apply()
        }
    ).map(g => g.get).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

    def deleteGoal(id: UUID): Either[AppError.DatabaseError, Int] = Try(
        DB autoCommit { implicit session =>
            sql"""delete from goals where id = ${id}""".update.apply()
        }
    ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

    def updateGoal(
        id: UUID,
        name: Option[String],
        amount: Option[Double],
        targetDate: Option[Instant],
        userId: UUID
    ): Either[AppError.DatabaseError, Int] = Try {
        DB autoCommit { implicit session =>
            val setClause = Seq(
                name.map(n => sqls"name = ${n}"),
                amount.map(a => sqls"amount = ${a}"),
                targetDate.map(td => sqls"target_date = ${td}")
            ).flatten.reduceOption((a, b) => sqls"$a, $b").getOrElse(sqls"1 = 1")

            val query =
                sql"""
                    update goals
                    set $setClause
                    where id = ${id} and user_id = ${userId}
                """

            Logger.root.info(s"Executing query: ${query.statement}")
            query.update.apply()
        }

    }.toEither.left.map(e => AppError.DatabaseError(e.getMessage))
