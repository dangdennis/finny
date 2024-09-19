import 'package:finny/src/finalytics/finalytics_service.dart';
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
  ExpenseCalculation _selectedExpenseCalc = ExpenseCalculation.last12Months;

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
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<ExpenseCalculation>(
                    segments: const [
                      ButtonSegment<ExpenseCalculation>(
                        value: ExpenseCalculation.last12Months,
                        label: Text('Last 12 Months'),
                      ),
                      ButtonSegment<ExpenseCalculation>(
                        value: ExpenseCalculation.average,
                        label: Text('Average'),
                      ),
                    ],
                    selected: <ExpenseCalculation>{_selectedExpenseCalc},
                    onSelectionChanged: (Set<ExpenseCalculation> newSelection) {
                      setState(() {
                        _selectedExpenseCalc = newSelection.first;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showInfoDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: widget.finalyticsController
                  .getActualRetirementAge(_selectedExpenseCalc),
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
                  .getTargetSavingsAndInvestmentsThisMonth(
                      _selectedExpenseCalc),
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
                  .getActualSavingsAndInvestmentsThisMonth(
                      _selectedExpenseCalc),
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
              future: widget.finalyticsController
                  .getActualSavingsAtRetirement(_selectedExpenseCalc),
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
              future: widget.finalyticsController
                  .getTargetSavingsAtRetirement(_selectedExpenseCalc),
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

  // Add this method to show the info dialog
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How we calculate your numbers'),
          content: const Text(
            'Your numbers are based on your real-time expenses, whether a sum of the last 12 months or an average.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
