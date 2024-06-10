package app.repositories

import app.models.PlaidItem
import app.models.User
import scalikejdbc._

import java.util.UUID
import scala.util.Try

object PlaidItemRepository:
  def createItem(user: User): Try[Boolean] =
    val testItem = PlaidItem(
      id = "1",
      userId = "1",
      plaidAccessToken = "access-token",
      plaidItemId = "item-id",
      plaidInstitutionId = "institution-id",
      status = "status",
      transactionsCursor = None
    )
    val result = Try(DB autoCommit { implicit session =>
      sql"""insert into plaid_items (user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor)
              values (${UUID.fromString(
          user.id
        )}, ${testItem.plaidAccessToken}, ${testItem.plaidItemId}, ${testItem.plaidInstitutionId}, ${testItem.status}, ${testItem.transactionsCursor});
        """.execute
        .apply()
    })

    result
