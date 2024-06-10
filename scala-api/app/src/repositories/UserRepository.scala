package app.repositories

import app.models.User
import scalikejdbc._

import java.util.UUID

object UserRepository:
  def getUsers(): Unit =
    val users: List[User] = DB readOnly { implicit session =>
      sql"select id from users"
        .map(rs =>
          User(
            id = UUID.fromString(rs.string("id"))
          )
        )
        .list
        .apply()
    }

    println(s"get users start $users")

    ()
