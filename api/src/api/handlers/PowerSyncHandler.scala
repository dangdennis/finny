package api.handlers

import api.dtos.DTOs
import api.models.Profile
import api.models.AuthenticationError
import api.common.Logger

object PowerSyncHandler:
    // def handleEventUpload(input: DTOs.PowersyncEventUploadRequest, user: Profile): Either[AuthenticationError, Unit] = {
    //     println("Handling powersync event upload")

    //     Right(())
    // }
    //
    def handleEventUpload(input: String, user: Profile): Either[AuthenticationError, Unit] = {
        println("Handling powersync event upload")
        println(input)

        Logger.root.info(s"Handling powersync event upload $input")

        Right(())
    }
