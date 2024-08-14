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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: StreamBuilder<List<Account>>(
          stream: widget.goalsController.watchAccounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No accounts available.'));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Assigned Accounts',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                ...snapshot.data!.map((account) {
                  double sliderValue = 0;
                  int? selectedPercentage;

                  void updateSliderValue(int? percentage) {
                    setState(() {
                      selectedPercentage = percentage;
                      sliderValue = percentage?.toDouble() ?? 0.0;
                    });
                  }

                  return Column(
                    children: [
                      ListTile(
                        title: Text(account.name),
                        subtitle: Text(account.type ?? ''),
                        trailing: Switch(
                          value: true, // Assume it's enabled
                          onChanged: (bool value) {
                            // Handle toggle switch
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 25, label: Text('25%')),
                          ButtonSegment(value: 50, label: Text('50%')),
                          ButtonSegment(value: 75, label: Text('75%')),
                          ButtonSegment(value: 100, label: Text('100%')),
                        ],
                        selected: {selectedPercentage ?? -1},
                        onSelectionChanged: (newSelection) {
                          if (newSelection.isNotEmpty) {
                            updateSliderValue(newSelection.first);
                          } else {
                            setState(() {
                              selectedPercentage = null;
                            });
                          }
                        },
                      ),
                      Slider(
                        value: sliderValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '${sliderValue.round()}%',
                        onChanged: (double value) {
                          setState(() {
                            sliderValue = value;
                            selectedPercentage =
                                [25, 50, 75, 100].contains(value.round())
                                    ? value.round()
                                    : null;
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
