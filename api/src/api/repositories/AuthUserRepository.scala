package repositories

import api.common.AppError
import api.models.AuthIdentity
import api.models.AuthUser
import api.models.UserId
import scalikejdbc.*

import java.util.UUID
import scala.util.Try

object AuthUserRepository:
  def getUser(
      userId: UserId
  ): Either[AppError.DatabaseError, Option[AuthUser]] = Try(
    DB.readOnly { implicit session =>
      sql"select * from auth.users where id = $userId"
        .map(rs =>
          AuthUser(
            id = UserId(UUID.fromString(rs.string("id"))),
            deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
          )
        )
        .single
        .apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def getIdentities(
      userId: UserId
  ): Either[AppError.DatabaseError, List[AuthIdentity]] = Try(
    DB readOnly { implicit session =>
      sql"select * from auth.identities where user_id = $userId"
        .map(rs =>
          AuthIdentity(
            id = UUID.fromString(rs.string("id")),
            userId = UUID.fromString(rs.string("user_id")),
            providerId = rs.string("provider_id"),
            provider = rs.string("provider")
          )
        )
        .list
        .apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def deleteIdentitiesAdmin(
      userId: UserId
  ): Either[AppError.DatabaseError, Int] = Try(
    DB.localTx { implicit session =>
      sql"""delete from auth.identities where user_id = $userId""".update
        .apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))
