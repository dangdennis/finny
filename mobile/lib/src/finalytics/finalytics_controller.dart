import 'package:finny/src/finalytics/finalytics_service.dart';
import 'package:logging/logging.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics);

  final FinalyticsService _finalytics;

  Future<MonthlyInvestmentOutput> getTargetMonthlyInvestment() async {
    try {
      return await _finalytics.getTargetMonthlyInvestment();
    } catch (e) {
      Logger.root.severe('Error getting target monthly investment: $e');
      return MonthlyInvestmentOutput(amount: 0);
    }
  }

  Future<MonthlyInvestmentOutput> getActualMonthlyInvestment() async {
    try {
      return await _finalytics.getActualMonthlyInvestment();
    } catch (e) {
      Logger.root.severe('Error getting actual monthly investment: $e');
      return MonthlyInvestmentOutput(amount: 0);
    }
  }
}
