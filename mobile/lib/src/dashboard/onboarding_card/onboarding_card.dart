import 'package:finny/src/connections/connections_controller.dart';
import 'package:finny/src/connections/connections_list_view.dart';
import 'package:finny/src/dashboard/onboarding_card/onboarding_item.dart';
import 'package:finny/src/profile/profile_form_view.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    super.key,
    required this.onboardingController,
    required this.onboardingState,
    required this.connectionsController,
  });

  final OnboardingController onboardingController;
  final ConnectionsController connectionsController;
  final OnboardingState? onboardingState;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Started',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                OnboardingItem(
                  title: 'Complete your profile',
                  isCompleted: onboardingState?.profileCompleted ?? false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileFormView(
                          onboardingController: onboardingController,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                OnboardingItem(
                  title: 'Connect your bank accounts',
                  isCompleted: onboardingState?.accountsAdded ?? false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConnectionsListView(
                          connectionsController: connectionsController,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
