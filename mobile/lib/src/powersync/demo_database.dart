// to regenerate demo_database.g.dart run:
// dart run build_runner build
// dart run build_runner watch

import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'demo_database.g.dart';

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
class DemoAppDatabase extends _$DemoAppDatabase {
  DemoAppDatabase() : super(_openDemoDatabase());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openDemoDatabase() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'demo_db.sqlite'));
    return NativeDatabase(file);
  });
}
