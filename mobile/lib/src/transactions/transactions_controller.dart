import 'package:drift/drift.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:finny/src/transactions/transaction_model.dart';

class TransactionsController {
  TransactionsController({required this.appDb});

  final AppDatabase appDb;

  Stream<List<Transaction>> watchTransactions() {
    return (appDb.select(appDb.transactionsDb)
          ..orderBy([
            (a) =>
                OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((rows) => rows.map(dbToDomain).toList());
  }

  Transaction dbToDomain(TransactionsDbData dbData) {
    return Transaction(
      id: dbData.id,
      accountId: dbData.accountId,
      category: dbData.category,
      subcategory: dbData.subcategory,
      type: dbData.type,
      name: dbData.name,
      amount: dbData.amount,
      isoCurrencyCode: dbData.isoCurrencyCode,
      unofficialCurrencyCode: dbData.unofficialCurrencyCode,
      date: dbData.date,
      pending: dbData.pending,
      accountOwner: dbData.accountOwner,
      createdAt: dbData.createdAt,
      updatedAt: dbData.updatedAt,
      deletedAt: dbData.deletedAt,
    );
  }
}
