import 'package:flutter/material.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
    required this.settingsController,
  });

  static const routeName = '/settings';

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<ThemeMode>(
              value: settingsController.themeMode,
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmationDialog(context),
              child: const Text('Delete Account'),
            ),
            const Spacer(), // This will push the logout button to the bottom
            SizedBox(
              width: double.infinity,
              height: 50, // Make the button taller
              child: ElevatedButton(
                onPressed: settingsController.signOut,
                child: const Text('Logout', style: TextStyle(fontSize: 18)),
              ),
            ),
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
