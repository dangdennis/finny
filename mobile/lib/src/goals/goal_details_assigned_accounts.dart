import 'package:finny/src/accounts/account_model.dart';
import 'package:finny/src/goals/goals_controller.dart';
import 'package:flutter/material.dart';

class GoalDetailsAssignedAccounts extends StatefulWidget {
  const GoalDetailsAssignedAccounts({super.key, required this.goalsController});

  final GoalsController goalsController;

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
      final accounts = await widget.goalsController.getAccounts();
      setState(() {
        _cachedAccounts = accounts;
      });
    } catch (error) {
      // Handle the error appropriately (e.g., show a snackbar)
      setState(() {
        _cachedAccounts = [];
      });
    }
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
                          setState(() {
                            _enabledStates[accountId] = value;
                          });
                        },
                        onSliderChanged: (double value) {
                          setState(() {
                            _progressValues[accountId] = value;
                          });
                        },
                        onSegmentChanged: (int value) {
                          setState(() {
                            _progressValues[accountId] = value.toDouble();
                          });
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
