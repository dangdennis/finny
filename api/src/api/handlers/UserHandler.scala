package api.handlers

import api.models.AuthenticationError
import api.services.AuthService
import api.models.UserId

object UserHandler:
    def handleUserDelete(userId: UserId): Either[AuthenticationError, Unit] = AuthService
        .deleteUser(userId)
        .left
        .map(_ => AuthenticationError(400))
        .map(_ => Right(()))
