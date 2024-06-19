package test.helpers

import app.models.Profile
import scalikejdbc._

import java.util.UUID

object UserRepositoryHelper:
  def createUser(): Profile =
    val id = UUID.randomUUID()
    val user = Profile(id = UUID.randomUUID())

    DB autoCommit { implicit session =>
      sql"""INSERT INTO auth.users (id, instance_id) VALUES (${user.id}, ${UUID.randomUUID()})""".update
        .apply()
    }

    user
