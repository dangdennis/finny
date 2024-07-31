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
