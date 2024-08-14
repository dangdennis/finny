import 'dart:async';

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
