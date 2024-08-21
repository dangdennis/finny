import 'package:finny/src/dashboard/goals/add_goal_button.dart';
import 'package:finny/src/dashboard/dashboard_financial_metrics.dart';
import 'package:finny/src/dashboard/goals/goal_card.dart';
import 'package:finny/src/dashboard/onboarding/onboarding_card.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/finalytics/finalytics_controller.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/widgets/disabled_wrapper.dart';
import 'package:finny/src/widgets/gradient_banner.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
    required this.goalsController,
    required this.finalyticsController,
    required this.onboardingController,
  });

  static const routeName = Routes.dashboard;
  final GoalsController goalsController;
  final FinalyticsController finalyticsController;
  final OnboardingController onboardingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: const AddGoalButton(),
      body: FutureBuilder(
        future: onboardingController.isOnboarded(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final bool isOnboardingComplete =
              snapshot.data?.isOnboardingComplete ?? false;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientBanner(
                  child: Column(
                    children: [
                      if (!isOnboardingComplete)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OnboardingCard(
                            onboardingController: onboardingController,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DisabledWrapper(
                          isDisabled: !isOnboardingComplete,
                          child: FinancialMetricsCard(
                            finalyticsController: finalyticsController,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DisabledWrapper(
                          isDisabled: !isOnboardingComplete,
                          child: GoalCard(goalsController: goalsController),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
