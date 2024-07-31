class Transaction {
  const Transaction({
    required this.id,
    required this.accountId,
    required this.category,
    this.subcategory,
    required this.type,
    required this.name,
    required this.amount,
    required this.isoCurrencyCode,
    this.unofficialCurrencyCode,
    required this.date,
    required this.pending,
    this.accountOwner,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String accountId;
  final String category;
  final String? subcategory;
  final String type;
  final String name;
  final double amount;
  final String isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String date;
  final int pending;
  final String? accountOwner;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
}
