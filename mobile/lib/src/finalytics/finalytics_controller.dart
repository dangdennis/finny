import 'package:finny/src/finalytics/finalytics_service.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics);

  final FinalyticsService _finalytics;

  Future<MonthlyInvestmentOutput> getTargetMonthlyInvestment() async {
    return _finalytics.getTargetMonthlyInvestment();
  }

  Future<MonthlyInvestmentOutput> getActualMonthlyInvestment() async {
    return _finalytics.getActualMonthlyInvestment();
  }
}
