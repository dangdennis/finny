package api.handlers

import api.models.HttpError
import api.models.UserId
import api.services.AuthService

object UserHandler:
  def handleUserDelete(userId: UserId): Either[HttpError, Unit] = AuthService
    .deleteUser(userId, shouldSoftDelete = true)
    .left
    .map(_ => HttpError(400))
    .map(_ => Right(()))
