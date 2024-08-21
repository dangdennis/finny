import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCache {
  static const String _onboardedKey = 'is_onboarded';
  static const String _hiddenKey = 'is_onboarding_card_hidden';

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

  static Future<void> setOnboardingCardHidden(bool hidden) async {
    final SharedPreferences prefs = await getInstance();
    await prefs.setBool(_hiddenKey, hidden);
  }

  static Future<bool> isOnboardingCardHidden() async {
    final SharedPreferences prefs = await getInstance();
    return prefs.getBool(_hiddenKey) ?? false;
  }
}
