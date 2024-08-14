import 'package:finny/src/accounts/accounts_service.dart';
import 'package:finny/src/goals/goal_details_assigned_accounts.dart';
import 'package:finny/src/goals/goal_details_edit.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:finny/src/powersync/powersync.dart';
import 'package:finny/src/widgets/gradient_banner.dart';
import 'package:flutter/material.dart';

class GoalDetailView extends StatefulWidget {
  GoalDetailView({super.key, required this.goal});

  final Goal goal;
  final GoalsController _goalsController = GoalsController(
    accountsService: AccountsService(
      appDb: appDb,
    ),
    goalsService: GoalsService(
      appDb: appDb,
    ),
  );

  @override
  State<GoalDetailView> createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends State<GoalDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implement save functionality here, e.g., update the goal object and save it to a database.
              print("Save changes");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GradientBanner(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GoalDetailsEdit(
                      goal: widget.goal,
                    ),
                  ),
                ),
              ),
              GoalDetailsAssignedAccounts(
                  goalsController: widget._goalsController),
            ],
          ),
        ),
      ),
    );
  }
}
