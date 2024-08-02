import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:logging/logging.dart';

class GoalsController {
  GoalsController({
    required this.goalsService,
  });

  final Logger _logger = Logger('GoalsController');
  final GoalsService goalsService;

  Future<List<Goal>> getGoals() async {
    try {
      final goals = await goalsService.getGoals();
      _logger.info("Fetching goals: $goals");
      return goals;
    } catch (e, stacktrace) {
      _logger.severe('Failed to get goals', e, stacktrace);
      rethrow;
    }
  }

  Future<void> addGoal(AddGoalInput input) async {
    try {
      await goalsService.addGoal(input);
    } catch (e, stacktrace) {
      _logger.severe('Failed to add goal', e, stacktrace);
      rethrow;
    }
  }

  Future<void> deleteGoal(Goal goal) async {
    try {
      await goalsService.deleteGoal(goal);
    } catch (e, stacktrace) {
      _logger.severe('Failed to delete goal', e, stacktrace);
      rethrow;
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      await goalsService.updateGoal(goal);
    } catch (e, stacktrace) {
      _logger.severe('Failed to update goal', e, stacktrace);
      rethrow;
    }
  }
}
