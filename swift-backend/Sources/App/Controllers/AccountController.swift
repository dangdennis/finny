import Vapor

struct AccountController {
    let accountService: AccountService

    func listAccounts(req: Request) async throws -> ListAccountsResponse {
        let userID = try Auth.getUserID(from: req)
        let accounts = try await accountService.getAccounts(userID: userID)
        return ListAccountsResponse(
            data: accounts.map { account in
                Account.DTO(
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
        )
    }
}

extension Account {
    struct DTO: Content {
        let id: UUID
        let itemID: UUID
        let name: String
        let officialName: String?
        let mask: String?
        let currentBalance: Double
        let availableBalance: Double
        let isoCurrencyCode: String?
        let type: String?
        let subtype: String?
    }

}

extension AccountController {
    struct ListAccountsResponse: DataContaining { let data: [Account.DTO] }

}
