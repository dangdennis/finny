package test.helpers

import api.models.*
import api.services.AuthService
import scalikejdbc.*

import java.util.UUID

object AuthServiceHelper:
    def createUser(): Profile =
        val id = UUID.randomUUID()
        val profile = Profile(id = UUID.randomUUID(), deletedAt = None)

        DB autoCommit { implicit session =>
            sql"""INSERT INTO auth.users (id, instance_id) VALUES (${profile.id}, ${UUID.randomUUID()})"""
                .update
                .apply()
        }

        profile

    def createUserViaSupabaseAuth(email: String, password: String) = AuthService
        .createUserViaSupabaseAuth(email, password, emailConfirm = true)
