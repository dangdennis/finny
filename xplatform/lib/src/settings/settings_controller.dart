import 'package:finny/src/auth/auth_service.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:finny/src/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(
      {required this.settingsService,
      required this.authService,
      required this.profileService});

  final SettingsService settingsService;
  final ProfileService profileService;
  final AuthService authService;
  final Logger logger = Logger('SettingsController');

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _themeMode = await settingsService.themeMode();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) {
      return;
    }

    if (newThemeMode == _themeMode) {
      return;
    }

    _themeMode = newThemeMode;
    notifyListeners();
    await settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> deleteSelf() async {
    await authService.deleteSelf();
  }

  Future<void> signOut() async {
    await authService.signOut();
  }

  Stream<Profile?> watchProfile() {
    try {
      return profileService.watchProfile();
    } catch (e) {
      logger.severe('Error watching profile', e);
      rethrow;
    }
  }
}
