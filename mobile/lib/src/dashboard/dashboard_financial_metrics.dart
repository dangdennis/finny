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
              future: widget.finalyticsController
                  .getCurrentRetirementInterestReturn(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Current Interest Income (4%)',
                  snapshot.data?.amount ?? 0,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future:
                  widget.finalyticsController.getTargetCurrentInterestReturn(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Target Interest Income (4%)',
                  snapshot.data ?? 0,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: widget.finalyticsController.getTargetInvestmentBalance(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Target Investment Balance',
                  snapshot.data ?? 0,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: widget.finalyticsController.getCurrentRetirementAge(),
              builder: (context, snapshot) {
                return _buildAgeTile(
                  context,
                  'Actual Freedom Retirement Age',
                  snapshot.data,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: widget.finalyticsController.getTargetRetirementAge(),
              builder: (context, snapshot) {
                return _buildAgeTile(
                  context,
                  'Projected Freedom Retirement Age',
                  snapshot.data,
                  Icons.trending_up,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future:
                  widget.finalyticsController.getAverageMonthlyInflowOutflow(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Avg Monthly Inflow/Outflow',
                  snapshot.data?.inflows ?? 0,
                  Icons.compare_arrows,
                  secondaryValue: snapshot.data?.outflows ?? 0,
                );
              },
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: widget.finalyticsController.getAnnualInflowOutflow(),
              builder: (context, snapshot) {
                return _buildMetricTile(
                  context,
                  'Annual Inflow/Outflow',
                  snapshot.data?.inflows ?? 0,
                  Icons.calendar_today,
                  secondaryValue: snapshot.data?.outflows ?? 0,
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

  Widget _buildAgeTile(
      BuildContext context, String title, int? value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(value != null ? value.toString() : 'Pending'),
      dense: true,
    );
  }
}
