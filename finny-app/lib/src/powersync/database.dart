// to regenerate database.g.dart run:
// dart run build_runner build
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
    ProfilesDb,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(PowerSyncDatabase db) : super(SqliteAsyncDriftConnection(db));

  @override
  int get schemaVersion => 1;
}

class AccountsDb extends Table {
  @override
  String get tableName => 'accounts';

  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get mask => text().nullable()();
  TextColumn get officialName => text().nullable()();
  RealColumn get currentBalance => real()();
  RealColumn get availableBalance => real()();
  TextColumn get isoCurrencyCode => text().nullable()();
  TextColumn get unofficialCurrencyCode => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get subtype => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
}

class TransactionsDb extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get category => text()();
  TextColumn get subcategory => text().nullable()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get isoCurrencyCode => text().nullable()();
  TextColumn get unofficialCurrencyCode => text().nullable()();
  TextColumn get date => text()();
  IntColumn get pending => integer()();
  TextColumn get accountOwner => text().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
}

class InvestmentHoldingsDb extends Table {
  @override
  String get tableName => 'investment_holdings';

  TextColumn get id => text()();
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

  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get targetDate => text()();
  TextColumn get userId => text()();
  RealColumn get progress => real().nullable()();
  TextColumn get goalType => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
}

class GoalAccountsDb extends Table {
  @override
  String get tableName => 'goal_accounts';

  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get accountId => text()();
  TextColumn get amount => text()();
  TextColumn get percentage => text()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();
  TextColumn get deletedAt => text().nullable()();
}

class ProfilesDb extends Table {
  @override
  String get tableName => 'profiles';

  TextColumn get id => text()();
  TextColumn get dateOfBirth => text().nullable()();
  IntColumn get retirementAge => integer().nullable()();
  TextColumn get riskProfile => text().nullable()();
  TextColumn get fireProfile => text().nullable()();
}
