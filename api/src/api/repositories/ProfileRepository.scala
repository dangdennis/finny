package api.repositories

import api.models.Profile
import scalikejdbc.*

import java.util.UUID
import scala.util.Try

object ProfileRepository:
    def getProfiles(): Try[List[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id from profiles".map(rs => Profile(id = UUID.fromString(rs.string("id")))).list.apply()
        }
    )

    def getProfileByUserId(userId: UUID): Try[Option[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id from profiles where id = ${userId}"
                .map(rs => Profile(id = UUID.fromString(rs.string("id"))))
                .single
                .apply()
        }
    )
