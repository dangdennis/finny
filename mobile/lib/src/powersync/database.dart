// dart run build_runner build to regenerate database.g.dart
// dart run build_runner watch

import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:drift/drift.dart';
import 'package:powersync/powersync.dart' show PowerSyncDatabase;

part 'database.g.dart';

@DriftDatabase(
  tables: [
    AccountsDb,
    TransactionsDb,
    InvestmentHoldingsDb,
    GoalsDb,
    GoalAccountsDb,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(PowerSyncDatabase db) : super(SqliteAsyncDriftConnection(db));

  @override
  int get schemaVersion => 1;

  Stream<List<AccountsDbData>> watchAccounts() {
    return (select(accountsDb)
          ..orderBy([(a) => OrderingTerm(expression: a.createdAt)]))
        .watch();
  }
}

class AccountsDb extends Table {
  @override
  String get tableName => 'accounts';

  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get mask => text()();
  TextColumn get officialName => text()();
  RealColumn get currentBalance => real()();
  RealColumn get availableBalance => real()();
  TextColumn get isoCurrencyCode => text()();
  TextColumn get unofficialCurrencyCode => text().nullable()();
  TextColumn get type => text()();
  TextColumn get subtype => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
}

class TransactionsDb extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get accountId => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get name => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get isoCurrencyCode => text().nullable()();
  TextColumn get unofficialCurrencyCode => text().nullable()();
  TextColumn get date => text().nullable()();
  IntColumn get pending => integer().nullable()();
  TextColumn get accountOwner => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get updatedAt => text().nullable()();
  TextColumn get deletedAt => text().nullable()();
}

class InvestmentHoldingsDb extends Table {
  @override
  String get tableName => 'investment_holdings';

  TextColumn get accountId => text().nullable()();
  RealColumn get institutionPrice => real().nullable()();
  TextColumn get institutionPriceAsOf => text().nullable()();
  RealColumn get institutionValue => real().nullable()();
  RealColumn get costBasis => real().nullable()();
  RealColumn get quantity => real().nullable()();
  TextColumn get isoCurrencyCode => text().nullable()();
  RealColumn get vestedValue => real().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get updatedAt => text().nullable()();
  TextColumn get deletedAt => text().nullable()();
}

class GoalsDb extends Table {
  @override
  String get tableName => 'goals';

  TextColumn get name => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get targetDate => text().nullable()();
  TextColumn get userId => text().nullable()();
  RealColumn get progress => real().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get updatedAt => text().nullable()();
  TextColumn get deletedAt => text().nullable()();
}

class GoalAccountsDb extends Table {
  @override
  String get tableName => 'goal_accounts';

  TextColumn get goalId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get amount => text().nullable()();
  TextColumn get percentage => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get updatedAt => text().nullable()();
  TextColumn get deletedAt => text().nullable()();
}
