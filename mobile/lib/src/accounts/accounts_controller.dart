import 'package:finny/src/accounts/account.dart';
import 'package:finny/src/powersync.dart';
import 'package:powersync/sqlite3.dart';

class AccountsController {
  Future<List<Account>> loadAccounts() async {
    ResultSet accounts = await db.getAll('SELECT * FROM accounts;');
    print("accounts list $accounts");

    return accounts.map((row) {
      return Account(
        id: row['id'],
        itemId: row['item_id'],
        userId: row['user_id'],
        plaidAccountId: row['plaid_account_id'],
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
