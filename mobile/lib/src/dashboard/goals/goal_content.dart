import 'package:finny/src/dashboard/goals/dashboard_goals_list.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';

class GoalContent extends StatelessWidget {
  const GoalContent({
    super.key,
    required this.goalsController,
  });

  final GoalsController goalsController;
  static const _goalsCardHeight = 160.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Goal>>(
      stream: goalsController.watchGoals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        } else if (snapshot.hasError) {
          return _buildErrorState();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(context);
        }

        final goals = snapshot.data!;
        return DashboardGoalsList(
            goals: goals, goalsController: goalsController);
      },
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: _goalsCardHeight,
      child: Column(
        children: [
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return const SizedBox(
      height: _goalsCardHeight,
      child: Column(
        children: [
          Expanded(
            child: Center(child: Text('Failed to load goals')),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: _goalsCardHeight,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.goalsNew);
                },
                child: const Text('Add your first goal'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
