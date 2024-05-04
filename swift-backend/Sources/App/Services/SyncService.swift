@preconcurrency import Fluent
import Plaid
import Vapor

struct SyncService {
    let plaid: PlaidClient
    let plaidItemService: PlaidItemService
    let accountService: AccountService
    let transactionService: TransactionService

    // todo: move task to a persistent queue
    func syncTransactionsAndAccounts(itemId: UUID, logger: Logger) {
        Task {
            do {
                guard let item = try await plaidItemService.getById(id: itemId) else {
                    logger.error("Cannot sync transactions. Failed to fetch item with id \(itemId)")
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
                        plaidItemId: item.plaidItemId,
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
                    plaidItemId: item.plaidItemId,
                    accounts: accountsResponse.accounts
                )
                try await transactionService.upsertTransactions(transactions: added + updated)
                try await transactionService.deleteTransactions(transactions: removed)
                guard let cursor = cursor else {
                    logger.error("Cursor is nil. Cannot update cursor.")
                    return
                }
                try await plaidItemService.updateCursor(
                    itemId: try item.requireID(),
                    cursor: cursor
                )

            }
            catch { print("Failed to fetch transactions: \(error)") }
        }
    }
}
