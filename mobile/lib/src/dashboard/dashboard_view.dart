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

class DashboardView extends StatefulWidget {
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
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isOnboardingCardHidden = true; // Default to hidden

  @override
  void initState() {
    super.initState();
    _loadOnboardingCardVisibility();
  }

  Future<void> _loadOnboardingCardVisibility() async {
    final isHidden = await widget.onboardingController.isOnboardingCardHidden();
    setState(() {
      _isOnboardingCardHidden = isHidden;
    });
  }

  Future<void> _hideOnboardingCard() async {
    await widget.onboardingController.setOnboardingCardHidden(true);
    setState(() {
      _isOnboardingCardHidden = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: const AddGoalButton(),
      body: FutureBuilder<OnboardingState>(
        future: widget.onboardingController.isOnboarded(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final onboardingState = snapshot.data;
          final bool isOnboardingComplete =
              onboardingState?.isOnboardingComplete ?? false;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientBanner(
                  child: Column(
                    children: [
                      if (!_isOnboardingCardHidden)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OnboardingCard(
                            onboardingState: onboardingState,
                            onboardingController: widget.onboardingController,
                            onHide: _hideOnboardingCard,
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
