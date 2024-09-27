import 'package:finny/src/dashboard/goals/goal_card_title.dart';
import 'package:finny/src/dashboard/goals/goal_content.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:flutter/material.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goalsController,
  });

  final GoalsController goalsController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const GoalCardTitle(),
            GoalContent(goalsController: goalsController),
          ],
        ),
      ),
    );
  }
}
