import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCache {
  static const String _onboardedKey = 'is_onboarded';

  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  static Future<void> setOnboarded() async {
    final SharedPreferences prefs = await getInstance();
    await prefs.setBool(_onboardedKey, true);
  }

  static Future<bool> isOnboarded() async {
    final SharedPreferences prefs = await getInstance();
    return prefs.getBool(_onboardedKey) ?? false;
  }
}
