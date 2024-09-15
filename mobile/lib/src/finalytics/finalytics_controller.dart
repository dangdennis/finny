import 'package:finny/src/finalytics/finalytics_service.dart';
import 'package:finny/src/profile/profile_service.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics, this._profileService);

  final FinalyticsService _finalytics;
  final ProfileService _profileService;

  Future<int> getActualRetirementAge() async {
    return _finalytics.getActualRetirementAge();
  }

  Future<int> getTargetRetirementAge() async {
    return (await _profileService.getProfile()).retirementAge ?? 67;
  }

  Future<double> getTargetSavingsAndInvestmentsThisMonth() async {
    return _finalytics.getTargetSavingsAndInvestmentsThisMonth();
  }

  Future<double> getActualSavingsAndInvestmentsThisMonth() async {
    return _finalytics.getActualSavingsAndInvestmentsThisMonth();
  }

  Future<double> getActualSavingsAtRetirement() async {
    return _finalytics.getActualSavingsAtRetirement();
  }

  Future<double> getTargetSavingsAtRetirement() async {
    return _finalytics.getFreedomFutureValueOfCurrentExpensesAtRetirement();
  }
}
