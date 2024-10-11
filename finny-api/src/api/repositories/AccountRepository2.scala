package api.repositories

import api.common.AppError
import scalasql.*
import scalasql.PostgresDialect.*

import java.time.Instant
import java.util.UUID
import scala.util.Try

case class AccountTable[T[_]](
    id: T[UUID],
    item_id: T[UUID],
    user_id: T[UUID],
    plaid_account_id: T[String],
    name: T[String],
    mask: T[Option[String]],
    official_name: T[Option[String]],
    current_balance: T[Double],
    available_balance: T[Double],
    iso_currency_code: T[Option[String]],
    unofficial_currency_code: T[Option[String]],
    `type`: T[Option[String]],
    subtype: T[Option[String]],
    created_at: T[Instant],
    updated_at: T[Instant],
    deleted_at: T[Option[Instant]]
)

object AccountTable extends Table[AccountTable]() {
  override def tableName = "accounts"
}

object AccountRepository2:
  def getMinimalAccountById(id: UUID)(using
      dbClient: DbClient.DataSource
  ): Either[AppError.DatabaseError, MinimalAccountBalance] =
    val query = AccountTable.select.filter(_.id === id).single

    val result = Try:
      dbClient.transaction: db =>
        db.run(query)
    .toEither

    result match
      case Left(value) => Left(AppError.DatabaseError(value.getMessage))
      case Right(value) =>
        Right(MinimalAccountBalance(value.id, value.current_balance))

  case class MinimalAccountBalance(accountId: UUID, balance: Double)
