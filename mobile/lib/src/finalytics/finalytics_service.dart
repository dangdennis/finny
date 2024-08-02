import 'package:finny/src/powersync/powersync.dart';

class MonthlyAverageMoneyFlow {
  final DateTime month;
  final double averageInflows;
  final double averageOutflows;

  MonthlyAverageMoneyFlow({
    required this.month,
    required this.averageInflows,
    required this.averageOutflows,
  });
}

class Finalytics {
  Future<List<MonthlyAverageMoneyFlow>> getAverageInflowsAndOutflows() async {
    const sql = """
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
          accounts.user_id = '5eaa8ae7-dbcb-445e-8058-dbd51a912c8d'
        GROUP BY
          month
        ORDER BY
          month;
    """;

    final resultSet = await powersyncDb.getAll(sql);

    return resultSet
        .map((row) => MonthlyAverageMoneyFlow(
              month: DateTime.parse(row['month']),
              averageInflows: row['average_inflows'],
              averageOutflows: row['average_outflows'],
            ))
        .toList();
  }
}
