import 'package:finny/src/accounts/account.dart';

class PlaidItem {
  final String id;
  final String institutionId;
  final String status;
  final DateTime createdAt;
  final DateTime? lastSyncedAt;
  final String? lastSyncError;
  final DateTime? lastSyncErrorAt;
  final int retryCount;
  List<Account> accounts;

  PlaidItem({
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

  factory PlaidItem.fromJson(Map<String, dynamic> json) {
    return PlaidItem(
        id: json['id'],
        institutionId: json['institutionId'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
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
}
