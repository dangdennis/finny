package api.repositories

import api.common.AppError
import api.models.Account
import api.models.AccountSimple
import api.models.PlaidItemId
import scalikejdbc.*

import java.util.UUID
import scala.util.Try
import api.models.UserId

object AccountRepository:
    case class UpsertAccountInput(
        itemId: UUID,
        userId: UUID,
        plaidAccountId: String,
        name: String,
        mask: Option[String],
        officialName: Option[String],
        currentBalance: Double,
        availableBalance: Double,
        isoCurrencyCode: Option[String],
        unofficialCurrencyCode: Option[String],
        accountType: Option[String],
        accountSubtype: Option[String]
    )

    def getByPlaidAccountId(itemId: UUID, plaidAccountId: String): Either[AppError.DatabaseError, AccountSimple] = Try(
        DB.readOnly { implicit session =>
            sql"""
            SELECT id, item_id, user_id, plaid_account_id FROM accounts WHERE item_id = $itemId and plaid_account_id = $plaidAccountId;
            """.map(rs =>
                    AccountSimple(
                        id = UUID.fromString(rs.string("id")),
                        itemId = UUID.fromString(rs.string("item_id")),
                        plaidAccountId = rs.string("plaid_account_id"),
                        userId = UUID.fromString(rs.string("user_id"))
                    )
                )
                .single
                .apply()
                .get
        }
    ).toEither.left.map(e => AppError.DatabaseError(e.getMessage()))

    def upsertAccount(input: UpsertAccountInput): Either[AppError.DatabaseError, UUID] = Try(
        DB.autoCommit { implicit session =>
            sql"""
        INSERT INTO accounts (item_id, user_id, plaid_account_id, name, mask, official_name, current_balance, available_balance, iso_currency_code, unofficial_currency_code, type, subtype)
        VALUES (${input.itemId}, ${input.userId}, ${input.plaidAccountId}, ${input.name}, ${input.mask}, ${input
                    .officialName}, ${input.currentBalance}, ${input.availableBalance}, ${input
                    .isoCurrencyCode}, ${input.unofficialCurrencyCode}, ${input.accountType}, ${input.accountSubtype})
        ON CONFLICT (plaid_account_id) DO UPDATE SET
          available_balance = EXCLUDED.available_balance,
          current_balance = EXCLUDED.current_balance
        RETURNING id;
        """.map(rs => UUID.fromString(rs.string("id"))).single.apply().get
        }
    ).toEither.left.map(e => AppError.DatabaseError(e.getMessage()))

    def getAccounts(userId: UUID): Either[AppError, List[Account]] = Try(
        DB.readOnly { implicit session =>
            sql"""
          SELECT
            id,
            item_id,
            user_id,
            plaid_account_id,
            name,
            mask,
            official_name,
            current_balance,
            available_balance,
            iso_currency_code,
            unofficial_currency_code,
            type,
            subtype,
            created_at,
            updated_at,
            deleted_at
          FROM
            accounts
          WHERE
            user_id = ${userId}
            and deleted_at is null;
          """.map(rs =>
                    Account(
                        id = UUID.fromString(rs.string("id")),
                        itemId = UUID.fromString(rs.string("item_id")),
                        userId = UUID.fromString(rs.string("user_id")),
                        plaidAccountId = rs.string("plaid_account_id"),
                        name = rs.string("name"),
                        mask = rs.stringOpt("mask"),
                        officialName = rs.stringOpt("official_name"),
                        currentBalance = rs.double("current_balance"),
                        availableBalance = rs.double("available_balance"),
                        isoCurrencyCode = rs.stringOpt("iso_currency_code"),
                        unofficialCurrencyCode = rs.stringOpt("unofficial_currency_code"),
                        accountType = rs.stringOpt("type"),
                        accountSubtype = rs.stringOpt("subtype"),
                        createdAt = rs.timestamp("created_at").toInstant
                    )
                )
                .list
                .apply()
        }
    ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage()))

    def getAccountsByItemId(itemId: PlaidItemId, userId: UserId): Either[AppError, List[Account]] = Try(
        DB.readOnly { implicit session =>
            sql"""
          SELECT
            id,
            item_id,
            user_id,
            plaid_account_id,
            name,
            mask,
            official_name,
            current_balance,
            available_balance,
            iso_currency_code,
            unofficial_currency_code,
            type,
            subtype,
            created_at,
            updated_at,
            deleted_at
          FROM
            accounts
          WHERE
            item_id = ${itemId}
            and user_id = ${userId}
            and deleted_at is null;
          """.map(rs =>
                    Account(
                        id = UUID.fromString(rs.string("id")),
                        itemId = UUID.fromString(rs.string("item_id")),
                        userId = UUID.fromString(rs.string("user_id")),
                        plaidAccountId = rs.string("plaid_account_id"),
                        name = rs.string("name"),
                        mask = rs.stringOpt("mask"),
                        officialName = rs.stringOpt("official_name"),
                        currentBalance = rs.double("current_balance"),
                        availableBalance = rs.double("available_balance"),
                        isoCurrencyCode = rs.stringOpt("iso_currency_code"),
                        unofficialCurrencyCode = rs.stringOpt("unofficial_currency_code"),
                        accountType = rs.stringOpt("type"),
                        accountSubtype = rs.stringOpt("subtype"),
                        createdAt = rs.timestamp("created_at").toInstant
                    )
                )
                .list
                .apply()
        }
    ).toEither.left.map(ex => AppError.DatabaseError(ex.getMessage()))

    def deleteAccountsByItemId(itemId: PlaidItemId, userId: UserId)(using session: DBSession): Either[Throwable, Int] =
        Try(sql"""DELETE FROM accounts WHERE item_id = ${itemId} and user_id = ${userId}""".update.apply()).toEither
