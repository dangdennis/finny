package api.repositories

import api.common.AppError
import api.models.PlaidItemId
import api.models.Transaction
import api.models.UserId
import scalikejdbc.*

import java.time.Instant
import java.util.UUID
import scala.util.Try

object TransactionRepository {
  case class UpsertTransactionInput(
      accountId: UUID,
      plaidTransactionId: String,
      category: Option[String],
      subcategory: Option[String],
      transactionType: String,
      name: String,
      amount: Double,
      isoCurrencyCode: Option[String],
      unofficialCurrencyCode: Option[String],
      date: Instant,
      pending: Boolean,
      accountOwner: Option[String]
  )

  def upsertTransaction(
      input: UpsertTransactionInput
  ): Either[AppError.DatabaseError, Transaction] = Try(
    DB.autoCommit { implicit session =>
      sql"""
            INSERT INTO transactions (
                account_id,
                plaid_transaction_id,
                category,
                subcategory,
                type,
                name,
                amount,
                iso_currency_code,
                unofficial_currency_code,
                date,
                pending,
                account_owner
            ) VALUES (
                ${input.accountId},
                ${input.plaidTransactionId},
                ${input.category},
                ${input.subcategory},
                ${input.transactionType},
                ${input.name},
                ${input.amount},
                ${input.isoCurrencyCode},
                ${input.unofficialCurrencyCode},
                ${input.date},
                ${input.pending},
                ${input.accountOwner}
            )
            ON CONFLICT (plaid_transaction_id) DO UPDATE SET
                account_id = EXCLUDED.account_id,
                category = EXCLUDED.category,
                subcategory = EXCLUDED.subcategory,
                type = EXCLUDED.type,
                name = EXCLUDED.name,
                amount = EXCLUDED.amount,
                iso_currency_code = EXCLUDED.iso_currency_code,
                unofficial_currency_code = EXCLUDED.unofficial_currency_code,
                date = EXCLUDED.date,
                pending = EXCLUDED.pending,
                account_owner = EXCLUDED.account_owner
            RETURNING *
        """.map(toModel).single.apply().get
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def deleteTransactionsByPlaidTransactionIds(
      plaidTransactionIds: List[String]
  ): Either[AppError.DatabaseError, Boolean] =
    if plaidTransactionIds.isEmpty then Right(true)
    else
      Try(
        DB.autoCommit { implicit session =>
          sql"""
                      DELETE FROM transactions
                      WHERE plaid_transaction_id IN ($plaidTransactionIds)
                    """.execute.apply()
        }
      ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def deleteTransactionsByItemId(itemId: PlaidItemId, userId: UserId)(using
      session: DBSession
  ): Either[AppError.DatabaseError, Boolean] = Try(sql"""
            DELETE FROM transactions
            WHERE account_id IN (
                SELECT accounts.id
                FROM accounts
                WHERE accounts.item_id = $itemId
                AND accounts.user_id = $userId
            );
        """.execute.apply()).toEither.left.map(e =>
    AppError.DatabaseError(e.getMessage)
  )

  def getTransactionsByAccountId(
      accountId: UUID
  ): Either[AppError.DatabaseError, List[Transaction]] = Try(
    DB.readOnly { implicit session =>
      sql"""
            SELECT * FROM transactions
            WHERE account_id = $accountId
        """.map(toModel).list.apply()
    }
  ).toEither.left.map(e => AppError.DatabaseError(e.getMessage))

  def toModel(rs: WrappedResultSet): Transaction = Transaction(
    id = UUID.fromString(rs.string("id")),
    accountId = UUID.fromString(rs.string("account_id")),
    plaidTransactionId = rs.string("plaid_transaction_id"),
    category = rs.stringOpt("category"),
    subcategory = rs.stringOpt("subcategory"),
    transactionType = rs.string("type"),
    name = rs.string("name"),
    amount = rs.double("amount"),
    isoCurrencyCode = rs.stringOpt("iso_currency_code"),
    unofficialCurrencyCode = rs.stringOpt("unofficial_currency_code"),
    date = rs.dateTime("date").toInstant(),
    pending = rs.boolean("pending"),
    accountOwner = rs.stringOpt("account_owner")
  )
}
