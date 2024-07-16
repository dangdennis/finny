package app.repositories

import app.models.PlaidItem
import app.models.PlaidItemStatus
import scalikejdbc.*

import java.time.Duration
import java.time.Instant
import java.util.UUID
import scala.util.Try

object PlaidItemRepository:
    def getById(id: UUID) =
        Try(DB readOnly { implicit session =>
            sql"""
        select
          id,
          user_id,
          plaid_access_token,
          plaid_item_id,
          plaid_institution_id,
          status,
          transactions_cursor,
          created_at,
          last_synced_at,
          last_sync_error,
          last_sync_error_at,
          retry_count
        from
          plaid_items
        where
          id = ${id}"""
                .map(dbToModel)
                .single
                .apply()
                .get
        }).toEither

    def getByItemId(itemId: String): Try[PlaidItem] =
        Try(DB readOnly { implicit session =>
            sql"""
          select
            id,
            user_id,
            plaid_access_token,
            plaid_item_id,
            plaid_institution_id,
            status,
            transactions_cursor,
            created_at,
            last_synced_at,
            last_sync_error,
            last_sync_error_at,
            retry_count
          from
              plaid_items
          where
              plaid_item_id = ${itemId}"""
                .map(dbToModel)
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

    def getOrCreateItem(input: CreateItemInput): Either[Throwable, PlaidItem] =
        Try(DB autoCommit { implicit session =>
            val query =
                sql"""INSERT INTO plaid_items (user_id, plaid_access_token, plaid_item_id, plaid_institution_id, status, transactions_cursor)
        VALUES (${input.userId}, ${input.plaidAccessToken}, ${input.plaidItemId}, ${input.plaidInstitutionId}, ${input.status
                        .toString()}, ${input.transactionsCursor})
        ON CONFLICT (plaid_item_id) DO UPDATE SET
          status = EXCLUDED.status,
          plaid_access_token = EXCLUDED.plaid_access_token
        RETURNING
          id,
          user_id,
          plaid_access_token,
          plaid_item_id,
          plaid_institution_id,
          status,
          transactions_cursor,
          created_at,
          last_synced_at,
          last_sync_error,
          last_sync_error_at,
          retry_count
        ;
        """
            query
                .map(dbToModel)
                .single
                .apply()
        }).map(item => item.get).toEither

    /// Returns items with sync times older than 12 hours
    def getItemsPendingSync(now: Instant): Try[List[PlaidItem]] =
        val threshold = now.minus(Duration.ofHours(12))
        Try(
            DB readOnly { implicit session =>
                sql"""
            select
              id,
              user_id,
              plaid_access_token,
              plaid_item_id,
              plaid_institution_id,
              status,
              transactions_cursor,
              created_at,
              last_synced_at,
              last_sync_error,
              last_sync_error_at,
              retry_count
            from
              plaid_items
            where
		      last_synced_at is null or last_synced_at <= ${threshold}
		      and status = 'good'
              and retry_count < 5
           """
                    .map(dbToModel)
                    .list
                    .apply()
            }
        )

    def updateTransactionCursor(itemId: UUID, cursor: Option[String]): Try[Unit] =
        Try(DB autoCommit { implicit session =>
            sql"""UPDATE plaid_items SET transactions_cursor = ${cursor} WHERE id = ${itemId}""".update
                .apply()
        })

    def updateSyncSuccess(itemId: UUID, currentTime: Instant): Either[Throwable, Int] =
        Try(DB autoCommit { implicit session =>
            sql"""
           UPDATE plaid_items
           SET
              last_synced_at = ${currentTime},
              last_sync_error = NULL,
              last_sync_error_at = NULL,
              retry_count = 0
           WHERE
              id = ${itemId}""".update
                .apply()
        }).toEither

    def updateSyncError(itemId: UUID, error: String, currentTime: Instant): Either[Throwable, Int] =
        Try(DB autoCommit { implicit session =>
            sql"""
           UPDATE plaid_items
           SET
              last_sync_error = ${error},
              last_sync_error_at = ${currentTime},
              retry_count = retry_count + 1
           WHERE
              id = ${itemId}""".update
                .apply()
        }).toEither

    def getItems(): Either[Throwable, List[PlaidItem]] =
        Try(DB readOnly { implicit session =>
            sql"""
          select
            id,
            user_id,
            plaid_access_token,
            plaid_item_id,
            plaid_institution_id,
            status,
            transactions_cursor,
            created_at,
            last_synced_at,
            last_sync_error,
            last_sync_error_at,
            retry_count
          from
              plaid_items
          """
                .map(dbToModel)
                .list
                .apply()
        }).toEither

    def deleteItem(itemId: UUID)(implicit session: DBSession): Either[Throwable, Int] =
        Try(sql"""DELETE FROM plaid_items WHERE id = ${itemId}""".update.apply()).toEither

    private def dbToModel(rs: WrappedResultSet) =
        PlaidItem(
            id = UUID.fromString(rs.string("id")),
            createdAt = rs.timestamp("created_at").toInstant,
            plaidAccessToken = rs.string("plaid_access_token"),
            plaidInstitutionId = rs.string("plaid_institution_id"),
            plaidItemId = rs.string("plaid_item_id"),
            status = PlaidItemStatus.fromString(rs.string("status")),
            transactionsCursor = rs.stringOpt("transactions_cursor"),
            userId = UUID.fromString(rs.string("user_id")),
            lastSyncedAt = rs.timestampOpt("last_synced_at").map(_.toInstant),
            lastSyncError = rs.stringOpt("last_sync_error"),
            lastSyncErrorAt = rs.timestampOpt("last_sync_error_at").map(_.toInstant),
            retryCount = rs.int("retry_count")
        )
