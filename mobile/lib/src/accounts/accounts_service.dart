import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/powersync/powersync.dart';
import 'package:powersync/sqlite3.dart';
import 'package:logging/logging.dart';

class AccountsService {
  final Logger _logger = Logger('AccountsService');

  void getAccountsV2() async {
    // appDb.
  }

  Future<List<Account>> getAccounts() async {
    try {
      ResultSet accounts = await powersyncDb
          .getAll('SELECT * FROM accounts order by created_at asc');

      return accounts.map((row) {
        try {
          return Account(
            id: row['id'],
            itemId: row['item_id'],
            userId: row['user_id'],
            name: row['name'],
            mask: row['mask'],
            officialName: row['official_name'],
            currentBalance: row['current_balance'],
            availableBalance: row['available_balance'],
            isoCurrencyCode: row['iso_currency_code'],
            unofficialCurrencyCode: row['unofficial_currency_code'],
            type: row['type'],
            subtype: row['subtype'],
            createdAt: row['created_at'],
            updatedAt: row['updated_at'],
            deletedAt: row['deleted_at'],
          );
        } catch (e, stacktrace) {
          _logger.severe('Failed to map row: $row', e, stacktrace);
          rethrow;
        }
      }).toList();
    } catch (e, stacktrace) {
      _logger.severe('Failed to load accounts', e, stacktrace);
      rethrow;
    }
  }
}
