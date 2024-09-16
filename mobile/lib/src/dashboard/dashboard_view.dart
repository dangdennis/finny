import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/dashboard/dashboard_financial_metrics.dart';
import 'package:finny/src/dashboard/goals/goal_card.dart';
import 'package:finny/src/dashboard/onboarding_card/onboarding_card.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/finalytics/finalytics_controller.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/profile/profile_form_view.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/widgets/disabled_wrapper.dart';
import 'package:finny/src/widgets/gradient_banner.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({
    super.key,
    required this.goalsController,
    required this.finalyticsController,
    required this.onboardingController,
    required this.connectionsController,
  });

  static const routeName = Routes.dashboard;
  final GoalsController goalsController;
  final FinalyticsController finalyticsController;
  final OnboardingController onboardingController;
  final ConnectionsController connectionsController;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileFormView(
                  onboardingController: widget.onboardingController,
                ),
              ),
            );
          },
        ),
      ]),
      // todo: disable addition of new goals.
      // we automatically create a singular retirement goal after onboarding is complete.
      // floatingActionButton: const AddGoalButton(),
      body: StreamBuilder<OnboardingState>(
        stream: widget.onboardingController.watchOnboardingState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final onboardingState = snapshot.data;
          final isOnboardingComplete =
              onboardingState?.isOnboardingComplete ?? false;

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
                            onboardingState: onboardingState,
                            onboardingController: widget.onboardingController,
                            connectionsController: widget.connectionsController,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DisabledWrapper(
                          isDisabled: !isOnboardingComplete,
                          child: FinancialMetricsCard(
                            finalyticsController: widget.finalyticsController,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DisabledWrapper(
                          isDisabled: !isOnboardingComplete,
                          child:
                              GoalCard(goalsController: widget.goalsController),
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
