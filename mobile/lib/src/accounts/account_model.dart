typedef AccountId = String;

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
  final String? mask;
  final String? officialName;
  final double currentBalance;
  final double availableBalance;
  final String? isoCurrencyCode;
  final String? unofficialCurrencyCode;
  final String? type;
  final String? subtype;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  @override
  String toString() {
    return 'Account{id: $id, itemId: $itemId, userId: $userId, name: $name, mask: $mask, officialName: $officialName, currentBalance: $currentBalance, availableBalance: $availableBalance, isoCurrencyCode: $isoCurrencyCode, unofficialCurrencyCode: $unofficialCurrencyCode, type: $type, subtype: $subtype, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
