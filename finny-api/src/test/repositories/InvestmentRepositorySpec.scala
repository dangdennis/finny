package test.repositories

import api.common.Time
import api.common.Time.*
import api.models.PlaidItemStatus
import api.models.SecurityType
import api.repositories.AccountRepository
import api.repositories.AccountRepository.UpsertAccountInput
import api.repositories.InvestmentRepository
import api.repositories.PlaidItemRepository
import api.repositories.PlaidItemRepository.CreateItemInput
import org.scalatest.BeforeAndAfterAll
import org.scalatest.BeforeAndAfterEach
import org.scalatest.EitherValues
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import test.helpers.*

import java.util.UUID

class InvestmentRepositorySpec
    extends AnyFlatSpec,
      Matchers,
      EitherValues,
      BeforeAndAfterAll,
      BeforeAndAfterEach:
  override protected def beforeAll(): Unit = TestHelper.beforeAll()
  override protected def afterEach(): Unit = TestHelper.afterEach()

  "upsertInvestmentHoldings" should "upsert investment holdings" in {
    // given
    val user = AuthServiceHelper.createUser()
    val item =
      PlaidItemRepository
        .getOrCreateItem(
          CreateItemInput(
            userId = user.id,
            plaidAccessToken = "somePlaid",
            plaidInstitutionId = "institutionId",
            plaidItemId = "somePlaidItemId",
            status = PlaidItemStatus.Bad,
            transactionsCursor = None
          )
        )
        .value

    val accountId =
      AccountRepository
        .upsertAccount(
          UpsertAccountInput(
            itemId = item.id.toUUID,
            userId = user.id,
            accountSubtype = Some("checking"),
            accountType = Some("depository"),
            availableBalance = 100.0,
            currentBalance = 100.0,
            isoCurrencyCode = Some("USD"),
            mask = Some("1234"),
            name = "Alice",
            officialName = Some("Alice's Checking"),
            plaidAccountId = "somePlaidAccountId",
            unofficialCurrencyCode = Some("USD")
          )
        )
        .value

    val plaidSecurityId = UUID.randomUUID().toString
    val investmentSecurityId =
      InvestmentRepository
        .upsertInvestmentSecurity(
          InvestmentRepository.InvestmentSecurityInput(
            plaidSecurityId = plaidSecurityId,
            plaidInstitutionSecurityId = Some("somePlaidInstitutionSecurityId"),
            plaidInstitutionId = Some("somePlaidInstitutionId"),
            plaidProxySecurityId = Some("somePlaidProxySecurityId"),
            name = Some("Some Security"),
            tickerSymbol = Some("SSEC"),
            securityType = Some(SecurityType.Equity)
          )
        )
        .value

    val security = InvestmentRepository
      .getInvestmentSecurityByPlaidSecurityId(plaidSecurityId)
      .value
    security should not be None

    // when
    val holdingId =
      InvestmentRepository
        .upsertInvestmentHoldings(
          InvestmentRepository.InvestmentHoldingInput(
            accountId = accountId,
            investmentSecurityId = investmentSecurityId,
            institutionPrice = 100.0,
            institutionPriceAsOf = Some(Time.now().toLocalDate()),
            institutionPriceDateTime = Some(Time.now()),
            institutionValue = 100.0,
            costBasis = Some(100.0),
            quantity = 100.0,
            isoCurrencyCode = Some("USD"),
            unofficialCurrencyCode = Some("USD"),
            vestedValue = Some(100.0)
          )
        )
        .value

    // then
    val holdings = InvestmentRepository.getInvestmentHoldings(accountId).value
    holdings should have size 1
  }
