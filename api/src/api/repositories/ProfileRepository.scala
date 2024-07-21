package api.repositories

import api.models.Profile
import scalikejdbc.*

import java.util.UUID
import scala.util.Try

object ProfileRepository:
    def getUsers(): Try[List[Profile]] = Try(
        DB.readOnly { implicit session =>
            sql"select id from profiles".map(rs => Profile(id = UUID.fromString(rs.string("id")))).list.apply()
        }
    )
