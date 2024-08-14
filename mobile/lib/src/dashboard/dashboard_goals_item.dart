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
  final Future<List<Account>> Function(Goal) getAssignedAccounts;

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
            builder: (context) => GoalDetailView(goal: widget.goal),
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
                  '\$${widget.goal.targetAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelMedium,
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
            const SizedBox(height: 8),
            FutureBuilder<List<Account>>(
              future: widget.getAssignedAccounts(widget.goal),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('');
                } else {
                  return Row(
                    children: snapshot.data!.asMap().entries.map((entry) {
                      int index = entry.key;
                      Account account = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 0 : -15), // Overlapping effect
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  account.name[0]
                                      .toUpperCase(), // Initial letter
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
