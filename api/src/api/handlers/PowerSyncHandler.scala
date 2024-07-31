package api.handlers
import api.common.Logger
import api.models.AuthenticationError
import api.models.Profile

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
