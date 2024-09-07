typedef GoalId = String;

class Goal {
  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.targetDate,
    required this.progress,
    required this.goalType,
  });

  final String id;
  final String name;
  final double targetAmount;
  final DateTime targetDate;
  final double? progress;
  final GoalType goalType;
}

enum GoalType {
  retirement,
  custom;

  static GoalType fromString(String value) {
    return GoalType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Invalid GoalType: $value'),
    );
  }

  @override
  toString() {
    switch (this) {
      case GoalType.retirement:
        return 'retirement';
      case GoalType.custom:
        return 'custom';
    }
  }
}

class GoalAccount {
  GoalAccount({
    required this.id,
    required this.goalId,
    required this.accountId,
    required this.percentage,
  });

  final String id;
  final String goalId;
  final String accountId;
  final double percentage;
}
