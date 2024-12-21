import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController({
    required this.settingsService,
  });

  final SettingsService settingsService;
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
}
