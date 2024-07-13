package app.repositories

import app.common
import app.common.*
import io.circe.generic.auto.*
import io.circe.syntax.*
import scalikejdbc.*

import java.util.UUID
import scala.util.Try

object PlaidApiEventRepository:
  case class PlaidApiEventCreateInput(
      userId: Option[UUID],
      itemId: Option[UUID],
      plaidMethod: String,
      arguments: Map[String, String],
      requestId: Option[String],
      errorType: Option[String],
      errorCode: Option[String]
  )

  def create(input: PlaidApiEventCreateInput) =
    Try(DB autoCommit { implicit session =>
      val query =
        sql"""INSERT INTO plaid_api_events (item_id, user_id, plaid_method, arguments, request_id, error_type, error_code)
          VALUES (${input.itemId}, ${input.userId}, ${input.plaidMethod}, ${input.arguments.asJson.noSpaces}, ${input.requestId}, ${input.errorType}, ${input.errorCode})
          """
      query.execute
        .apply()
    }).toEither.left.map(exception =>
      Logger.root.error(s"Error creating Plaid API event", exception)
      RepositoryError.DatabaseError(exception.getMessage)
    )
