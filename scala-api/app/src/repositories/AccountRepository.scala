package app.repositories

import app.models.Account
import scalikejdbc._

import java.util.UUID
import scala.util.Try

object AccountRepository:
  case class CreateAccountInput(
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

  def upsertAccount(input: CreateAccountInput): Try[Account] =
    val acct = Try(DB autoCommit { implicit session =>
      val id =
        sql"""
        INSERT INTO accounts (item_id, user_id, plaid_account_id, name, mask, official_name, current_balance, available_balance, iso_currency_code, unofficial_currency_code, account_type, account_subtype)
        VALUES (${input.userId}, ${input.plaidAccountId}, ${input.name}, ${input.mask}, ${input.officialName}, ${input.currentBalance}, EXCLUDED.available_balance ${input.isoCurrencyCode}, ${input.unofficialCurrencyCode}, ${input.accountType}, ${input.accountSubtype})
        ON CONFLICT (plaid_account_id) DO UPDATE SET
          available_balance = EXCLUDED.available_balance,
          current_balance = EXCLUDED.current_balance
        RETURNING id;
        """
          .map(_.toString())
          .single
          .apply()
          .get

      val account = sql"""
        SELECT
         	id,
         	user_id,
         	plaid_account_id,
         	name,
         	mask,
         	official_name,
         	current_balance,
         	available_balance,
         	iso_currency_code,
         	unofficial_currency_code,
         	account_type,
         	account_subtype,
         	created_at,
         	updated_at,
         	deleted_at
        FROM
          accounts
        WHERE
          id = $id
          and deleted_at is null;
        """
        .map(rs =>
          Account(
            id = UUID.fromString(rs.string("id")),
            userId = UUID.fromString(rs.string("user_id")),
            plaidAccountId = UUID.fromString(rs.string("plaid_account_id")),
            name = rs.string("name"),
            mask = rs.stringOpt("mask"),
            officialName = rs.stringOpt("official_name"),
            currentBalance = rs.double("current_balance"),
            availableBalance = rs.double("available_balance"),
            isoCurrencyCode = rs.stringOpt("iso_currency_code"),
            unofficialCurrencyCode = rs.stringOpt("unofficial_currency_code"),
            accountType = rs.stringOpt("account_type"),
            accountSubtype = rs.stringOpt("account_subtype"),
            createdAt = rs.timestamp("created_at").toInstant
          )
        )
        .single
        .apply()
        .get
      account
    })

    acct
