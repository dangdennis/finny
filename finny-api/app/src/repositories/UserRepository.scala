package app.repositories

import app.models.User
import scalikejdbc._

object UserRepository {
  def getUsers(): Unit = {
    val users: List[User] = DB readOnly { implicit session =>
      sql"select id, email from auth.users"
        .map(rs =>
          User(
            id = rs.string("id"),
            email = rs.stringOpt("email")
          )
        )
        .list
        .apply()
    }

    println(s"get users start $users")

    ()
  }

}
