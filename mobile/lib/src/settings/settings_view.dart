import 'package:finny/src/dashboard/onboarding/profile_form_view.dart';
import 'package:finny/src/onboarding/onboarding_controller.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:flutter/material.dart';
import 'settings_controller.dart';
import 'package:intl/intl.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView(
      {super.key,
      required this.settingsController,
      required this.onboardingController});

  static const routeName = '/settings';

  final SettingsController settingsController;
  final OnboardingController onboardingController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<ThemeMode>(
              // Read the selected themeMode from the controller
              value: settingsController.themeMode,
              // Call the updateThemeMode method any time the user selects a theme.
              onChanged: settingsController.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<Profile?>(
              stream: settingsController.watchProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final profile = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Date of Birth: ${DateFormat('yyyy-MM-dd').format(profile.dateOfBirth!)}'),
                      const SizedBox(height: 8),
                      Text('Retirement Age: ${profile.retirementAge}'),
                      const SizedBox(height: 8),
                      Text('Risk Profile: ${profile.riskProfile}'),
                      const SizedBox(height: 8),
                      Text('FIRE Profile: ${profile.fireProfile}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileFormView(
                                    onboardingController:
                                        onboardingController)),
                          );
                        },
                        child: const Text('Edit Profile'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmationDialog(context),
              child: const Text('Delete Account'),
            ),
            ElevatedButton(
                onPressed: settingsController.signOut,
                child: const Text('Logout'))
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await settingsController.deleteSelf();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
