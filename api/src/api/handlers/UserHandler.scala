package api.handlers

import api.models.AuthenticationError
import api.models.UserId
import api.services.AuthService

object UserHandler:
    def handleUserDelete(userId: UserId): Either[AuthenticationError, Unit] = AuthService
        .deleteUser(userId, shouldSoftDelete = true)
        .left
        .map(_ => AuthenticationError(400))
        .map(_ => Right(()))
