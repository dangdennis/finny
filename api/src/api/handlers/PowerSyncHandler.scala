package api.handlers

import api.common.AppError
import api.common.Logger
import api.models.HttpError
import api.models.Profile
import api.repositories.GoalRepository
import io.circe.Decoder
import io.circe.generic.semiauto.deriveDecoder
import io.circe.parser.*

import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.UUID

object PowerSyncHandler:
    def handleEventUpload(input: String, user: Profile): Either[HttpError, Unit] =
        Logger.root.info(s"Received powersync event upload $input")
        decode[EventUploadRequest](input).flatMap(processEventUploadRequest(_, user)) match
            case Left(error) =>
                Logger.root.error(s"Error handling event upload: $error")
                Right(())
            case Right(_) =>
                Right(())

    private def processEventUploadRequest(request: EventUploadRequest, user: Profile): Either[AppError, Unit] = request
        .data
        .map(processEvent(_, user))
        .reduce((a, b) => a.flatMap(_ => b))

    private def processEvent(event: EventUpload, user: Profile): Either[AppError, Unit] =
        (event.`type`, event.op) match
            case ("goals", "PUT") =>
                event
                    .data
                    .toRight(AppError.ValidationError("No data found for Goal PUT operation"))
                    .flatMap(_.as[GoalPutData].left.map(err => AppError.ValidationError(err.getMessage)))
                    .flatMap(data => handleGoalPut(event.id, data, user))
            case ("goals", "DELETE") =>
                handleGoalDelete(event.id, user)
            case ("goals", "PATCH") =>
                event
                    .data
                    .toRight(AppError.ValidationError("No data found for Goal PATCH operation"))
                    .flatMap(_.as[GoalPatchData].left.map(err => AppError.ValidationError(err.getMessage)))
                    .map(data => handleGoalPatch(event.id, data, user))
            case ("goal_accounts", "PUT") =>
                event
                    .data
                    .toRight(AppError.ValidationError("No data found for GoalAccount PUT operation"))
                    .flatMap(_.as[GoalAccountPutData].left.map(err => AppError.ValidationError(err.getMessage)))
                    .map(data => handleGoalAccountPut(event.id, data, user))
            case ("goal_accounts", "PATCH") =>
                event
                    .data
                    .toRight(AppError.ValidationError("No data found for GoalAccount PUT operation"))
                    .flatMap(_.as[GoalAccountPatchData].left.map(err => AppError.ValidationError(err.getMessage)))
                    .map(data => handleGoalAccountPatch(event.id, data, user))
            case ("goal_accounts", "DELETE") =>
                handleGoalAccountDelete(event.id, user)
            case _ =>
                Logger.root.info(s"Skipping event ${event.op} ${event.`type`} ${event.id}")
                Right(())

    private def handleGoalPut(recordId: String, data: GoalPutData, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Creating goal $data")
        GoalRepository
            .createGoal(
                GoalRepository.CreateGoalInput(
                    id = UUID.fromString(recordId),
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

    private def handleGoalPatch(recordId: String, data: GoalPatchData, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Updating goal $data")
        GoalRepository
            .updateGoal(
                id = UUID.fromString(recordId),
                name = data.name,
                amount = data.amount,
                targetDate = data
                    .target_date
                    .map(
                        LocalDate
                            .parse(_, DateTimeFormatter.ISO_LOCAL_DATE)
                            .atStartOfDay()
                            .toInstant(java.time.ZoneOffset.UTC)
                    ),
                userId = user.id
            )
            .map(_ => ())

    private def handleGoalDelete(recordId: String, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Deleting goal $recordId")
        GoalRepository.deleteGoal(UUID.fromString(recordId), user.id).right.map(_ => ())

    private def handleGoalAccountPut(
        recordId: String,
        data: GoalAccountPutData,
        user: Profile
    ): Either[AppError, Unit] =
        Logger.root.info(s"Creating goal $data")
        GoalRepository
            .upsertGoalAccount(
                id = UUID.fromString(recordId),
                goalId = UUID.fromString(data.goal_id),
                accountId = UUID.fromString(data.account_id),
                amount = Some(data.amount),
                percentage = Some(data.percentage),
                userId = user.id
            )
            .map(_ => ())

    private def handleGoalAccountPatch(
        recordId: String,
        data: GoalAccountPatchData,
        user: Profile
    ): Either[AppError, Unit] =
        Logger.root.info(s"Creating goal $data")
        GoalRepository
            .upsertGoalAccount(
                id = UUID.fromString(recordId),
                goalId = UUID.fromString(data.goal_id),
                accountId = UUID.fromString(data.account_id),
                amount = data.amount,
                percentage = data.percentage,
                userId = user.id
            )
            .map(_ => ())

    private def handleGoalAccountDelete(recordId: String, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Deleting goal account $recordId")
        GoalRepository.deleteGoalAccount(UUID.fromString(recordId), user.id).right.map(_ => ())

    case class EventUploadRequest(data: List[EventUpload])
    object EventUploadRequest:
        given Decoder[EventUploadRequest] = deriveDecoder

    case class EventUpload(op_id: Int, op: String, `type`: String, id: String, tx_id: Int, data: Option[io.circe.Json])
    object EventUpload:
        given Decoder[EventUpload] = deriveDecoder

    case class GoalPutData(amount: Double, name: String, target_date: String)
    object GoalPutData:
        given Decoder[GoalPutData] = deriveDecoder

    case class GoalPatchData(amount: Option[Double], name: Option[String], target_date: Option[String])
    object GoalPatchData:
        given Decoder[GoalPatchData] = deriveDecoder

    case class GoalAccountPutData(account_id: String, amount: Double, goal_id: String, percentage: Double)
    object GoalAccountPutData:
        given Decoder[GoalAccountPutData] = deriveDecoder

    case class GoalAccountPatchData(
        account_id: String,
        amount: Option[Double],
        goal_id: String,
        percentage: Option[Double]
    )
    object GoalAccountPatchData:
        given Decoder[GoalAccountPatchData] = deriveDecoder

// {"data":[{"op_id":94,"op":"PUT","type":"goal_accounts",
//     "id":"7f2b528b-7576-4e59-9b9b-3724dac410d1",
//     "tx_id":96,
//     "data":{"account_id":"495f3ee1-6187-4dcb-98a4-f6fa4b01b0b9"
//     ,"amount":0.0,
//     "created_at":"2024-08-15T00:16:58.640944"
//     ,"goal_id":"c7dfe014-3050-4f4e-a61e-67dfc5d52ba6",
//     "percentage":50.0,"updated_at":"2024-08-15T00:16:58.641331"}}]}
