package api.handlers
import api.common.AppError
import api.common.Logger
import api.models.AuthenticationError
import api.models.Profile
import api.repositories.GoalRepository
import io.circe.Decoder
import io.circe.generic.semiauto.deriveDecoder
import io.circe.parser.*

import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.UUID

object PowerSyncHandler:
    def handleEventUpload(input: String, user: Profile): Either[AuthenticationError, Unit] = {
        Logger.root.info(s"Handling powersync event upload $input")

        decode[EventUploadRequest](input)
            .flatMap(request =>
                Logger.root.info(s"Handling ops ${request}")

                request
                    .data
                    .map(event => {
                        Logger.root.info(s"Handling op ${event}")
                        (event.`type`, event.op) match
                            case ("goals", "PUT") =>
                                event
                                    .data
                                    .get
                                    .as[GoalData]
                                    .flatMap(goalData =>
                                        Logger.root.info(s"Inserting goal ${goalData}")
                                        GoalRepository.createGoal(
                                            GoalRepository.CreateGoalInput(
                                                id = UUID.fromString(event.id),
                                                userId = user.id,
                                                name = goalData.name,
                                                amount = goalData.amount,
                                                targetDate = LocalDate
                                                    .parse(goalData.target_date, DateTimeFormatter.ISO_LOCAL_DATE)
                                                    .atStartOfDay()
                                                    .toInstant(java.time.ZoneOffset.UTC)
                                            )
                                        )
                                    )
                            case ("goals", "DELETE") =>
                                Logger.root.info(s"Deleting goal ${event.id}")
                                GoalRepository.deleteGoal(UUID.fromString(event.id))
                            case _ =>
                                Logger.root.info(s"Skipping event ${event.id}")
                                Right(())
                    })
                    .reduce((a, b) => a.flatMap(_ => b))
            )
            .left
            .map(err =>
                err match
                    case err: io.circe.Error =>
                        Logger
                            .root
                            .error(s"Failed to parse powersync op: ${err.getMessage} ${err.getStackTrace().toString()}")
                    case err: AppError.DatabaseError =>
                        Logger.root.error(s"Failed to handle powersync op: ${err.message}")

                // 200 because we inform the client that we received the request.
                // Errors must be handled via a success request or syncing errors to the client side.
                // If not a success, powersync client will continue to retry.
                AuthenticationError(200)
            )
            .map(_ => ())
    }

    case class EventUploadRequest(data: List[EventUpload])
    object EventUploadRequest:
        given Decoder[EventUploadRequest] = deriveDecoder

    case class EventUpload(op_id: Int, op: String, `type`: String, id: String, tx_id: Int, data: Option[io.circe.Json])
    object EventUpload:
        given Decoder[EventUpload] = deriveDecoder

    case class GoalData(amount: Double, name: String, target_date: String)
    object GoalData:
        given Decoder[GoalData] = deriveDecoder
