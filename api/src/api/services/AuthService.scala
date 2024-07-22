package api.services

import api.models.UserId

object AuthService:
    def deleteUser(userId: UserId): Either[Unit, Boolean] =
        // delete user from database
        Right(true)
