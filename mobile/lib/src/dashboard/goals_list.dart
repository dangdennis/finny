import 'package:finny/src/goals/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Usage within a ListView.builder
class GoalsList extends StatelessWidget {
  final List<Goal> goals;

  const GoalsList({required this.goals, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return Column(
          children: [
            GoalItem(
              name: goal.name,
              amount: goal.amount,
              targetDate: goal.targetDate,
              progress: goal.progress,
            ),
            if (index < goals.length - 1) const Divider(),
          ],
        );
      },
    );
  }
}

class GoalItem extends StatelessWidget {
  final String name;
  final double amount;
  final DateTime targetDate;
  final double? progress;

  const GoalItem({
    required this.name,
    required this.amount,
    required this.targetDate,
    required this.progress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '\$${amount.toStringAsFixed(2)}',
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
                    'Target ${DateFormat.yMMMd().format(targetDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Actual ${DateFormat.yMMMd().format(targetDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 16), // Add space between the two columns
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      value: progress, // Progress value between 0.0 and 1.0
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${((progress ?? 0) * 100).toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
