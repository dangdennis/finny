import 'package:finny/src/powersync/database.dart';
import 'package:finny/src/profile/profile_model.dart';

class ProfileService {
  ProfileService({required this.appDb});

  final AppDatabase appDb;

  /// Get the current retirement interest return for all investment accounts.
  /// This is the sum of the current balance of all investment accounts multiplied by the 4% interest rate.
  Future<Profile> getProfile() async {
    final result = await appDb.customSelect('''
      SELECT
        age, 
        date_of_birth,
        retirement_age,
        risk_profile,
        fire_profile
      FROM
        profiles
    ''').getSingle();

    return Profile(
        id: result.read<String>('id'),
        age: result.read<int>('age'),
        dateOfBirth: result.read<DateTime>('date_of_birth'),
        retirementAge: result.read<int>('retirement_age'),
        riskProfile: result.read<RiskProfile>('risk_profile'),
        fireProfile: result.read<FireProfile>('fire_profile'));
  }
}
