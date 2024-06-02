import APISchema
import Vapor

struct AccountController {
    let accountService: AccountService

    func listAccounts(req: Request) async throws -> ListAccountsResponse {
        let userID = try Auth.getUserID(from: req)
        let accounts = try await accountService.getAccounts(userID: userID)
        let accountDtos = accounts.map { account in
            APISchema.AccountDTO(
                id: account.id!,
                itemID: account.$item.id,
                name: account.name,
                officialName: account.officialName,
                mask: account.mask,
                currentBalance: account.currentBalance ?? 0,
                availableBalance: account.availableBalance ?? 0,
                isoCurrencyCode: account.isoCurrencyCode,
                type: account.type,
                subtype: account.subtype
            )
        }

        return .init(
            data: accountDtos
        )
    }
}
