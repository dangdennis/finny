import APISchema
import Vapor

struct TransactionController {
    let transactionService: TransactionService

    func listTransactions(req: Request) async throws -> ListTransactionsResponse {
        let userID = try Auth.getUserID(from: req)
        let transactions = try await transactionService.getTransactions(userID: userID)
        return .init(
            data: transactions.map { transaction in
                .init(
                    id: transaction.id!,
                    accountID: transaction.$account.id,
                    plaidTransactionID: transaction.plaidTransactionID,
                    category: transaction.category,
                    subcategory: transaction.subcategory,
                    type: transaction.type,
                    name: transaction.name,
                    amount: transaction.amount,
                    isoCurrencyCode: transaction.isoCurrencyCode,
                    unofficialCurrencyCode: transaction.unofficialCurrencyCode,
                    date: transaction.date,
                    pending: transaction.pending,
                    accountOwner: transaction.accountOwner
                )
            }
        )
    }
}
