import 'package:finny/src/goals/goals_controller.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalsNewFormView extends StatefulWidget {
  const GoalsNewFormView({
    super.key,
    required this.goalsController,
  });

  static const routeName = Routes.goalsNew;
  final GoalsController goalsController;

  @override
  State<GoalsNewFormView> createState() => _GoalsNewFormViewState();
}

class _GoalsNewFormViewState extends State<GoalsNewFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(text: '');
  final TextEditingController _amountController =
      TextEditingController(text: '0');
  final TextEditingController _targetDateController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _targetDateFocusNode = FocusNode();

  GoalType _selectedGoalType = GoalType.custom;
  bool _retirementGoalExists = false;

  @override
  void initState() {
    super.initState();
    _checkRetirementGoal();
  }

  Future<void> _checkRetirementGoal() async {
    final retirementGoal = await widget.goalsController.getRetirementGoal();
    setState(() {
      _retirementGoalExists = retirementGoal != null;
      _selectedGoalType =
          _retirementGoalExists ? GoalType.custom : GoalType.retirement;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _targetDateController.dispose();
    _nameFocusNode.dispose();
    _amountFocusNode.dispose();
    _targetDateFocusNode.dispose();
    super.dispose();
  }

  void _addGoal() async {
    if (_formKey.currentState!.validate()) {
      double amount = double.tryParse(_amountController.text) ?? 0.0;
      DateTime targetDate =
          DateFormat('yyyy-MM-dd').parse(_targetDateController.text);

      await widget.goalsController.addGoal(AddGoalInput(
        name: _nameController.text,
        amount: amount,
        targetDate: targetDate,
        goalType: _selectedGoalType,
      ));
    }
  }

  Future<void> _deleteGoal(Goal goal) async {
    await widget.goalsController.deleteGoal(goal);
  }

  void _unfocusAll() {
    _nameFocusNode.unfocus();
    _amountFocusNode.unfocus();
    _targetDateFocusNode.unfocus();
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _targetDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals Form'),
      ),
      body: GestureDetector(
        onTap: _unfocusAll,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add a New Goal',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20.0),
                      SegmentedButton<GoalType>(
                        segments: [
                          ButtonSegment<GoalType>(
                            value: GoalType.retirement,
                            label: const Text('Retirement'),
                            enabled: !_retirementGoalExists,
                          ),
                          const ButtonSegment<GoalType>(
                            value: GoalType.custom,
                            label: Text('Custom'),
                          ),
                        ],
                        selected: {_selectedGoalType},
                        onSelectionChanged: (Set<GoalType> newSelection) {
                          setState(() {
                            _selectedGoalType = newSelection.first;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _amountController,
                        focusNode: _amountFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(16),
                          prefixText: '\$',
                          suffixIcon: Tooltip(
                            message:
                                'Amount is optional, and if not provided, will be computed based on your spending.',
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: Duration(seconds: 5),
                            child: Icon(Icons.info_outline),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _targetDateController,
                        focusNode: _targetDateFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Target Date',
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a target date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _addGoal,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text('Add Goal'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                StreamBuilder<List<Goal>>(
                  stream: widget.goalsController.watchGoals(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Failed to load goals'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('Still awaiting your first goal 🤠'));
                    } else {
                      final goals = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: goals.length,
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(goal.name),
                                subtitle: Text(
                                  'Amount: \$${goal.targetAmount.toStringAsFixed(2)}, Date: ${DateFormat.yMMMd().format(goal.targetDate)}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _confirmDeleteGoal(goal),
                                ),
                              ),
                              if (goal.goalType == GoalType.retirement) ...[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Column(
                                    children: [
                                      SizedBox(width: 8),
                                      Text('retirement'),
                                    ],
                                  ),
                                ),
                              ]
                            ],
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
    );
  }
}
