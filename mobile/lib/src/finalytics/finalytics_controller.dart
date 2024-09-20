import 'package:finny/src/finalytics/finalytics_service.dart';
import 'package:finny/src/profile/profile_service.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics, this._profileService);

  final FinalyticsService _finalytics;
  final ProfileService _profileService;

  Future<int> getActualRetirementAge(ExpenseCalculation exp) async {
    return _finalytics.getActualRetirementAge(exp);
  }

  Future<int> getTargetRetirementAge() async {
    return (await _profileService.getProfile())?.retirementAge ?? 67;
  }

  Future<double> getTargetSavingsAndInvestmentsThisMonth(
      ExpenseCalculation exp) async {
    return _finalytics.getTargetSavingsAndInvestmentsThisMonth(exp);
  }

  Future<double> getActualSavingsAndInvestmentsThisMonth(
      ExpenseCalculation exp) async {
    return _finalytics.getActualSavingsAndInvestmentsThisMonth(exp);
  }

  Future<double> getActualSavingsAtRetirement(ExpenseCalculation exp) async {
    return _finalytics.getActualSavingsAtRetirement(exp);
  }

  Future<double> getTargetSavingsAtRetirement(ExpenseCalculation exp) async {
    return _finalytics.getFreedomFutureValueOfCurrentExpensesAtRetirement(exp);
  }
}
