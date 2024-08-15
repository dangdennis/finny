import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:flutter/material.dart';

class GoalDetailsAssignedAccounts extends StatefulWidget {
  const GoalDetailsAssignedAccounts({
    super.key,
    required this.goalId,
    required this.getAccounts,
    required this.onAccountAssignOrUpdate,
    required this.onAccountUnassign,
  });

  final String goalId;
  final Function(
      {required GoalId goalId,
      required AccountId accountId,
      double? progress}) onAccountAssignOrUpdate;
  final Function({required GoalId goalId, required AccountId accountId})
      onAccountUnassign;
  final Function() getAccounts;

  @override
  State<GoalDetailsAssignedAccounts> createState() =>
      _GoalDetailsAssignedAccountsState();
}

class _GoalDetailsAssignedAccountsState
    extends State<GoalDetailsAssignedAccounts> {
  List<Account> _cachedAccounts = [];
  final Map<String, double> _progressValues = {};
  final Map<String, bool> _enabledStates = {};

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await widget.getAccounts();
      setState(() {
        _cachedAccounts = accounts
            .where((account) =>
                account.type == "investment" || account.type == "depository")
            .toList();
      });
    } catch (error) {
      final ctx = context;
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Unable to load accounts: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() {
        _cachedAccounts = [];
      });
    }
  }

  void _handleAccountToggle(
      {required GoalId goalId,
      required AccountId accountId,
      required bool value}) {
    if (value) {
      widget.onAccountAssignOrUpdate(
        goalId: goalId,
        accountId: accountId,
        progress: _progressValues[accountId] ?? 0,
      );
    } else {
      widget.onAccountUnassign(goalId: goalId, accountId: accountId);
    }

    setState(() {
      _enabledStates[accountId] = value;
    });
  }

  void _handleProgressChange(
      {required AccountId accountId, required double progress}) {
    widget.onAccountAssignOrUpdate(
      goalId: widget.goalId,
      accountId: accountId,
      progress: progress,
    );

    setState(() {
      _progressValues[accountId] = progress;
      _enabledStates[accountId] = progress > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: _cachedAccounts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assign Accounts',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._cachedAccounts.map((account) {
                      final accountId = account.id;

                      _progressValues.putIfAbsent(accountId, () => 0);
                      _enabledStates.putIfAbsent(accountId, () => true);

                      return AccountTile(
                        account: account,
                        progressValue: _progressValues[accountId]!,
                        isEnabled: _enabledStates[accountId]!,
                        onToggle: (bool value) {
                          _handleAccountToggle(
                            goalId: widget.goalId,
                            accountId: accountId,
                            value: value,
                          );
                        },
                        onSliderChanged: (double value) {
                          _handleProgressChange(
                            accountId: accountId,
                            progress: value,
                          );
                        },
                        onSegmentChanged: (int value) {
                          _handleProgressChange(
                            accountId: accountId,
                            progress: value.toDouble(),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  const AccountTile({
    super.key,
    required this.account,
    required this.progressValue,
    required this.isEnabled,
    required this.onToggle,
    required this.onSliderChanged,
    required this.onSegmentChanged,
  });

  final Account account;
  final double progressValue;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<int> onSegmentChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(account.name),
          subtitle: Text(account.type ?? ''),
          trailing: Switch(
            value: isEnabled,
            onChanged: onToggle,
          ),
        ),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(
                value: 25, label: Text('25%', style: TextStyle(fontSize: 12))),
            ButtonSegment(
                value: 50, label: Text('50%', style: TextStyle(fontSize: 12))),
            ButtonSegment(
                value: 75, label: Text('75%', style: TextStyle(fontSize: 12))),
            ButtonSegment(
                value: 100,
                label: Text('100%', style: TextStyle(fontSize: 12))),
          ],
          selected: {
            [25, 50, 75, 100].contains(progressValue.round())
                ? progressValue.round()
                : -1
          },
          showSelectedIcon: false,
          onSelectionChanged: (newSelection) {
            if (newSelection.isNotEmpty) {
              onSegmentChanged(newSelection.first);
            }
          },
        ),
        Slider(
          value: progressValue,
          min: 0,
          max: 100,
          divisions: 100,
          label: '${progressValue.round()}%',
          onChanged: onSliderChanged,
        ),
        const Divider(), // Adds some spacing between account tiles
      ],
    );
  }
}
