import 'package:finny/src/finalytics/finalytics_service.dart';
import 'package:logging/logging.dart';

class FinalyticsController {
  FinalyticsController(this._finalytics);

  final FinalyticsService _finalytics;

  Future<double> getTargetMonthlyRetirementSavings() async {
    return _finalytics.getTargetMonthlyRetirementSavings();
  }
}
