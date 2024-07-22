import 'package:finny/src/accounts/account.dart';
import 'package:finny/src/institutions/institutions_model.dart';

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

  String get institutionName => institutions[institutionId]?.name ?? 'Unknown';

  @override
  String toString() {
    return 'PlaidItem{id: $id, institutionId: $institutionId, status: $status, createdAt: $createdAt, lastSyncedAt: $lastSyncedAt, lastSyncError: $lastSyncError, lastSyncErrorAt: $lastSyncErrorAt, retryCount: $retryCount, accounts: $accounts}';
  }
}
