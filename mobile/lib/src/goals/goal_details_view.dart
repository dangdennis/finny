import 'dart:async';
import 'package:finny/src/goals/goal_details_assign_accounts.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:finny/src/goals/goal_details_edit.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/widgets/gradient_banner.dart';

class GoalDetailView extends StatefulWidget {
  const GoalDetailView(
      {super.key,
      required this.goalId,
      required GoalsController goalsController})
      : _goalsController = goalsController;

  final String goalId;
  final GoalsController _goalsController;

  Future<void> _handleGoalSave(Goal goal) async {
    await _goalsController.updateGoal(goal);
  }

  @override
  State<GoalDetailView> createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends State<GoalDetailView> {
  Goal? goal;
  StreamSubscription<Goal>? goalSub;
  Profile? profile;
  StreamSubscription<Profile?>? profileSub;

  @override
  void initState() {
    super.initState();
    watchGoal();
    watchProfile();
  }

  @override
  void dispose() {
    goalSub?.cancel();
    super.dispose();
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

  void watchProfile() {
    profileSub = widget._goalsController.watchProfile().listen(
      (profile) {
        setState(() {
          this.profile = profile;
        });
      },
    );
  }

  Future<List<GoalAccount>> getGoalAccounts() async {
    return await widget._goalsController.getGoalAccounts(widget.goalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal?.name ?? ""),
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
                    child: goal != null && profile != null
                        ? GoalDetailsEdit(
                            goal: goal!,
                            onGoalSave: widget._handleGoalSave,
                            profile: profile!,
                          )
                        : Container(),
                  ),
                ),
              ),
              GoalDetailsAssignAccounts(
                goalId: widget.goalId,
                getAccounts: () async =>
                    await widget._goalsController.getAccounts(),
                onAccountAssignOrUpdate:
                    widget._goalsController.assignOrUpdateGoalAccount,
                onAccountUnassign: widget._goalsController.unassignGoalAccount,
                getGoalAccounts: getGoalAccounts,
              )
            ],
          ),
        ),
      ),
    );
  }
}
