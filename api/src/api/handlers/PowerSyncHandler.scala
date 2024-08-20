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
import api.repositories.ProfileRepository

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
                    .map(data => handleGoalAccountPut(event.id, data))
            case ("goal_accounts", "PATCH") =>
                event
                    .data
                    .toRight(AppError.ValidationError("No data found for GoalAccount PUT operation"))
                    .flatMap(_.as[GoalAccountPatchData].left.map(err => AppError.ValidationError(err.getMessage)))
                    .map(data => handleGoalAccountPatch(event.id, data, user))
            case ("goal_accounts", "DELETE") =>
                handleGoalAccountDelete(event.id, user)
            case ("profiles", "PATCH") =>
                event
                    .data
                    .toRight(AppError.ValidationError("No data found for Profile PATCH operation"))
                    .flatMap(_.as[ProfilePatchData].left.map(err => AppError.ValidationError(err.getMessage)))
                    .map(data => handleProfilePatch(event.id, data, user))
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
        GoalRepository.deleteGoal(UUID.fromString(recordId), user.id).map(_ => ())

    private def handleGoalAccountPut(recordId: String, data: GoalAccountPutData): Either[AppError, Unit] =
        Logger.root.info(s"Creating goal $data")
        GoalRepository
            .createGoalAccount(
                id = UUID.fromString(recordId),
                goalId = UUID.fromString(data.goal_id),
                accountId = UUID.fromString(data.account_id),
                amount = data.amount,
                percentage = data.percentage
            )
            .map(_ => ())

    private def handleGoalAccountPatch(
        recordId: String,
        data: GoalAccountPatchData,
        user: Profile
    ): Either[AppError, Unit] =
        Logger.root.info(s"Creating goal $data")
        GoalRepository
            .updateGoalAccount(
                goalAccountId = UUID.fromString(recordId),
                amount = data.amount,
                percentage = data.percentage,
                userId = user.id
            )
            .map(_ => ())

    private def handleGoalAccountDelete(recordId: String, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Deleting goal account $recordId")
        GoalRepository.deleteGoalAccount(UUID.fromString(recordId), user.id).map(_ => ())

    private def handleProfilePatch(recordId: String, data: ProfilePatchData, user: Profile): Either[AppError, Unit] =
        Logger.root.info(s"Updating profile $data")
        ProfileRepository
            .updateProfile(
                ProfileRepository.ProfileUpdate(
                    userId = user.id,
                    age = data.age,
                    dateOfBirth = data.date_of_birth,
                    retirementAge = data.retirement_age
                )
            )
            .map(_ => ())

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

    case class GoalAccountPutData(goal_id: String, account_id: String, amount: Double, percentage: Double)
    object GoalAccountPutData:
        given Decoder[GoalAccountPutData] = deriveDecoder

    case class GoalAccountPatchData(amount: Option[Double], percentage: Option[Double])
    object GoalAccountPatchData:
        given Decoder[GoalAccountPatchData] = deriveDecoder

    case class ProfilePatchData(age: Option[Int], date_of_birth: Option[LocalDate], retirement_age: Option[Int])
    object ProfilePatchData:
        given Decoder[ProfilePatchData] = deriveDecoder
