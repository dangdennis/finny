import 'package:finny/src/accounts/accounts_service.dart';
import 'package:finny/src/onboarding/onboarding_cache.dart';
import 'package:finny/src/profile/profile_model.dart';
import 'package:finny/src/profile/profile_service.dart';
import 'package:logging/logging.dart';

class OnboardingController {
  OnboardingController(
      {required this.profileService, required this.accountService});

  final ProfileService profileService;
  final AccountsService accountService;
  final Logger _logger = Logger('OnboardingController');

  Future<void> setOnboarded() async {
    await OnboardingCache.setOnboarded();
  }

  Future<OnboardingState> isOnboarded() async {
    try {
      final profile = await profileService.getProfile();
      return OnboardingState(
          accountsAdded: await _isAccountsAdded(),
          profileCompleted: _isProfileCompleted(profile));
    } catch (e) {
      _logger.warning('Error getting profile: $e');
      rethrow;
    }
  }

  Future<Profile> getProfile() async {
    return await profileService.getProfile();
  }

  Future<void> updateProfile(ProfileUpdateInput profile) async {
    await profileService.updateProfile(profile);
  }

  bool _isProfileCompleted(Profile profile) {
    return (profile.dateOfBirth != null &&
        profile.retirementAge != null &&
        profile.riskProfile != null &&
        profile.fireProfile != null);
  }

  Future<bool> _isAccountsAdded() async {
    final accounts = await accountService.getAccounts(null);
    return accounts.isNotEmpty;
  }
}

class OnboardingState {
  OnboardingState(
      {required this.profileCompleted, required this.accountsAdded});

  final bool profileCompleted;
  final bool accountsAdded;
  bool get isOnboardingComplete => profileCompleted && accountsAdded;
}
