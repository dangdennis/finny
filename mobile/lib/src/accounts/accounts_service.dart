import 'package:drift/drift.dart';
import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:logging/logging.dart';

class AccountsService {
  AccountsService({required this.appDb});

  final Logger _logger = Logger('AccountsService');
  final AppDatabase appDb;

  Stream<List<Account>> watchAccounts() {
    return (appDb.select(appDb.accountsDb)
          ..orderBy([(a) => OrderingTerm(expression: a.createdAt)]))
        .watch()
        .map((rows) => rows.map(dbToDomain).toList());
  }

  Future<List<Account>> getAccounts(GetAccountsInput? input) async {
    try {
      final query = appDb.select(appDb.accountsDb);
      if (input?.accountIds != null) {
        query.where((tbl) => tbl.id.isIn(input!.accountIds!));
      }
      final accounts = await query.get();
      return accounts.map(dbToDomain).toList();
    } catch (e, stacktrace) {
      _logger.severe('Failed to load accounts', e, stacktrace);
      rethrow;
    }
  }

  Account dbToDomain(AccountsDbData dbData) {
    return Account(
      id: dbData.id,
      itemId: dbData.itemId,
      userId: dbData.userId,
      name: dbData.name,
      mask: dbData.mask,
      officialName: dbData.officialName,
      currentBalance: dbData.currentBalance,
      availableBalance: dbData.availableBalance,
      isoCurrencyCode: dbData.isoCurrencyCode,
      unofficialCurrencyCode: dbData.unofficialCurrencyCode,
      type: dbData.type,
      subtype: dbData.subtype,
      createdAt: dbData.createdAt,
      updatedAt: dbData.updatedAt,
      deletedAt: dbData.deletedAt,
    );
  }
}

class GetAccountsInput {
  GetAccountsInput({
    this.accountIds,
  });

  final List<String>? accountIds;
}
