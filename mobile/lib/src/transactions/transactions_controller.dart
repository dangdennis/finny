import 'package:finny/src/powersync/powersync.dart';
import 'package:finny/src/transactions/transaction_model.dart';
import 'package:logging/logging.dart';
import 'package:powersync/sqlite3.dart';

class TransactionsController {
  final Logger _logger = Logger('TransactionsController');

  Future<List<Transaction>> getTransactions() async {
    try {
      ResultSet transactions = await powersyncDb
          .getAll('SELECT * FROM transactions order by DATE(date) desc;');
      return transactions.map((row) {
        return Transaction(
          id: row['id'],
          accountId: row['account_id'],
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
    } catch (e) {
      _logger.severe('Error getting transactions: $e');
      return [];
    }
  }
}
