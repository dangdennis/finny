import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';

class GoalsDetailView extends StatelessWidget {
  const GoalsDetailView({super.key, required this.goal});

  final Goal goal;

  static const routeName = Routes.goalDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal.name),
      ),
      body: Center(
        child: Text(goal.toString()),
      ),
    );
  }
}
