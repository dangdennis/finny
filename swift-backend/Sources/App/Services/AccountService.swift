@preconcurrency import Fluent
import Plaid
import Vapor

struct AccountService {
    let db: Database
    let plaidItemService: PlaidItemService

    func getByPlaidAccountId(plaidAccountId: String) async throws -> Account? {
        return try await Account.query(on: db).filter(\.$plaidAccountId == plaidAccountId).first()
    }

    func upsertAccounts(
        plaidItemId: String,
        accounts: [Components.Schemas.AccountBase]
    ) async throws {
        let plaidItem = try await plaidItemService.getByPlaidItemId(plaidItemId: plaidItemId)
        guard let plaidItemId = plaidItem?.id else {
            throw Abort(.notFound, reason: "Plaid item not found. Fail to upsert accounts.")
        }
        for plaidAcct in accounts {
            let existingAccount = try await Account.query(on: db).filter(
                \.$plaidAccountId == plaidAcct.account_id
            ).filter(\.$item.$id == plaidItemId).first()

            if let existingAccount = existingAccount {
                existingAccount.currentBalance = plaidAcct.balances.current.map { Decimal($0) }
                existingAccount.availableBalance = plaidAcct.balances.available.map { Decimal($0) }
                try await existingAccount.save(on: db)
            }
            else {
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
                try await account.save(on: db)
            }
        }
    }
}
