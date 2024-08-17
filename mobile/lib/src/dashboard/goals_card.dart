import 'package:finny/src/dashboard/goals_card_title.dart';
import 'package:finny/src/dashboard/goals_content.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:flutter/material.dart';

class GoalsCard extends StatelessWidget {
  const GoalsCard({
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
            const GoalsCardTitle(),
            GoalsContent(goalsController: goalsController),
          ],
        ),
      ),
    );
  }
}
