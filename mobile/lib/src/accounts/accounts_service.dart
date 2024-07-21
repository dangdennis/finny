import 'package:finny/src/accounts/account.dart';
import 'package:finny/src/powersync/powersync.dart';
import 'package:powersync/sqlite3.dart';

class AccountsService {
  Future<List<Account>> loadAccounts() async {
    ResultSet accounts = await db.getAll('SELECT * FROM accounts;');

    return accounts.map((row) {
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
    }).toList();
  }
}
