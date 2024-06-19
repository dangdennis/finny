package app.repositories

import app.models.User
import scalikejdbc._

import java.util.UUID
import scala.util.Try

object UserProfileRepository:
  def getUsers(): Try[List[User]] =
    Try(DB readOnly { implicit session =>
      sql"select id from users"
        .map(rs =>
          User(
            id = UUID.fromString(rs.string("id"))
          )
        )
        .list
        .apply()
    })
