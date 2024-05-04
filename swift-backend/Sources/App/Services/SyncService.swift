@preconcurrency import Fluent
import Plaid
import Vapor

struct SyncService {
    let plaid: PlaidClient
    let plaidItemService: PlaidItemService
    let accountService: AccountService
    let transactionService: TransactionService

    // todo: move task to a persistent queue
    func syncTransactionsAndAccounts(itemID: UUID, logger: Logger) {
        Task {
            do {
                guard let item = try await plaidItemService.getByID(id: itemID) else {
                    logger.error(
                        "Cannot sync transactions. Failed to fetch item with id \(itemID)"
                    )
                    return
                }

                let batchSize = 100
                var cursor = item.transactionsCursor
                var hasMore = true
                var added: [Components.Schemas.Transaction] = []
                var updated: [Components.Schemas.Transaction] = []
                var removed: [Components.Schemas.RemovedTransaction] = []

                while hasMore {
                    let data = try await plaid.getTransactionsSync(
                        plaidItemID: item.plaidItemID,
                        accessToken: item.plaidAccessToken,
                        cursor: cursor,
                        count: batchSize
                    )

                    added.append(contentsOf: data.added)
                    updated.append(contentsOf: data.modified)
                    removed.append(contentsOf: data.removed)

                    hasMore = data.has_more
                    cursor = data.next_cursor
                }

                let accountsResponse = try await plaid.getAccounts(
                    accessToken: item.plaidAccessToken
                )
                try await accountService.upsertAccounts(
                    plaidItemID: item.plaidItemID,
                    accounts: accountsResponse.accounts
                )
                try await transactionService.upsertTransactions(
                    transactions: added + updated
                )
                try await transactionService.deleteTransactions(transactions: removed)
                guard let cursor = cursor else {
                    logger.error("Cursor is nil. Cannot update cursor.")
                    return
                }
                try await plaidItemService.updateCursor(
                    itemID: try item.requireID(),
                    cursor: cursor
                )

            }
            catch { print("Failed to sync plaid: \(String(reflecting: error))") }
        }
    }
}
