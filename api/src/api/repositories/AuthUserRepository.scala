package repositories

import api.models.AuthUser
import api.models.UserId
import scalikejdbc.*

import java.util.UUID
import scala.util.Try

object AuthUserRepository:
    def getUser(userId: UserId): Try[Option[AuthUser]] = Try(
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
    )

    def deleteIdentitiesAdmin(userId: UserId): Either[Throwable, Int] =
        Try(
            DB.localTx { implicit session =>
                sql"""delete from auth.identities where user_id = $userId""".update.apply()
            }
        ).toEither
