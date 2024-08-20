import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCache {
  static Future<SharedPreferencesWithCache> getInstance() async {
    return await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // When an allowlist is included, any keys that aren't included cannot be used.
        allowList: <String>{'is_onboarded'},
      ),
    );
  }

  static Future<void> setOnboarded() async {
    final SharedPreferencesWithCache prefsWithCache = await getInstance();
    await prefsWithCache.setBool('is_onboarded', true);
  }

  static Future<bool> isOnboarded() async {
    final SharedPreferencesWithCache prefsWithCache = await getInstance();
    return prefsWithCache.getBool('is_onboarded') ?? false;
  }
}
