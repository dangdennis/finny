import 'package:drift/drift.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:finny/src/profile/profile_model.dart';

class ProfileService {
  ProfileService({required this.appDb});

  final AppDatabase appDb;

  Stream<Profile?> watchProfile() {
    return appDb.select(appDb.profilesDb).watchSingleOrNull().map(
        (profileOpt) =>
            profileOpt != null ? profileDbToDomain(profileOpt) : null);
  }

  Future<Profile?> getProfile() async {
    final query = appDb.select(appDb.profilesDb);
    final profile = await query.getSingleOrNull();
    if (profile == null) {
      return null;
    }
    return profileDbToDomain(profile);
  }

  Future<void> updateProfile(ProfileUpdateInput profile) async {
    final query = appDb.update(appDb.profilesDb);
    await query.write(
      ProfilesDbCompanion(
        dateOfBirth: profile.dateOfBirth != null
            ? Value((profile.dateOfBirth!.millisecondsSinceEpoch ~/ 1000)
                .toString())
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
    final p = Profile(
      id: profile.id,
      dateOfBirth: profile.dateOfBirth != null
          ? DateTime.tryParse(profile.dateOfBirth!)
          : null,
      retirementAge: profile.retirementAge,
      riskProfile: profile.riskProfile != null
          ? RiskProfile.fromString(profile.riskProfile!)
          : null,
      fireProfile: profile.fireProfile != null
          ? FireProfile.fromString(profile.fireProfile!)
          : null,
    );
    return p;
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
