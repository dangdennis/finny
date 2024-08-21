import 'package:finny/src/dashboard/onboarding/onboarding_item.dart';
import 'package:finny/src/dashboard/onboarding/profile_form_view.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final OnboardingController onboardingController;

  const OnboardingCard({super.key, required this.onboardingController});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
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
              isCompleted: false,
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
            const OnboardingItem(
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
