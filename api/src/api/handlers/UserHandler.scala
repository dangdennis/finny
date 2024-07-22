package api.handlers

import api.models.AuthenticationError
import api.models.Profile

object UserHandler:
    def handleUserDelete(user: Profile): Either[AuthenticationError, Unit] =
        // delete plaid items
        // delete user

        Right(())
