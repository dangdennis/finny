import 'package:finny/src/dashboard/goal_progress_indicator.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardGoalItem extends StatefulWidget {
  final Goal goal;
  const DashboardGoalItem({
    required this.goal,
    super.key,
  });

  @override
  State<DashboardGoalItem> createState() => _DashboardGoalItemState();
}

class _DashboardGoalItemState extends State<DashboardGoalItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GoalsDetailView(goal: widget.goal),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.goal.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${widget.goal.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to start
                  children: [
                    Text(
                      'Target ${DateFormat.yMMMd().format(widget.goal.targetDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Actual ${DateFormat.yMMMd().format(widget.goal.targetDate)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                GoalProgressIndicator(progress: widget.goal.progress ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
