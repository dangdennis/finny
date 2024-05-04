import Vapor

struct TransactionController {
    let transactionService: TransactionService

    func listTransactions(req: Request) async throws -> ListTransactionsResponse {
        let userID = try Auth.getUserID(from: req)
        let transactions = try await transactionService.getTransactions(userID: userID)
        return ListTransactionsResponse(
            data: transactions.map { transaction in
                Transaction.DTO(
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

extension Transaction {
    struct DTO: Content {
        let id: UUID
        let accountID: UUID
        let plaidTransactionID: String
        let category: String?
        let subcategory: String?
        let type: String
        let name: String
        let amount: Double
        let isoCurrencyCode: String?
        let unofficialCurrencyCode: String?
        let date: Date
        let pending: Bool
        let accountOwner: String?
    }
}

extension TransactionController {
    struct ListTransactionsResponse: DataContaining { let data: [Transaction.DTO] }

}
