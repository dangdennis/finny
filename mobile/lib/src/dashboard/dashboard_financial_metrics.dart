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

enum ExpenseView { last12Months, average }

class _FinancialMetricsCardState extends State<FinancialMetricsCard> {
  ExpenseView _selectedExpenseView = ExpenseView.last12Months;

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
            SegmentedButton<ExpenseView>(
              segments: const [
                ButtonSegment<ExpenseView>(
                  value: ExpenseView.last12Months,
                  label: Text('Last 12 Months'),
                ),
                ButtonSegment<ExpenseView>(
                  value: ExpenseView.average,
                  label: Text('Average'),
                ),
              ],
              selected: <ExpenseView>{_selectedExpenseView},
              onSelectionChanged: (Set<ExpenseView> newSelection) {
                setState(() {
                  _selectedExpenseView = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: widget.finalyticsController.getActualRetirementAge(),
              builder: (context, snapshot) {
                return _buildAgeTile(
                  context,
                  "Actual Retirement Age",
                  snapshot.data ?? 67,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: widget.finalyticsController
                  .getTargetSavingsAndInvestmentsThisMonth(),
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
              future: widget.finalyticsController
                  .getActualSavingsAndInvestmentsThisMonth(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Saved And Invested This Month',
                  snapshot.data ?? 0,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future:
                  widget.finalyticsController.getActualSavingsAtRetirement(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Actual Savings At Retirement',
                  snapshot.data ?? 0,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future:
                  widget.finalyticsController.getTargetSavingsAtRetirement(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Target Savings At Retirement',
                  snapshot.data ?? 0,
                  Icons.trending_up,
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
