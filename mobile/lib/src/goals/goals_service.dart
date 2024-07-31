import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/powersync/powersync.dart';

class GoalsService {
  Future<List<Goal>> getGoals() async {
    final goals =
        await powersyncDb.getAll('SELECT * FROM goals order by created_at asc');

    return goals.map((row) {
      return Goal(
        id: row['id'],
        amount: row['amount'],
        name: row['name'],
        progress: row['progress'],
        targetDate: row['target_date'],
        userId: row['user_id'],
      );
    }).toList();
  }

  Future<void> addGoal(AddGoalInput input) async {
    await powersyncDb.writeTransaction((tx) async {
      return await tx.execute(
        'INSERT INTO goals (name, amount, target_date) VALUES (?, ?, ?)',
        [input.name, input.amount, input.targetDate],
      );
    });
  }

  Future<void> updateGoal(Goal goal) async {
    await powersyncDb.writeTransaction((tx) async {
      return await tx.execute(
        'UPDATE goals SET name = ?, amount = ?, target_date = ?, progress = ? WHERE id = ?',
        [goal.name, goal.amount, goal.targetDate, goal.progress, goal.id],
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
