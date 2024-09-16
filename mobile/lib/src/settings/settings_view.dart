import 'package:finny/src/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
    required this.settingsController,
    required this.authProvider,
  });

  static const routeName = '/settings';

  final SettingsController settingsController;
  final AuthProvider authProvider;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.settingsController.themeMode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeMode = widget.settingsController.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildThemeSelector(),
            const SizedBox(height: 24),
            _buildDangerZone(context),
            const Spacer(),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<ThemeMode>(
              value: _themeMode,
              onChanged: (newThemeMode) {
                setState(() {
                  _themeMode = newThemeMode!;
                });
                widget.settingsController.updateThemeMode(newThemeMode);
              },
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                    value: ThemeMode.system, child: Text('System Theme')),
                DropdownMenuItem(
                    value: ThemeMode.light, child: Text('Light Theme')),
                DropdownMenuItem(
                    value: ThemeMode.dark, child: Text('Dark Theme')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Danger Zone',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmationDialog(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete Account',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: widget.settingsController.signOut,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Logout', style: TextStyle(fontSize: 18)),
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
                await widget.settingsController.deleteSelf();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
