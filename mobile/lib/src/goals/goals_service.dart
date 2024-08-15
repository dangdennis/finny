import 'package:drift/drift.dart';
import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:uuid/uuid.dart';

class GoalsService {
  GoalsService({required this.appDb});

  final AppDatabase appDb;

  Stream<Goal> watchGoal(String goalId) {
    return (appDb.select(appDb.goalsDb)..where((g) => g.id.equals(goalId)))
        .watchSingle()
        .map(goalDbToDomain);
  }

  Stream<List<Goal>> watchGoals() {
    return appDb
        .select(appDb.goalsDb)
        .watch()
        .map((event) => event.map(goalDbToDomain).toList());
  }

  Future<List<Goal>> getGoals() async {
    final goalsDbData = await (appDb.select(appDb.goalsDb)
          ..orderBy([(g) => OrderingTerm(expression: g.createdAt)]))
        .get();

    return goalsDbData.map(goalDbToDomain).toList();
  }

  Future<Goal> getGoal(String goalId) async {
    final goalDbData = await (appDb.select(appDb.goalsDb)
          ..where((g) => g.id.equals(goalId)))
        .getSingle();

    return goalDbToDomain(goalDbData);
  }

  Future<void> addGoal(AddGoalInput input) async {
    final String targetDateString =
        input.targetDate.toIso8601String().substring(0, 10);

    final goalCompanion = GoalsDbCompanion(
      id: Value(const Uuid().v4()),
      name: Value(input.name),
      amount: Value(input.amount),
      targetDate: Value(targetDateString),
      progress: const Value(0),
      userId: Value(const Uuid()
          .v4()), // random id because it will be replaced with the correct one. this makes drift happy.
      createdAt: Value(DateTime.now().toIso8601String()),
      updatedAt: Value(DateTime.now().toIso8601String()),
    );

    await appDb.into(appDb.goalsDb).insert(goalCompanion);
  }

  Future<void> updateGoal(Goal goal) async {
    final String targetDateString =
        goal.targetDate.toIso8601String().substring(0, 10);

    final goalCompanion = GoalsDbCompanion(
      id: Value(goal.id),
      name: Value(goal.name),
      amount: Value(goal.targetAmount),
      targetDate: Value(targetDateString),
      progress: Value(goal.progress ?? 0),
      updatedAt: Value(DateTime.now().toIso8601String()),
    );

    await (appDb.update(appDb.goalsDb)..where((tbl) => tbl.id.equals(goal.id)))
        .write(goalCompanion);
  }

  Future<void> deleteGoal(Goal goal) async {
    await (appDb.delete(appDb.goalsDb)..where((tbl) => tbl.id.equals(goal.id)))
        .go();
  }

  Future<void> assignOrUpdateGoalAccount(AssignAccountToGoalInput input) async {
    // Make sure the account cannot be allocated greater than 100% across all goals
    final allGoalAccountsOfAccount =
        await getGoalAccountsByAccountIdExceptCurrentGoal(
            input.accountId, input.goalId);

    double allocatedPercentage = allGoalAccountsOfAccount
        .map((e) => e.percentage)
        .fold(0, (previousValue, element) => previousValue + element);

    if (allocatedPercentage + input.percentage > 100) {
      throw Exception('The total percentage cannot exceed 100%');
    }

    final goalAccountData = await (appDb.select(appDb.goalAccountsDb)
          ..where((tbl) => tbl.goalId.equals(input.goalId))
          ..where((tbl) => tbl.accountId.equals(input.accountId)))
        .getSingleOrNull();

    // If the goal account already exists, update the percentage
    // Otherwise, insert the new goal account instead.
    // If the input percentage is 0, delete the goal account.
    if (goalAccountData != null) {
      final goalAccount = goalAccountDbToDomain(goalAccountData);

      if (input.percentage == 0) {
        return unassignAccount(
            goalId: goalAccount.goalId, accountId: goalAccount.accountId);
      }

      final goalAccountCompanion = GoalAccountsDbCompanion(
        percentage: Value(input.percentage.toString()),
      );

      await (appDb.update(appDb.goalAccountsDb)
            ..where((tbl) => tbl.id.equals(goalAccountData.id)))
          .write(goalAccountCompanion);
    } else {
      final goalAccountCompanion = GoalAccountsDbCompanion(
        id: Value(const Uuid().v4()),
        goalId: Value(input.goalId),
        accountId: Value(input.accountId),
        percentage: Value(input.percentage.toString()),
        amount: Value(0.toString()),
        createdAt: Value(DateTime.now().toIso8601String()),
        updatedAt: Value(DateTime.now().toIso8601String()),
      );

      await appDb.into(appDb.goalAccountsDb).insert(goalAccountCompanion);
    }
  }

  Future<void> unassignAccount(
      {required GoalId goalId, required AccountId accountId}) async {
    await (appDb.delete(appDb.goalAccountsDb)
          ..where((tbl) => tbl.goalId.equals(goalId))
          ..where((tbl) => tbl.accountId.equals(accountId)))
        .go();
  }

  Future<List<GoalAccount>> getGoalAccounts(GoalId goalId) async {
    final goalAccountsDbData = await (appDb.select(appDb.goalAccountsDb)
          ..where((tbl) => tbl.goalId.equals(goalId))
          ..orderBy([
            (g) =>
                OrderingTerm(expression: g.percentage, mode: OrderingMode.desc)
          ]))
        .get();

    return goalAccountsDbData.map(goalAccountDbToDomain).toList();
  }

  Future<List<GoalAccount>> getGoalAccountsByAccountIdExceptCurrentGoal(
      AccountId accountId, GoalId goalId) async {
    final goalAccountsDbData = await (appDb.select(appDb.goalAccountsDb)
          ..where((tbl) => tbl.accountId.equals(accountId))
          ..where((tbl) => tbl.goalId.isNotValue(goalId))
          ..orderBy([
            (g) =>
                OrderingTerm(expression: g.percentage, mode: OrderingMode.desc)
          ]))
        .get();

    return goalAccountsDbData.map(goalAccountDbToDomain).toList();
  }

  // Helper method to convert GoalsDbData to Goal domain model
  Goal goalDbToDomain(GoalsDbData dbData) {
    return Goal(
      id: dbData.id,
      name: dbData.name,
      targetAmount: dbData.amount,
      progress: dbData.progress,
      targetDate: DateTime.parse(dbData.targetDate),
    );
  }

  GoalAccount goalAccountDbToDomain(GoalAccountsDbData dbData) {
    return GoalAccount(
      id: dbData.id,
      goalId: dbData.goalId,
      accountId: dbData.accountId,
      percentage: double.parse(dbData.percentage),
    );
  }
}

class AddGoalInput {
  final String name;
  final double amount;
  final DateTime targetDate;

  AddGoalInput({
    required this.name,
    required this.amount,
    required this.targetDate,
  });
}

class AssignAccountToGoalInput {
  final String goalId;
  final String accountId;
  final double percentage;

  AssignAccountToGoalInput({
    required this.goalId,
    required this.accountId,
    required this.percentage,
  });
}
