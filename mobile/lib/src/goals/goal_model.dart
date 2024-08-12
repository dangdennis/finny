class Goal {
  Goal({
    required this.id,
    required this.name,
    required this.amount,
    required this.targetDate,
    required this.progress,
  });

  final String id;
  final String name;
  final double amount;
  final DateTime targetDate;
  final double? progress;
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
