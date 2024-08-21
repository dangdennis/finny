import 'package:drift/drift.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:finny/src/profile/profile_model.dart';

class ProfileService {
  ProfileService({required this.appDb});

  final AppDatabase appDb;

  Future<Profile> getProfile() async {
    final query = appDb.select(appDb.profilesDb);
    return profileDbToDomain(await query.getSingle());
  }

  Future<void> updateProfile(ProfileUpdateInput profile) async {
    final query = appDb.update(appDb.profilesDb);
    await query.write(
      ProfilesDbCompanion(
        age: profile.dateOfBirth != null
            ? Value(
                DateTime.now().difference(profile.dateOfBirth!).inDays ~/ 365)
            : const Value.absent(),
        dateOfBirth: profile.dateOfBirth != null
            ? Value(profile.dateOfBirth)
            : const Value.absent(),
        retirementAge: profile.retirementAge != null
            ? Value(profile.retirementAge)
            : const Value.absent(),
        riskProfile: profile.riskProfile != null
            ? Value(profile.riskProfile?.toString())
            : const Value.absent(),
        fireProfile: profile.fireProfile != null
            ? Value(profile.fireProfile?.toString())
            : const Value.absent(),
      ),
    );
  }

  Profile profileDbToDomain(ProfilesDbData profile) {
    return Profile(
      id: profile.id,
      age: profile.age,
      dateOfBirth: profile.dateOfBirth,
      retirementAge: profile.retirementAge,
      riskProfile: profile.riskProfile != null
          ? RiskProfile.fromString(profile.riskProfile!)
          : null,
      fireProfile: profile.fireProfile != null
          ? FireProfile.fromString(profile.fireProfile!)
          : null,
    );
  }
}

class ProfileUpdateInput {
  ProfileUpdateInput(
      {this.dateOfBirth,
      this.retirementAge,
      this.riskProfile,
      this.fireProfile});

  final DateTime? dateOfBirth;
  final int? retirementAge;
  final RiskProfile? riskProfile;
  final FireProfile? fireProfile;
}
