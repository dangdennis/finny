import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finny/src/accounts/accounts_service.dart';
import 'package:finny/src/goals/goal_details_assigned_accounts.dart';
import 'package:finny/src/goals/goal_details_edit.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:finny/src/powersync/powersync.dart';
import 'package:finny/src/widgets/gradient_banner.dart';

class GoalDetailView extends StatefulWidget {
  GoalDetailView({super.key, required this.goalId});

  final String goalId;
  final GoalsController _goalsController = GoalsController(
    accountsService: AccountsService(
      appDb: appDb,
    ),
    goalsService: GoalsService(
      appDb: appDb,
    ),
  );

  Future<void> _handleGoalSave(Goal goal) async {
    print("save goal at goal details parent $goal");
    await _goalsController.updateGoal(goal);
  }

  Future<void> _handleGoalDelete(BuildContext context) async {
    final goal = await _goalsController.getGoal(goalId);
    if (context.mounted) {
      final confirmed = await _showDeleteConfirmationDialog(context, goal);
      if (confirmed) {
        final goal = await _goalsController.getGoal(goalId);
        await _goalsController.deleteGoal(goal);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, Goal goal) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete ${goal.name}'),
              content: const Text('Are you sure you want to delete this goal?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  State<GoalDetailView> createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends State<GoalDetailView> {
  Goal? goal;
  StreamSubscription<Goal>? goalSub;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode targetAmountFocusNode = FocusNode();
  final FocusNode targetDateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    watchGoal();
  }

  @override
  void dispose() {
    goalSub?.cancel();
    super.dispose();
    nameFocusNode.dispose();
    targetAmountFocusNode.dispose();
    targetDateFocusNode.dispose();
  }

  void watchGoal() {
    goalSub = widget._goalsController.watchGoal(widget.goalId).listen(
      (goal) {
        setState(() {
          this.goal = goal;
        });
      },
    );
  }

  void _unfocusAll() {
    nameFocusNode.unfocus();
    targetAmountFocusNode.unfocus();
    targetDateFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal?.name ?? ""),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => widget._handleGoalDelete(context),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _unfocusAll,
        child: SingleChildScrollView(
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
                      child: goal != null
                          ? GoalDetailsEdit(
                              goal: goal!,
                              onGoalSave: widget._handleGoalSave,
                              nameFocusNode: nameFocusNode,
                              targetAmountFocusNode: targetAmountFocusNode,
                              targetDateFocusNode: targetDateFocusNode,
                            )
                          : Container(),
                    ),
                  ),
                ),
                GoalDetailsAssignedAccounts(
                    goalsController: widget._goalsController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
