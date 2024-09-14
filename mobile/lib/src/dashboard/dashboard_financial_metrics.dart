import 'package:flutter/material.dart';
import 'package:finny/src/finalytics/finalytics_controller.dart';
import 'package:intl/intl.dart';

class FinancialMetricsCard extends StatefulWidget {
  const FinancialMetricsCard({
    super.key,
    required this.finalyticsController,
  });

  final FinalyticsController finalyticsController;

  @override
  State<FinancialMetricsCard> createState() => _FinancialMetricsCardState();
}

class _FinancialMetricsCardState extends State<FinancialMetricsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Finance at a Glance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: widget.finalyticsController.getActualRetirementAge(),
              builder: (context, snapshot) {
                return _buildAgeTile(
                  context,
                  "Actual Retirement Age",
                  snapshot.data?.toInt() ?? 67,
                );
              },
            ),
            FutureBuilder(
              future: widget.finalyticsController.getTargetRetirementAge(),
              builder: (context, snapshot) {
                return _buildAgeTile(
                  context,
                  "Target Retirement Age",
                  snapshot.data ?? 67,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: widget.finalyticsController
                  .getTargetMonthlyRetirementSavings(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Monthly Savings Goal',
                  snapshot.data ?? 0,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: widget.finalyticsController.getSavedLast30Days(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Saved Last 30 Days',
                  snapshot.data ?? 0,
                  Icons.trending_up,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
      BuildContext context, String title, double value, IconData icon,
      {double? secondaryValue}) {
    final formatter = NumberFormat.currency(symbol: '\$');
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: secondaryValue != null
          ? Text(
              'In: ${formatter.format(value)} | Out: ${formatter.format(secondaryValue)}')
          : Text(formatter.format(value)),
      dense: true,
    );
  }

  Widget _buildAgeTile(BuildContext context, String title, int age) {
    return ListTile(
      leading: Icon(Icons.cake, color: Theme.of(context).primaryColor),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text('$age years'),
      dense: true,
    );
  }
}
