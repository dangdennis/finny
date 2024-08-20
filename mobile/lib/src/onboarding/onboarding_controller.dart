import 'package:finny/src/onboarding/onboarding_cache.dart';
import 'package:finny/src/profile/profile_service.dart';

class OnboardingController {
  OnboardingController({required this.profileService});

  final ProfileService profileService;

  Future<void> setOnboarded() async {
    await OnboardingCache.setOnboarded();
  }

  Future<bool> isOnboarded() async {
    final profile = await profileService.getProfile();
    final isOnboarded = await OnboardingCache.isOnboarded();
    return !isOnboarded &&
        profile.dateOfBirth == null &&
        profile.retirementAge == null &&
        profile.riskProfile == null &&
        profile.fireProfile == null;
  }
}
