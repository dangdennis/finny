import 'package:finny/src/dashboard/dashboard_goals_item.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:flutter/material.dart';

class DashboardGoalsList extends StatelessWidget {
  final List<Goal> goals;
  final GoalsController goalsController;

  const DashboardGoalsList(
      {required this.goals, required this.goalsController, super.key});

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
            DashboardGoalItem(
              goalsController: goalsController,
              goal: goal,
            ),
            if (index < goals.length - 1) const Divider(),
          ],
        );
      },
    );
  }
}
