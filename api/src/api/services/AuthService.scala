package api.services

import api.common.AppError
import api.common.Environment
import api.common.Logger
import api.jobs.Jobs
import api.jobs.Jobs.JobRequest
import api.models.UserId
import io.circe.*
import io.circe.generic.semiauto.deriveDecoder
import io.circe.generic.semiauto.deriveEncoder
import io.circe.parser.*
import io.circe.syntax.*
import repositories.AuthUserRepository
import sttp.client3.*

object AuthService:
  val supabaseUrl = Environment.getSupabaseUrl
  val supabaseKey = Environment.getSupabaseKey

  case class AdminDeleteUserInput(should_soft_delete: Boolean)
  given Encoder[AdminDeleteUserInput] = deriveEncoder

  def deleteUser(
      userId: UserId,
      shouldSoftDelete: Boolean
  ): Either[AppError, Boolean] =
    Logger.root.info(s"Deleting user with ID ${userId} via Supabase")

    val request = basicRequest
      .delete(uri"$supabaseUrl/auth/v1/admin/users/${userId}")
      .body(
        AdminDeleteUserInput(should_soft_delete =
          shouldSoftDelete
        ).asJson.noSpaces
      )
      .header("Content-Type", "application/json")
      .header("apikey", supabaseKey)
      .header("Authorization", s"Bearer $supabaseKey")
      .response(asString)

    request.send(HttpClientSyncBackend()) match
      case response if response.isSuccess =>
        Jobs
          .enqueueJob(JobRequest.JobDeleteUser(userId = userId))
          .left
          .map(err =>
            Logger.root.error(
              s"Failed to enqueue job to delete user with ID ${userId} $err"
            )
            AppError.NetworkError(
              s"Failed to enqueue job to delete user with ID ${userId}"
            )
          )
          .flatMap(_ => AuthUserRepository.deleteIdentitiesAdmin(userId))
          .map(err =>
            Logger.root
              .error(s"Failed to soft delete user with ID ${userId} $err")
            false
          )
      case response =>
        Left(
          AppError.NetworkError(
            s"Failed to delete user with ID ${userId}. ${response.body.toString()}"
          )
        )

  case class AdminCreateUserInput(
      email: String,
      password: String,
      email_confirm: Boolean
  )
  case class AdminCreateUserOutput(id: String, email: String)
  given Encoder[AdminCreateUserInput] = deriveEncoder
  given Decoder[AdminCreateUserOutput] = deriveDecoder

  def createUserViaSupabaseAuth(
      email: String,
      password: String,
      emailConfirm: Boolean
  ): Either[String, AdminCreateUserOutput] =
    val request = basicRequest
      .post(uri"$supabaseUrl/auth/v1/admin/users")
      .body(
        AdminCreateUserInput(
          email = email,
          password = password,
          email_confirm = emailConfirm
        ).asJson.noSpaces
      )
      .header("Content-Type", "application/json")
      .header("apikey", supabaseKey)
      .header("Authorization", s"Bearer $supabaseKey")
      .response(asString)

    request.send(HttpClientSyncBackend()) match
      case response if response.isSuccess =>
        Logger.root.info(s"User was successfully created via Supabase")
        response.body.left
          .map(error => s"Failed to create user with email ${email}. ${error}")
          .flatMap(body =>
            decode[AdminCreateUserOutput](body).left
              .map(err =>
                s"Failed to decode AdminCreateUserOutput response body: ${err}"
              )
              .map(output => output)
          )
      case response =>
        Left(
          s"Failed to create user with email ${email}. ${response.body.toString()}"
        )
