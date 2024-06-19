package test.helpers

import app.models.User
import scalikejdbc._

import java.util.UUID

object UserRepositoryHelper:
  def createUser(): User =
    val id = UUID.randomUUID()
    val user = User(id = UUID.randomUUID())

    DB autoCommit { implicit session =>
      sql"""INSERT INTO auth.users (id, instance_id) VALUES (${user.id}, ${UUID.randomUUID()})""".update
        .apply()
    }

    user
