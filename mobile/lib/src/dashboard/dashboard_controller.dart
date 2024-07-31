import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:logging/logging.dart';

class DashboardController {
  DashboardController({
    required GoalsService goalsService,
  });

  final Logger _logger = Logger('DashboardController');
  final GoalsService _goalsService = GoalsService();

  Future<List<Goal>> getGoals() async {
    try {
      return await _goalsService.getGoals();
    } catch (e, stacktrace) {
      _logger.severe('Failed to get goals', e, stacktrace);
      rethrow;
    }
  }

  Future<void> addGoal(AddGoalInput input) async {
    try {
      await _goalsService.addGoal(input);
    } catch (e, stacktrace) {
      _logger.severe('Failed to add goal', e, stacktrace);
      rethrow;
    }
  }
}
