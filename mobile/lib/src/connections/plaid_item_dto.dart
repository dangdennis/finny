import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/connections/plaid_item.dart';

class PlaidItemDto {
  final String id;
  final String institutionId;
  final String status;
  final DateTime createdAt;
  final DateTime? lastSyncedAt;
  final String? lastSyncError;
  final DateTime? lastSyncErrorAt;
  final int retryCount;
  List<Account> accounts;

  PlaidItemDto({
    required this.id,
    required this.institutionId,
    required this.status,
    required this.createdAt,
    this.lastSyncedAt,
    this.lastSyncError,
    this.lastSyncErrorAt,
    required this.retryCount,
    required this.accounts,
  });

  factory PlaidItemDto.fromJson(Map<String, dynamic> json) {
    return PlaidItemDto(
        id: json['id'],
        institutionId: json['institutionId'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastSyncedAt: json['lastSyncedAt'] != null
            ? DateTime.parse(json['lastSyncedAt'])
            : null,
        lastSyncError: json['lastSyncError'],
        lastSyncErrorAt: json['lastSyncErrorAt'] != null
            ? DateTime.parse(json['lastSyncErrorAt'])
            : null,
        retryCount: json['retryCount'],
        accounts: []);
  }

  PlaidItem toModel() {
    return PlaidItem(
      id: id,
      institutionId: institutionId,
      status: status,
      createdAt: createdAt,
      lastSyncedAt: lastSyncedAt,
      lastSyncError: lastSyncError,
      lastSyncErrorAt: lastSyncErrorAt,
      retryCount: retryCount,
      accounts: accounts,
    );
  }

  @override
  String toString() {
    return 'PlaidItemDto{id: $id, institutionId: $institutionId, status: $status, createdAt: $createdAt, lastSyncedAt: $lastSyncedAt, lastSyncError: $lastSyncError, lastSyncErrorAt: $lastSyncErrorAt, retryCount: $retryCount, accounts: $accounts}';
  }
}
