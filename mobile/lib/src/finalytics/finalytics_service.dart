import 'package:finny/src/powersync/database.dart';

class FinalyticsService {
  FinalyticsService({required this.appDb});

  final AppDatabase appDb;

  /// Get the current retirement interest return for all investment accounts.
  /// This is the sum of the current balance of all investment accounts multiplied by the 4% interest rate.
  Future<CurrentRetirementInterestReturn>
      getCurrentRetirementInterestReturn() async {
    final result = await appDb.customSelect('''
      SELECT
        sum(current_balance) * 0.04 AS current_retirement_interest_return
      FROM
        accounts
      WHERE
        type = 'investment';
    ''').getSingle();

    return CurrentRetirementInterestReturn(
        amount: result.read<double>('current_retirement_interest_return'));
  }

  Future<AnnualInflowOutflow> getAnnualInflowOutflow() async {
    final result = await appDb.customSelect('''
      SELECT
        SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS annual_inflows,
        SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS annual_outflows
      FROM
        transactions
        JOIN accounts ON transactions.account_id = accounts.id
      WHERE
        date >= date('now', '-12 months');
    ''').getSingle();

    return AnnualInflowOutflow(
      inflows: result.read<double>('annual_inflows'),
      outflows: result.read<double>('annual_outflows'),
    );
  }

  /// Get the average monthly inflow and outflow for the last 12 months
  Future<AverageMonthlyInflowOutflow> getAverageMonthlyInflowOutflow() async {
    final result = await appDb.customSelect('''
      WITH monthly_totals AS (
        SELECT
          strftime('%Y-%m', date) AS month,
          SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS monthly_inflows,
          SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS monthly_outflows
        FROM
          transactions
          JOIN accounts ON transactions.account_id = accounts.id
        WHERE
          date >= date('now', '-12 months')
        GROUP BY
          month
      )
      SELECT
        AVG(monthly_inflows) AS average_inflows,
        AVG(monthly_outflows) AS average_outflows
      FROM
        monthly_totals;
    ''').getSingle();

    return AverageMonthlyInflowOutflow(
        inflows: result.read<double>('average_inflows'),
        outflows: result.read<double>('average_outflows'));
  }

  Future<List<MonthlyInflowOutflow>> getMonthlyInflowOutflow(
      String userId) async {
    final result = await appDb.customSelect('''
      SELECT
        date_trunc('month', date) AS month,
        avg(
          CASE WHEN amount < 0 THEN
            amount
          ELSE
            0
          END) AS average_inflows,
        avg(
          CASE WHEN amount > 0 THEN
            amount
          ELSE
            0
          END) AS average_outflows
      FROM
        transactions
        JOIN accounts ON transactions.account_id = accounts.id
      GROUP BY
        month
      ORDER BY
        month;
      ''').get();

    return result.map((row) {
      return MonthlyInflowOutflow(
        month: row.read<DateTime>('month'),
        averageInflows: row.read<double>('average_inflows'),
        averageOutflows: row.read<double>('average_outflows'),
      );
    }).toList();
  }

  Future<int> getCurrentRetirementAge() async {
    final result = await appDb.customSelect('''
      SELECT
        date_trunc('year', date) AS year
      FROM
        transactions
      ORDER BY
        year DESC
      LIMIT 1;
    ''').getSingle();

    return result.read<int>('year');
  }

  Future<int> getTargetRetirementAge() async {
    final result = await appDb.customSelect('''
      SELECT
        date_trunc('year', date) AS year
      FROM
        transactions
      ORDER BY
        year DESC
      LIMIT 1;
    ''').getSingle();

    return result.read<int>('year');
  }
}

class CurrentRetirementInterestReturn {
  final double amount;

  CurrentRetirementInterestReturn({required this.amount});
}

class AnnualInflowOutflow {
  final double inflows;
  final double outflows;

  AnnualInflowOutflow({required this.inflows, required this.outflows});
}

class AverageMonthlyInflowOutflow {
  final double inflows;
  final double outflows;

  AverageMonthlyInflowOutflow({required this.inflows, required this.outflows});
}

class MonthlyInflowOutflow {
  final DateTime month;
  final double averageInflows;
  final double averageOutflows;

  MonthlyInflowOutflow({
    required this.month,
    required this.averageInflows,
    required this.averageOutflows,
  });
}
