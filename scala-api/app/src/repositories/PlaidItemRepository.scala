package app.repositories

import app.models.PlaidItem
import app.models.PlaidItemStatus
import scalikejdbc.*

import java.util.UUID
import scala.util.Try

object PlaidItemRepository:
  def getById(id: UUID): Try[PlaidItem] =
    Try(DB readOnly { implicit session =>
      sql"""select id, user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor, created_at from plaid_items where id = ${id}"""
        .map(rs =>
          PlaidItem(
            id = UUID.fromString(rs.string("id")),
            userId = UUID.fromString(rs.string("user_id")),
            plaidAccessToken = rs.string("plaid_access_token"),
            plaidItemId = rs.string("plaid_item_id"),
            plaidInstitutionId = rs.string("plaid_institution_id"),
            status = PlaidItemStatus.fromString(rs.string("status")),
            transactionsCursor = rs.stringOpt("transactions_cursor"),
            createdAt = rs.timestamp("created_at").toInstant
          )
        )
        .single
        .apply()
        .get
    })

  def getByItemId(itemId: String): Try[PlaidItem] =
    Try(DB readOnly { implicit session =>
      sql"""select id, user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor, created_at from plaid_items where plaid_item_id = ${itemId}"""
        .map(rs =>
          PlaidItem(
            id = UUID.fromString(rs.string("id")),
            userId = UUID.fromString(rs.string("user_id")),
            plaidAccessToken = rs.string("plaid_access_token"),
            plaidItemId = rs.string("plaid_item_id"),
            plaidInstitutionId = rs.string("plaid_institution_id"),
            status = PlaidItemStatus.fromString(rs.string("status")),
            transactionsCursor = rs.stringOpt("transactions_cursor"),
            createdAt = rs.timestamp("created_at").toInstant
          )
        )
        .single
        .apply()
        .get
    })

  case class CreateItemInput(
      userId: UUID,
      plaidAccessToken: String,
      plaidItemId: String,
      plaidInstitutionId: String,
      status: PlaidItemStatus,
      transactionsCursor: Option[String]
  )

  def createItem(input: CreateItemInput): Try[PlaidItem] =
    Try(DB autoCommit { implicit session =>
      val query =
        sql"""INSERT INTO plaid_items (user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor)
        VALUES (${input.userId}, ${input.plaidAccessToken}, ${input.plaidItemId}, ${input.plaidInstitutionId}, ${input.status
            .toString()}, ${input.transactionsCursor})
        ON CONFLICT (plaid_item_id) DO UPDATE SET
          status = EXCLUDED.status,
          plaid_access_token = EXCLUDED.plaid_access_token
        RETURNING id, user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor, created_at;
        """
      query
        .map(rs =>
          PlaidItem(
            id = UUID.fromString(rs.string("id")),
            createdAt = rs.timestamp("created_at").toInstant,
            plaidAccessToken = rs.string("plaid_access_token"),
            plaidInstitutionId = rs.string("plaid_institution_id"),
            plaidItemId = rs.string("plaid_item_id"),
            status = PlaidItemStatus.fromString(rs.string("status")),
            transactionsCursor = rs.stringOpt("transactions_cursor"),
            userId = UUID.fromString(rs.string("user_id"))
          )
        )
        .single
        .apply()
    }).map(item => item.get)

  def updateTransactionCursor(itemId: UUID, cursor: Option[String]): Try[Unit] =
    Try(DB autoCommit { implicit session =>
      sql"""UPDATE plaid_items SET transactions_cursor = ${cursor} WHERE id = ${itemId}""".update
        .apply()
    })
