import 'package:finny/src/powersync/database.dart';

class Finalytics {
  Finalytics({required this.appDb});

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
        amount: result.read<double>('average_interest_return'));
  }

  /// Freedom fund target, aka target retirement fund, is the
  /// average monthly expense of the last 12 months * 12 months.
  Future<AverageAnnualExpense> getAverageAnnualExpense() async {
    final result = await appDb.customSelect('''
    SELECT
      ABS(SUM(amount)) / 12 AS average_annual_spending
    FROM
      transactions
      JOIN accounts ON transactions.account_id = accounts.id
    WHERE
      amount > 0
      AND date >= (CURRENT_DATE - INTERVAL '12 months');
    ''').getSingle();

    return AverageAnnualExpense(
        amount: result.read<double>('average_annual_spending'));
  }

  /// Get the average monthly expense from the last 12 months
  Future<AverageMonthlyExpense> getAverageMonthlyExpense() async {
    final result = await appDb.customSelect('''
      SELECT
        AVG(average_outflows) AS average_monthly_expense
      FROM (
        SELECT
          date_trunc('month', date) AS month,
          AVG(
            CASE WHEN amount > 0 THEN
              amount
            ELSE
              0
            END) AS average_outflows
        FROM
          transactions
          JOIN accounts ON transactions.account_id = accounts.id
        WHERE
          date >= (CURRENT_DATE - INTERVAL '12 months')
        GROUP BY
          month
        ORDER BY
          month
      ) AS monthly_expenses;
      ''').getSingle();

    final amount = result.read<double>('average_monthly_expense');
    return AverageMonthlyExpense(amount: amount);
  }

  Future<List<MonthlyTransactionSummary>> getMonthlyTransactionSummary(
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
      return MonthlyTransactionSummary(
        month: row.read<DateTime>('month'),
        averageInflows: row.read<double>('average_inflows'),
        averageOutflows: row.read<double>('average_outflows'),
      );
    }).toList();
  }
}

class CurrentRetirementInterestReturn {
  final double amount;

  CurrentRetirementInterestReturn({required this.amount});
}

class AverageAnnualExpense {
  final double amount;

  AverageAnnualExpense({required this.amount});
}

class AverageMonthlyExpense {
  final double amount;

  AverageMonthlyExpense({required this.amount});
}

class MonthlyTransactionSummary {
  final DateTime month;
  final double averageInflows;
  final double averageOutflows;

  MonthlyTransactionSummary({
    required this.month,
    required this.averageInflows,
    required this.averageOutflows,
  });
}
