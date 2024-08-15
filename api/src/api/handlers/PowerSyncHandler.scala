package api.handlers

import api.common.AppError
import api.common.Logger
import api.models.AuthenticationError
import api.models.Profile
import api.repositories.GoalRepository
import io.circe.Decoder
import io.circe.generic.semiauto.deriveDecoder
import io.circe.parser._

import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.UUID

object PowerSyncHandler:
    def handleEventUpload(input: String, user: Profile): Either[AuthenticationError, Unit] =
        Logger.root.info(s"Received powersync event upload $input")

        decode[EventUploadRequest](input)
            .left
            .map(err => AppError.ValidationError(err.getMessage))
            .flatMap(processEventUploadRequest(_, user))
            .left
            // Powersync expects us to return a successful response even on actual errors.
            // We can't return a 500, so we return a 200 with an error message.
            .map(handleError).map(_ => ())

    private def processEventUploadRequest(request: EventUploadRequest, user: Profile): Either[AppError, Unit] = request
        .data
        .map(processEvent(_, user))
        .reduce((a, b) => a.flatMap(_ => b))

    private def processEvent(event: EventUpload, user: Profile): Either[AppError, Unit] =
        (event.`type`, event.op) match
            case ("goals", "PUT") =>
                event
                    .data
                    .flatMap(_.as[GoalPutData].toOption)
                    .map(goalData => handleGoalPut(event.id, goalData, user))
                    .getOrElse(Right(()))
            case ("goals", "DELETE") =>
                handleGoalDelete(event.id)
            case ("goals", "PATCH") =>
                event
                    .data
                    .flatMap(_.as[GoalPatchData].toOption)
                    .map(goalData => handleGoalPatch(event.id, goalData, user))
                    .getOrElse(Right(()))
            case _ =>
                Logger.root.info(s"Skipping event ${event.op} ${event.`type`} ${event.id}")
                Right(())

    private def handleGoalPut(eventId: String, data: GoalPutData, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Inserting goal $data")
        GoalRepository
            .createGoal(
                GoalRepository.CreateGoalInput(
                    id = UUID.fromString(eventId),
                    userId = user.id,
                    name = data.name,
                    amount = data.amount,
                    targetDate = LocalDate
                        .parse(data.target_date, DateTimeFormatter.ISO_LOCAL_DATE)
                        .atStartOfDay()
                        .toInstant(java.time.ZoneOffset.UTC)
                )
            )
            .map(_ => ())

    private def handleGoalDelete(eventId: String): Either[AppError, Unit] =
        Logger.root.info(s"Deleting goal $eventId")
        GoalRepository.deleteGoal(UUID.fromString(eventId)).map(_ => ())

    private def handleGoalPatch(eventId: String, data: GoalPatchData, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Inserting goal $data")
        GoalRepository
            .updateGoal(
                id = UUID.fromString(eventId),
                name = data.name,
                amount = data.amount,
                targetDate = LocalDate
                    .parse(data.target_date, DateTimeFormatter.ISO_LOCAL_DATE)
                    .atStartOfDay()
                    .toInstant(java.time.ZoneOffset.UTC),
                userId = user.id
            )
            .map(_ => ())

    private def handleError(err: AppError): AuthenticationError =
        err match
            // todo: is there a way to not have to handle all these error cases?
            case err: AppError.DatabaseError =>
                Logger.root.error(s"Failed to handle powersync op: ${err.message}")
            case err: AppError.ValidationError =>
                Logger.root.error(s"Failed to handle powersync op: ${err.message}")
            case err: AppError.NetworkError =>
                Logger.root.error(s"Failed to handle powersync op: ${err.message}")
            case err: AppError.ServiceError =>
                Logger.root.error(s"Failed to handle powersync op: ${err.error.errorMessage}")
            case err: AppError.NotFoundError =>
                Logger.root.error(s"Failed to handle powersync op: ${err.message}")

        AuthenticationError(200)

    case class EventUploadRequest(data: List[EventUpload])
    object EventUploadRequest:
        given Decoder[EventUploadRequest] = deriveDecoder

    case class EventUpload(op_id: Int, op: String, `type`: String, id: String, tx_id: Int, data: Option[io.circe.Json])
    object EventUpload:
        given Decoder[EventUpload] = deriveDecoder

    case class GoalPutData(amount: Double, name: String, target_date: String)
    object GoalPutData:
        given Decoder[GoalPutData] = deriveDecoder

    case class GoalPatchData(amount: Double, name: String, target_date: String)
    object GoalPatchData:
        given Decoder[GoalPatchData] = deriveDecoder
