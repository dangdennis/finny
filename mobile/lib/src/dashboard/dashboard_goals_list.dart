import 'package:finny/src/dashboard/dashboard_goals_item.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:flutter/material.dart';

class DashboardGoalsList extends StatelessWidget {
  final List<Goal> goals;

  const DashboardGoalsList({required this.goals, super.key});

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
              goal: goal,
            ),
            if (index < goals.length - 1) const Divider(),
          ],
        );
      },
    );
  }
}
