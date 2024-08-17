import 'package:finny/src/dashboard/add_goal_button.dart';
import 'package:finny/src/dashboard/dashboard_financial_metrics.dart';
import 'package:finny/src/dashboard/goals_card.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/finalytics/finalytics_controller.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/widgets/gradient_banner.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.goalsController,
    required this.finalyticsController,
  });

  static const routeName = Routes.dashboard;
  final GoalsController goalsController;
  final FinalyticsController finalyticsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: const AddGoalButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientBanner(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FinancialMetricsCard(
                      finalyticsController: finalyticsController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GoalsCard(goalsController: goalsController),
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
