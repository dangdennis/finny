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

  Future<double> calculateTargetSavingsAndInvestmentsThisMonth(
      ExpenseCalculation exp) async {
    return _finalytics.calculateTargetSavingsAndInvestmentsThisMonth(exp);
  }

  Future<double> calculateActualSavingsAndInvestmentsThisMonth(
      ExpenseCalculation exp) async {
    return _finalytics.calculateActualSavingsAndInvestmentsThisMonth(exp);
  }

  Future<double> calculateActualSavingsAtRetirement(
      ExpenseCalculation exp) async {
    return _finalytics.calculateActualSavingsAtRetirement(exp);
  }

  Future<double> calculateExpectedSavingsAtRetirement(
      ExpenseCalculation exp) async {
    return _finalytics.calculateExpectedSavingsAtRetirement(exp);
  }
}
