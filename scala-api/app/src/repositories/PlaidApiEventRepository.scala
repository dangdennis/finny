package app.repositories

import io.circe.generic.auto.*
import io.circe.syntax.*
import scalikejdbc.*

import java.util.UUID
import scala.util.Try
import scala.util.Failure
import scala.util.Success

object PlaidApiEventRepository:
  case class PlaidApiEventCreateInput(
      userId: UUID,
      itemId: UUID,
      plaidMethod: String,
      arguments: Map[String, String],
      requestId: String,
      errorType: Option[String],
      errorCode: Option[String]
  )

  def create(input: PlaidApiEventCreateInput): Either[RepositoryError, Unit] =
    val res = Try(DB autoCommit { implicit session =>
      val query =
        sql"""INSERT INTO plaid_api_events (item_id, user_id, plaid_method, arguments, request_id, error_type, error_code)
        VALUES (${input.itemId}, ${input.userId}, ${input.plaidMethod}, ${input.arguments.asJson.noSpaces}, ${input.requestId}, ${input.errorType}, ${input.errorCode})
        """
      query.execute
        .apply()
    })

    res match
      case Failure(exception) => Left(RepositoryError.DatabaseError(exception.getMessage))
      case Success(value)     => Right(())
