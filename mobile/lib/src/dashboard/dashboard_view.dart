import 'package:finny/src/dashboard/add_goal_button.dart';
import 'package:finny/src/dashboard/dashboard_financial_metrics.dart';
import 'package:finny/src/dashboard/goals_card.dart';
import 'package:finny/src/dashboard/onboarding_view.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/finalytics/finalytics_controller.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/routes.dart';
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
          final bool isOnboarded = snapshot.data?.isOnboardingComplete ?? false;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientBanner(
                  child: Column(
                    children: [
                      if (!isOnboarded)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChecklistCard(
                            onboardingController: onboardingController,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DisabledWrapper(
                          isDisabled: !isOnboarded,
                          child: FinancialMetricsCard(
                            finalyticsController: finalyticsController,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DisabledWrapper(
                          isDisabled: !isOnboarded,
                          child: GoalsCard(goalsController: goalsController),
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

class DisabledWrapper extends StatelessWidget {
  final bool isDisabled;
  final Widget child;

  const DisabledWrapper({
    super.key,
    required this.isDisabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: child,
      ),
    );
  }
}

class ChecklistCard extends StatelessWidget {
  final OnboardingController onboardingController;

  const ChecklistCard({super.key, required this.onboardingController});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get Started',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ChecklistItem(
              title: 'Complete your profile',
              isCompleted: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OnboardingView(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            const ChecklistItem(
              title: 'Connect your bank accounts',
              isCompleted: false,
              subtitle: 'The more you connect, the more accurate insights.',
            ),
          ],
        ),
      ),
    );
  }
}

class ChecklistItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback? onTap;
  final String? subtitle;

  const ChecklistItem({
    super.key,
    required this.title,
    required this.isCompleted,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.circle_outlined,
        color: isCompleted ? Colors.green : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: isCompleted ? null : onTap,
    );
  }
}
