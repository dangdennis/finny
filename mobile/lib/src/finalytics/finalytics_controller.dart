import 'package:finny/src/finalytics/finalytics_service.dart';
import 'package:logging/logging.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics);

  final FinalyticsService _finalytics;

  Stream<MonthlyInvestmentOutput> watchTargetMonthlyInvestment() async* {
    try {
      yield* _finalytics.watchTargetMonthlyInvestment();
    } catch (e) {
      Logger.root.severe('Error getting target monthly investment: $e');
      yield MonthlyInvestmentOutput(amount: 0);
    }
  }

  Stream<MonthlyInvestmentOutput> watchActualMonthlyInvestment() async* {
    try {
      yield* _finalytics.watchActualMonthlyInvestment();
    } catch (e) {
      Logger.root.severe('Error getting actual monthly investment: $e');
      yield MonthlyInvestmentOutput(amount: 0);
    }
  }

  Future<double> getTargetMonthlySavings() async {
    return _finalytics.getTargetMonthlySavings();
  }
}
