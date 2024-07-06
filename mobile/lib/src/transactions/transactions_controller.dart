import 'package:finny/src/powersync.dart';
import 'package:finny/src/transactions/transaction.dart';
import 'package:powersync/sqlite3.dart';

class TransactionsController {
  Future<List<Transaction>> getTransactions() async {
    ResultSet transactions = await db.getAll('SELECT * FROM transactions;');
    print("transactions list $transactions");
    return transactions.map((row) {
      return Transaction(
        id: row['id'],
        accountId: row['account_id'],
        plaidTransactionId: row['plaid_transaction_id'],
        category: row['category'],
        subcategory: row['subcategory'],
        type: row['type'],
        name: row['name'],
        amount: row['amount'],
        isoCurrencyCode: row['iso_currency_code'],
        unofficialCurrencyCode: row['unofficial_currency_code'],
        date: row['date'],
        pending: row['pending'],
        accountOwner: row['account_owner'],
        createdAt: row['created_at'],
        updatedAt: row['updated_at'],
        deletedAt: row['deleted_at'],
      );
    }).toList();
  }
}
