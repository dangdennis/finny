/// A placeholder class that represents an entity or model.
class Account {
  const Account({
    required this.id,
    required this.itemId,
    required this.userId,
    required this.name,
    required this.mask,
    required this.officialName,
    required this.currentBalance,
    required this.availableBalance,
    required this.isoCurrencyCode,
    this.unofficialCurrencyCode,
    required this.type,
    required this.subtype,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String itemId;
  final String userId;
  final String name;
  final String mask;
  final String officialName;
  final double currentBalance;
  final double availableBalance;
  final String isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String type;
  final String subtype;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
}
