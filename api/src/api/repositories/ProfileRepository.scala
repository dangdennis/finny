package api.repositories

import api.models.Profile
import api.models.UserId
import scalikejdbc.*

import java.util.UUID
import scala.util.Try

object ProfileRepository:
    def getProfiles(): Try[List[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id, deleted_at from profiles"
                .map(rs =>
                    Profile(
                        id = UUID.fromString(rs.string("id")),
                        deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
                    )
                )
                .list
                .apply()
        }
    )

    def getProfileByUserId(userId: UserId): Try[Option[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id, deleted_at from profiles where id = ${userId}"
                .map(rs =>
                    Profile(
                        id = UUID.fromString(rs.string("id")),
                        deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
                    )
                )
                .single
                .apply()
        }
    )

    // def deleteProfileAndUser(userId: UUID): Try[Int] = Try(
