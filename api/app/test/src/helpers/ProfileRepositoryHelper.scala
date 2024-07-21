package test.helpers

import app.models.*
import scalikejdbc.*

import java.util.UUID

object AuthUserRepositoryHelper:
    def createUser(): Profile =
        val id = UUID.randomUUID()
        val profile = Profile(id = UUID.randomUUID())

        DB autoCommit { implicit session =>
            sql"""INSERT INTO auth.users (id, instance_id) VALUES (${profile.id}, ${UUID.randomUUID()})"""
                .update
                .apply()
        }

        profile
