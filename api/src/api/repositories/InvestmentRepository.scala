package api.repositories

import api.models.InvestmentHolding
import api.models.SecurityType
import scalikejdbc.*

import java.time.{Instant, LocalDate}
import java.util.UUID
import scala.util.Try
import api.models.InvestmentSecurity
import api.common.Logger

object InvestmentRepository:
    case class InvestmentHoldingInput(
        accountId: UUID,
        investmentSecurityId: UUID,
        institutionPrice: Double,
        institutionPriceAsOf: Option[LocalDate],
        institutionPriceDateTime: Option[Instant],
        institutionValue: Double,
        costBasis: Option[Double],
        quantity: Double,
        isoCurrencyCode: Option[String],
        unofficialCurrencyCode: Option[String],
        vestedValue: Option[Double]
    )

    def getInvestmentSecurityByPlaidSecurityId(plaidSecurityId: String): Either[Throwable, Option[InvestmentSecurity]] =
        Try(
            DB readOnly { implicit session =>
                sql"""
                SELECT 
                    id,
                    plaid_security_id,
                    plaid_institution_security_id,
                    plaid_institution_id,
                    plaid_proxy_security_id,
                    name,
                    ticker_symbol,
                    security_type
                FROM investment_securities
                WHERE plaid_security_id = $plaidSecurityId
                """.map(rs =>
                        InvestmentSecurity(
                            id = UUID.fromString(rs.string("id")),
                            plaidSecurityId = rs.string("plaid_security_id"),
                            plaidInstitutionSecurityId = rs.stringOpt("plaid_institution_security_id"),
                            plaidInstitutionId = rs.stringOpt("plaid_institution_id"),
                            plaidProxySecurityId = rs.stringOpt("plaid_proxy_security_id"),
                            name = rs.stringOpt("name"),
                            tickerSymbol = rs.stringOpt("ticker_symbol"),
                            securityType = rs
                                .stringOpt("security_type")
                                .flatMap(securityType =>
                                    SecurityType.fromString(securityType) match
                                        case Right(securityType) =>
                                            Some(securityType)
                                        case Left(_) =>
                                            Logger.root.error(s"Invalid security type: $securityType")
                                            None
                                ),
                            createdAt = rs.timestamp("created_at").toInstant,
                            updatedAt = rs.timestamp("updated_at").toInstant,
                            deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
                        )
                    )
                    .single
                    .apply()
            }
        ).toEither

    def getInvestmentHoldings(accountId: UUID): Either[Throwable, List[InvestmentHolding]] =
        Try(
            DB readOnly { implicit session =>
                sql"""
                SELECT
                    id,
                    account_id,
                    investment_security_id,
                    institution_price,
                    institution_price_as_of,
                    institution_price_date_time,
                    institution_value,
                    cost_basis,
                    quantity,
                    iso_currency_code,
                    unofficial_currency_code,
                    vested_value,
                    created_at,
                    updated_at,
                    deleted_at
                FROM investment_holdings
                WHERE account_id = $accountId
            """.map(rs =>
                        InvestmentHolding(
                            id = UUID.fromString(rs.string("id")),
                            accountId = UUID.fromString(rs.string("account_id")),
                            investmentSecurityId = rs.string("investment_security_id"),
                            institutionPrice = rs.double("institution_price"),
                            institutionPriceAsOf = rs.timestampOpt("institution_price_as_of").map(_.toInstant),
                            institutionPriceDateTime = rs.timestampOpt("institution_price_date_time").map(_.toInstant),
                            institutionValue = rs.double("institution_value"),
                            costBasis = rs.doubleOpt("cost_basis"),
                            quantity = rs.double("quantity"),
                            isoCurrencyCode = rs.stringOpt("iso_currency_code"),
                            unofficialCurrencyCode = rs.stringOpt("unofficial_currency_code"),
                            vestedValue = rs.doubleOpt("vested_value"),
                            createdAt = rs.timestamp("created_at").toInstant,
                            updatedAt = rs.timestamp("updated_at").toInstant,
                            deletedAt = rs.timestampOpt("deleted_at").map(_.toInstant)
                        )
                    )
                    .list
                    .apply()
            }
        ).toEither

    def upsertInvestmentHoldings(input: InvestmentHoldingInput): Either[Throwable, UUID] =
        Try(
            DB autoCommit { implicit session =>
                sql"""
                INSERT INTO investment_holdings (
                    account_id,
                    investment_security_id,
                    institution_price,
                    institution_price_as_of,
                    institution_price_date_time,
                    institution_value,
                    cost_basis,
                    quantity,
                    iso_currency_code,
                    unofficial_currency_code,
                    vested_value
                ) VALUES (
                    ${input.accountId},
                    ${input.investmentSecurityId},
                    ${input.institutionPrice},
                    ${input.institutionPriceAsOf},
                    ${input.institutionPriceDateTime},
                    ${input.institutionValue},
                    ${input.costBasis},
                    ${input.quantity},
                    ${input.isoCurrencyCode},
                    ${input.unofficialCurrencyCode},
                    ${input.vestedValue}
                )
                ON CONFLICT (account_id, investment_security_id) DO UPDATE SET
                    institution_price = EXCLUDED.institution_price,
                    institution_price_as_of = EXCLUDED.institution_price_as_of,
                    institution_price_date_time = EXCLUDED.institution_price_date_time,
                    institution_value = EXCLUDED.institution_value,
                    cost_basis = EXCLUDED.cost_basis,
                    quantity = EXCLUDED.quantity,
                    iso_currency_code = EXCLUDED.iso_currency_code,
                    unofficial_currency_code = EXCLUDED.unofficial_currency_code,
                    vested_value = EXCLUDED.vested_value
                RETURNING id
            """.map(rs => UUID.fromString(rs.string("id"))).single.apply().get
            }
        ).toEither

    case class InvestmentSecurityInput(
        plaidSecurityId: String,
        plaidInstitutionSecurityId: Option[String],
        plaidInstitutionId: Option[String],
        plaidProxySecurityId: Option[String],
        name: Option[String],
        tickerSymbol: Option[String],
        securityType: Option[SecurityType]
    )

    def upsertInvestmentSecurity(input: InvestmentSecurityInput): Either[Throwable, UUID] =
        Try(
            DB autoCommit { implicit session =>
                sql"""
                INSERT INTO investment_securities (
                    plaid_security_id,
                    plaid_institution_security_id,
                    plaid_institution_id,
                    plaid_proxy_security_id,
                    name,
                    ticker_symbol,
                    security_type
                ) VALUES (
                    ${input.plaidSecurityId},
                    ${input.plaidInstitutionSecurityId},
                    ${input.plaidInstitutionId},
                    ${input.plaidProxySecurityId},
                    ${input.name},
                    ${input.tickerSymbol},
                    ${input.securityType.map(SecurityType.toString)}
                )
                ON CONFLICT (plaid_security_id) DO UPDATE SET
                    plaid_institution_security_id = EXCLUDED.plaid_institution_security_id,
                    plaid_institution_id = EXCLUDED.plaid_institution_id,
                    plaid_proxy_security_id = EXCLUDED.plaid_proxy_security_id,
                    name = EXCLUDED.name,
                    ticker_symbol = EXCLUDED.ticker_symbol,
                    security_type = EXCLUDED.security_type
                RETURNING id
            """.map(rs => UUID.fromString(rs.string("id"))).single.apply().get
            }
        ).toEither
