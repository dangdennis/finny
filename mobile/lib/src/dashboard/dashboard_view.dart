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
    _fetchGoals();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchGoals();
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

  void _fetchGoals() async {
    setState(() {
      _goalsFuture = widget.goalsController.getGoals();
    });
  }

  void _unfocusAll() {
    _nameFocusNode.unfocus();
    _amountFocusNode.unfocus();
    _currentAgeFocusNode.unfocus();
    _retirementAgeFocusNode.unfocus();
  }

  static const _goalsCardHeight = 160.0;

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
        label: const Text('Goals'),
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
                          padding: const EdgeInsets.all(8.0),
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
                                    return const SizedBox(
                                      height: _goalsCardHeight,
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator())),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const SizedBox(
                                      height: _goalsCardHeight,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                                    'Failed to load goals')),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return SizedBox(
                                      height: _goalsCardHeight,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          Routes.goalsNew);
                                                },
                                                child: const Text(
                                                    'Add your first goal'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
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
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
