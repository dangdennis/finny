enum RiskProfile {
  conservative,
  moderate,
  aggressive,
}

enum FireProfile {
  lean,
  traditional,
  fat,
  barista,
  slow,
  coast,
}

class Profile {
  Profile({
    required this.id,
    this.age,
    this.dateOfBirth,
    this.retirementAge,
    this.riskProfile,
    this.fireProfile,
  });

  final String id;
  final int? age;
  final DateTime? dateOfBirth;
  final int? retirementAge;
  final RiskProfile? riskProfile;
  final FireProfile? fireProfile;
}
