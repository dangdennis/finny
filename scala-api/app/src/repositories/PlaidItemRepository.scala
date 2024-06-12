package app.repositories

import app.models.{PlaidItem, PlaidItemStatus}
import scalikejdbc._

import scala.util.Try
import java.util.UUID

object PlaidItemRepository:
  case class CreateItemInput(
      userId: UUID,
      plaidAccessToken: String,
      plaidItemId: String,
      plaidInstitutionId: String,
      status: PlaidItemStatus,
      transactionsCursor: Option[String]
  )

  def createItem(input: CreateItemInput): Try[PlaidItem] =
    val item = Try(DB autoCommit { implicit session =>
      val id = sql"""insert into plaid_items (user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor)
              values (${input.userId}, ${input.plaidAccessToken}, ${input.plaidItemId}, ${input.plaidInstitutionId}, ${input.status}, ${input.transactionsCursor})
            returning id;
        """
        .map(_.toString())
        .single
        .apply()
        .get

      sql"""select id, user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor, created_at from plaid_items where id = ${id}"""
        .map(rs =>
          PlaidItem(
            id = rs.string("id"),
            userId = rs.string("user_id"),
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

    item
