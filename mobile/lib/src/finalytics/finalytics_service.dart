import 'package:drift/drift.dart';
import 'package:finny/src/powersync/database.dart';

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

class Finalytics {
  Finalytics({required this.appDb});

  final AppDatabase appDb;

  Future<List<MonthlyTransactionSummary>> getMonthlyTransactionSummary(
      String userId) async {
    final result = await appDb.customSelect(
      '''
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
      WHERE
        accounts.user_id = ?
      GROUP BY
        month
      ORDER BY
        month;
      ''',
      variables: [Variable.withString(userId)],
    ).get();

    return result.map((row) {
      return MonthlyTransactionSummary(
        month: row.read<DateTime>('month'),
        averageInflows: row.read<double>('average_inflows'),
        averageOutflows: row.read<double>('average_outflows'),
      );
    }).toList();
  }
}
