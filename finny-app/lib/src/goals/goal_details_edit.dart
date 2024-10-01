import 'dart:math';

import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:flutter/material.dart';

class GoalDetailsEdit extends StatefulWidget {
  const GoalDetailsEdit({
    super.key,
    required this.goal,
    required this.onGoalSave,
    required this.profile,
  });

  final Future<void> Function(Goal) onGoalSave;
  final Goal goal;
  final Profile profile;

  @override
  State<GoalDetailsEdit> createState() => _GoalDetailsEditState();
}

class _GoalDetailsEditState extends State<GoalDetailsEdit> {
  late DateTime targetDate;
  late Profile profile;

  @override
  Widget build(BuildContext context) {
    final double progressPercentage = (widget.goal.progress ?? 0) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Retirement 🎉🥳',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Amount',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(
                        // Added Container to limit height
                        height: 32, // Set desired height
                        child: IconButton(
                          icon: const Icon(Icons.info_outline, size: 18),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('What is amount?'),
                                  content: const Text(
                                      'Your ideal target amount for retirement is based on your estimated expenses and retirement age.'),
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
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${widget.goal.targetAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Retirement Age',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${widget.profile.retirementAge}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(10),
              value: max(0.03, widget.goal.progress ?? 0),
              minHeight: 20, // Increased to accommodate text
              backgroundColor: Colors.grey[400],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${progressPercentage.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
