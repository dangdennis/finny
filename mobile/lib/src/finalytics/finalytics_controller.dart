import 'package:finny/src/finalytics/finalytics_service.dart';
import 'package:finny/src/profile/profile_service.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics, this._profileService);

  final FinalyticsService _finalytics;
  final ProfileService _profileService;

  Future<int> getActualRetirementAge() async {
    return 67;
  }

  Future<int> getTargetRetirementAge() async {
    return (await _profileService.getProfile()).retirementAge ?? 67;
  }

  Future<double> getTargetMonthlyRetirementSavings() async {
    return _finalytics.getTargetMonthlyRetirementSavings();
  }

  Future<double> getSavedLast30Days() async {
    return 0.0;
  }
}
