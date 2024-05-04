@preconcurrency import Fluent
import Plaid
import Vapor

struct AccountService {
    let db: Database
    let plaidItemService: PlaidItemService

    func upsertAccounts(
        plaidItemId: String,
        accounts: [Components.Schemas.AccountBase]
    ) async throws {
        let plaidItem = try await plaidItemService.getByPlaidItemId(plaidItemId: plaidItemId)
        guard let plaidItemId = plaidItem?.id else {
            throw Abort(.notFound, reason: "Plaid item not found. Fail to upsert accounts.")
        }
        try await db.transaction { tx in
            for plaidAcct in accounts {
                let account = Account(
                    itemId: plaidItemId,
                    plaidAccountId: plaidAcct.account_id,
                    name: plaidAcct.name,
                    mask: plaidAcct.mask,
                    officialName: plaidAcct.official_name,
                    currentBalance: plaidAcct.balances.current.map { Decimal($0) },
                    availableBalance: plaidAcct.balances.available.map { Decimal($0) },
                    isoCurrencyCode: plaidAcct.balances.iso_currency_code,
                    unofficialCurrencyCode: plaidAcct.balances.unofficial_currency_code,
                    type: plaidAcct._type.rawValue,
                    subtype: plaidAcct.subtype?.rawValue
                )
                try await account.save(on: tx)
            }
        }
    }
}
