import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({
    super.key,
    required this.goalsController,
  });

  static const routeName = Routes.dashboard;
  final GoalsController goalsController;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Retirement Fund');
  final TextEditingController _amountController =
      TextEditingController(text: '0');
  final TextEditingController _currentAgeController = TextEditingController();
  final TextEditingController _retirementAgeController =
      TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _currentAgeFocusNode = FocusNode();
  final FocusNode _retirementAgeFocusNode = FocusNode();

  late Future<List<Goal>> _goalsFuture;

  @override
  void initState() {
    super.initState();
    _goalsFuture = _fetchGoals();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _currentAgeController.dispose();
    _retirementAgeController.dispose();
    _nameFocusNode.dispose();
    _amountFocusNode.dispose();
    _currentAgeFocusNode.dispose();
    _retirementAgeFocusNode.dispose();
    super.dispose();
  }

  Future<List<Goal>> _fetchGoals() async {
    return widget.goalsController.getGoals();
  }

  Future<void> _deleteGoal(Goal goal) async {
    await widget.goalsController.deleteGoal(goal);
    setState(() {
      _goalsFuture = _fetchGoals();
    });
  }

  void _unfocusAll() {
    _nameFocusNode.unfocus();
    _amountFocusNode.unfocus();
    _currentAgeFocusNode.unfocus();
    _retirementAgeFocusNode.unfocus();
  }

  void _confirmDeleteGoal(Goal goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Goal'),
          content: const Text('Are you sure you want to delete this goal?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteGoal(goal);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // navigate to the new goal form
          Navigator.of(context).pushNamed(Routes.goalsNew);
        },
        label: const Text('Add Goal'),
        icon: const Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: _unfocusAll,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[400]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Transform.translate(
                  offset: const Offset(0, -100),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Goals",
                                    textAlign: TextAlign.left,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                              FutureBuilder<List<Goal>>(
                                future: _goalsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: Text('Failed to load goals'));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                        child: Text('No goals added yet'));
                                  } else {
                                    final goals = snapshot.data!;
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: goals.length,
                                      itemBuilder: (context, index) {
                                        final goal = goals[index];
                                        return ListTile(
                                          title: Text(goal.name),
                                          subtitle: Text(
                                            'Amount: \$${goal.amount.toStringAsFixed(2)}, Date: ${DateFormat.yMMMd().format(goal.targetDate)}',
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline),
                                            onPressed: () =>
                                                _confirmDeleteGoal(goal),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        )),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
