import 'package:finny/src/goals/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class GoalItem extends StatefulWidget {
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
  State<GoalItem> createState() => _GoalItemState();
}

class _GoalItemState extends State<GoalItem> {
  bool _showProgressText = false;

  void _toggleProgressView() {
    setState(() {
      _showProgressText = !_showProgressText;
    });
  }

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
                widget.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '\$${widget.amount.toStringAsFixed(2)}',
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
                    'Target ${DateFormat.yMMMd().format(widget.targetDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Actual ${DateFormat.yMMMd().format(widget.targetDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 16), // Add space between the two columns
              GestureDetector(
                onTap: _toggleProgressView,
                child: _showProgressText
                    ? Text(
                        '${((widget.progress ?? 0) * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          value: widget.progress,
                          strokeWidth: 4.0,
                          backgroundColor: Colors.grey[400],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
