import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/accounts/accounts_service.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:logging/logging.dart';

class GoalsController {
  GoalsController({
    required GoalsService goalsService,
    required AccountsService accountsService,
  })  : _accountsService = accountsService,
        _goalsService = goalsService;

  final Logger _logger = Logger('GoalsController');
  final GoalsService _goalsService;
  final AccountsService _accountsService;

  Stream<List<Goal>> watchGoals() {
    try {
      final goals = _goalsService.watchGoals();
      return goals;
    } catch (e, stacktrace) {
      _logger.severe('Failed to watch goals', e, stacktrace);
      rethrow;
    }
  }

  Future<List<Goal>> getGoals() async {
    try {
      final goals = await _goalsService.getGoals();
      return goals;
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

  Future<void> deleteGoal(Goal goal) async {
    try {
      await _goalsService.deleteGoal(goal);
    } catch (e, stacktrace) {
      _logger.severe('Failed to delete goal', e, stacktrace);
      rethrow;
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      await _goalsService.updateGoal(goal);
    } catch (e, stacktrace) {
      _logger.severe('Failed to update goal', e, stacktrace);
      rethrow;
    }
  }

  Future<List<Account>> getAssignedAccounts(Goal goal) async {
    try {
      final goalAccounts = await _goalsService.getAssignedAccounts(goal);
      final accounts = await _accountsService.getAccounts(GetAccountsInput(
        accountIds: goalAccounts.map((e) => e.accountId).toList(),
      ));
      return accounts;
    } catch (e, stacktrace) {
      _logger.severe('Failed to get assigned accounts', e, stacktrace);
      rethrow;
    }
  }

  Stream<List<Account>> watchAccounts() {
    return _accountsService.watchAccounts();
  }
}
