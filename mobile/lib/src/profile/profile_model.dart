enum RiskProfile {
  conservative,
  balanced,
  aggressive;

  static RiskProfile fromString(String value) {
    return RiskProfile.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Invalid RiskProfile: $value'),
    );
  }

  @override
  toString() {
    switch (this) {
      case RiskProfile.conservative:
        return 'conservative';
      case RiskProfile.balanced:
        return 'balanced';
      case RiskProfile.aggressive:
        return 'aggressive';
    }
  }
}

enum FireProfile {
  lean,
  traditional,
  fat,
  barista,
  slow,
  coast;

  static FireProfile fromString(String value) {
    return FireProfile.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Invalid FireProfile: $value'),
    );
  }

  @override
  toString() {
    switch (this) {
      case FireProfile.lean:
        return 'lean';
      case FireProfile.traditional:
        return 'traditional';
      case FireProfile.fat:
        return 'fat';
      case FireProfile.barista:
        return 'barista';
      case FireProfile.slow:
        return 'slow';
      case FireProfile.coast:
        return 'coast';
    }
  }
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
