import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/dashboard/goal_progress_indicator.dart';
import 'package:finny/src/goals/goal_details_view.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardGoalItem extends StatefulWidget {
  const DashboardGoalItem({
    required this.goal,
    required this.getAssignedAccounts,
    super.key,
  });

  final Goal goal;
  final Future<List<Account>> Function(GoalId) getAssignedAccounts;

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
            builder: (context) => GoalDetailView(goalId: widget.goal.id),
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
                Expanded(
                  child: Text(
                    widget.goal.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${widget.goal.targetAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Target ${DateFormat.yMMMd().format(widget.goal.targetDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      'Actual ${DateFormat.yMMMd().format(widget.goal.targetDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
