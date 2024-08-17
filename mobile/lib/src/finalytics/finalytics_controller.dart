import 'package:finny/src/finalytics/finalytics_service.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics);

  final FinalyticsService _finalytics;

  Future<CurrentRetirementInterestReturn>
      getCurrentRetirementInterestReturn() async {
    return _finalytics.getCurrentRetirementInterestReturn();
  }

  Future<double> getTargetCurrentInterestReturn() async {
    return (await _finalytics.getAnnualInflowOutflow()).outflows * 25.0 * 0.04;
  }

  Future<AverageMonthlyInflowOutflow> getAverageMonthlyInflowOutflow() async {
    return _finalytics.getAverageMonthlyInflowOutflow();
  }

  Future<AnnualInflowOutflow> getAnnualInflowOutflow() async {
    return _finalytics.getAnnualInflowOutflow();
  }

  Future<double> getTargetInvestmentBalance() async {
    return (await _finalytics.getAnnualInflowOutflow()).outflows * 25;
  }

  Future<int> getCurrentRetirementAge() async {
    return _finalytics.getCurrentRetirementAge();
  }

  Future<int> getTargetRetirementAge() async {
    return _finalytics.getTargetRetirementAge();
  }
}
