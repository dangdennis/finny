import 'package:finny/src/dashboard/dashboard_goals_list.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/widgets/banner_overlay.dart';
import 'package:finny/src/widgets/gradient_banner.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({
    super.key,
    required this.goalsController,
  });

  static const routeName = Routes.dashboard;
  final GoalsController goalsController;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  static const _goalsCardHeight = 160.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // navigate to the new goal form
          Navigator.of(context).pushNamed(Routes.goalsNew);
        },
        label: const Text('Goals'),
        icon: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientBanner(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Goals",
                                  textAlign: TextAlign.left,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            StreamBuilder<List<Goal>>(
                              stream: widget.goalsController.watchGoals(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    height: _goalsCardHeight,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator())),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const SizedBox(
                                    height: _goalsCardHeight,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Center(
                                              child:
                                                  Text('Failed to load goals')),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return SizedBox(
                                    height: _goalsCardHeight,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed(Routes.goalsNew);
                                              },
                                              child: const Text(
                                                  'Add your first goal'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final goals = snapshot.data!;

                                return DashboardGoalsList(
                                    goals: goals,
                                    goalsController: widget.goalsController);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
