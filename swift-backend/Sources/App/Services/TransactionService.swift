@preconcurrency import Fluent
import Plaid
import Vapor

struct TransactionService {
    let db: Database
    let accountService: AccountService

    func upsertTransactions(
        transactions: [Components.Schemas.Transaction]
    ) async throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        for transaction in transactions {
            let existingTransaction = try await Transaction.query(on: db)
                .filter(
                    \.$plaidTransactionId == transaction.value1.transaction_id
                ).first()

            if let existingTransaction = existingTransaction {
                existingTransaction.name =
                    transaction.value1.merchant_name ?? transaction.value1.name!
                existingTransaction.date = formatter.date(
                    from: transaction.value1.date
                )!
                existingTransaction.amount = Decimal(transaction.value1.amount)
                existingTransaction.isoCurrencyCode =
                    transaction.value1.iso_currency_code
                existingTransaction.unofficialCurrencyCode =
                    transaction.value1.unofficial_currency_code
                existingTransaction.pending = transaction.value1.pending
                existingTransaction.accountOwner =
                    transaction.value1.account_owner
                existingTransaction.type =
                    transaction.value2.payment_channel.rawValue
                existingTransaction.category =
                    transaction.value2.personal_finance_category?.primary
                existingTransaction.subcategory =
                    transaction.value2.personal_finance_category?.detailed
                try await existingTransaction.save(on: db)
            }
            else {
                let account = try await accountService.getByPlaidAccountId(
                    plaidAccountId: transaction.value1.account_id
                )
                guard let account = account else { continue }
                let newTransaction = Transaction(
                    accountId: try account.requireID(),
                    plaidTransactionId: transaction.value1.transaction_id,
                    category: transaction.value2.personal_finance_category?
                        .primary,
                    subcategory: transaction.value2.personal_finance_category?
                        .detailed,
                    type: transaction.value2.payment_channel.rawValue,
                    name: transaction.value1.merchant_name ?? transaction.value1
                        .name!,
                    amount: Decimal(transaction.value1.amount),
                    isoCurrencyCode: transaction.value1.iso_currency_code,
                    unofficialCurrencyCode: transaction.value1
                        .unofficial_currency_code,
                    date: formatter.date(from: transaction.value1.date)
                        ?? Date(),
                    pending: transaction.value1.pending,
                    accountOwner: transaction.value1.account_owner
                )
                try await newTransaction.save(on: db)
            }
        }
    }

    func deleteTransactions(
        transactions: [Components.Schemas.RemovedTransaction]
    ) async throws {
        let transactionIds = transactions.compactMap({ $0.transaction_id })
        try await Transaction.query(on: db).filter(
            \.$plaidTransactionId ~~ transactionIds
        ).delete()
    }
}
