@preconcurrency import Fluent
import Plaid
import Vapor

struct AccountService {
    let db: Database
    let plaidItemService: PlaidItemService

    func getAccounts(userID: UUID) async throws -> [Account] {
        return try await Account.query(on: db).filter(\.$user.$id == userID).all()
    }

    func getByPlaidAccountID(plaidAccountID: String) async throws -> Account? {
        return try await Account.query(on: db).filter(\.$plaidAccountID == plaidAccountID)
            .first()
    }

    func upsertAccounts(
        plaidItemID: String,
        accounts: [Components.Schemas.AccountBase]
    ) async throws {
        let plaidItem = try await plaidItemService.getByPlaidItemID(
            plaidItemID: plaidItemID
        )
        guard let plaidItemID = plaidItem?.id else {
            throw Abort(
                .notFound,
                reason: "Plaid item not found. Fail to upsert accounts."
            )
        }
        for plaidAcct in accounts {
            do {
                let existingAccount = try await Account.query(on: db).filter(
                    \.$plaidAccountID == plaidAcct.account_id
                ).filter(\.$item.$id == plaidItemID).first()

                if let existingAccount = existingAccount {
                    existingAccount.currentBalance = 5
                    existingAccount.availableBalance = plaidAcct.balances.available ?? 0.0
                    try await existingAccount.save(on: db)
                }
                else {
                    let account = Account(
                        itemID: plaidItemID,
                        userID: plaidItem!.$user.id,
                        plaidAccountID: plaidAcct.account_id,
                        name: plaidAcct.name,
                        mask: plaidAcct.mask,
                        officialName: plaidAcct.official_name,
                        currentBalance: 5,
                        availableBalance: plaidAcct.balances.available ?? 0.0,
                        isoCurrencyCode: plaidAcct.balances.iso_currency_code,
                        unofficialCurrencyCode: plaidAcct.balances
                            .unofficial_currency_code,
                        type: plaidAcct._type.rawValue,
                        subtype: plaidAcct.subtype?.rawValue
                    )
                    try await account.save(on: db)
                }
            }
            catch { debugPrint("Error: \(error)") }
        }
    }
}
