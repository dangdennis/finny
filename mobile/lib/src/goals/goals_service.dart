import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:powersync/powersync.dart';
import 'package:uuid/uuid.dart';

class GoalsService {
  GoalsService({required this.powersyncDb, required this.appDb});

  final PowerSyncDatabase powersyncDb;
  final AppDatabase appDb;

  Future<List<Goal>> getGoals() async {
    final goals =
        await powersyncDb.getAll('SELECT * FROM goals order by created_at asc');

    return goals.map((row) {
      return Goal(
        id: row['id'],
        name: row['name'],
        amount: row['amount'] as double,
        progress: row['progress'] ?? 0,
        targetDate: DateTime.parse(row['target_date']),
      );
    }).toList();
  }

  Future<void> addGoal(AddGoalInput input) async {
    final String targetDateString = input.targetDate
        .toIso8601String()
        .substring(0, 10); // Extracting 'YYYY-MM-DD'

    await powersyncDb.writeTransaction((tx) async {
      return await tx.execute(
        'INSERT INTO goals (id, name, amount, target_date) VALUES (?, ?, ?, ?)',
        [const Uuid().v4(), input.name, input.amount, targetDateString],
      );
    });
  }

  Future<void> updateGoal(Goal goal) async {
    final String targetDateString = goal.targetDate
        .toIso8601String()
        .substring(0, 10); // Extracting 'YYYY-MM-DD'

    await powersyncDb.writeTransaction((tx) async {
      return await tx.execute(
        'UPDATE goals SET name = ?, amount = ?, target_date = ?, progress = ? WHERE id = ?',
        [goal.name, goal.amount, targetDateString, goal.progress, goal.id],
      );
    });
  }

  Future<void> deleteGoal(Goal goal) async {
    await powersyncDb.writeTransaction((tx) async {
      return await tx.execute(
        'DELETE FROM goals WHERE id = ?',
        [goal.id],
      );
    });
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
