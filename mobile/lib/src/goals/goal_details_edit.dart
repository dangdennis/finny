import 'dart:math';

import 'package:finny/src/goals/goal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GoalDetailsEdit extends StatefulWidget {
  const GoalDetailsEdit({
    super.key,
    required this.goal,
    required this.onGoalSave,
    required this.nameFocusNode,
    required this.targetAmountFocusNode,
    required this.targetDateFocusNode,
  });

  final FocusNode nameFocusNode;
  final FocusNode targetAmountFocusNode;
  final FocusNode targetDateFocusNode;
  final Future<void> Function(Goal) onGoalSave;
  final Goal goal;

  @override
  State<GoalDetailsEdit> createState() => _GoalDetailsEditState();
}

class _GoalDetailsEditState extends State<GoalDetailsEdit> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late DateTime targetDate;

  static const int maxNameLength = 50;
  static const double maxAmount = 999999999.0;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.goal.name);
    amountController = TextEditingController(
        text: widget.goal.targetAmount.toStringAsFixed(2));
    targetDate = widget.goal.targetDate;
    widget.nameFocusNode.addListener(_handleNameFocusChange);
    widget.targetAmountFocusNode.addListener(_handleTargetAmountFocusChange);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: targetDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != targetDate) {
      setState(() {
        targetDate = picked;
      });
      await _saveGoal();
    }
  }

  Future<void> _saveGoal() async {
    double parsedAmount = double.tryParse(amountController.text) ?? 0.0;
    if (parsedAmount > maxAmount) {
      parsedAmount = maxAmount;
    }

    final goal = Goal(
      id: widget.goal.id,
      name: nameController.text,
      targetAmount: parsedAmount,
      targetDate: targetDate,
      progress: widget.goal.progress,
    );
    await widget.onGoalSave(goal);
  }

  void _handleNameFocusChange() {
    if (!widget.nameFocusNode.hasFocus && _nameHasChanged()) {
      _saveGoal();
    }
  }

  void _handleTargetAmountFocusChange() {
    if (!widget.targetAmountFocusNode.hasFocus && _amountHasChanged()) {
      _saveGoal();
    }
  }

  bool _nameHasChanged() {
    return nameController.text != widget.goal.name;
  }

  bool _amountHasChanged() {
    double parsedAmount = double.tryParse(amountController.text) ?? 0.0;
    return parsedAmount != widget.goal.targetAmount;
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double amountLeft = double.tryParse(amountController.text) ??
        0.0 - (widget.goal.targetAmount * (widget.goal.progress ?? 0));
    final double progressPercentage = (widget.goal.progress ?? 0) * 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    focusNode: widget.nameFocusNode,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(maxNameLength),
                    ],
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    onFieldSubmitted: (value) => _saveGoal(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Target Amount',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: amountController,
                    focusNode: widget.targetAmountFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                      AmountLimitingTextInputFormatter(maxAmount: maxAmount),
                    ],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      prefixText: '\$',
                    ),
                    onFieldSubmitted: (value) => _saveGoal(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Target Date',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        focusNode: widget.targetDateFocusNode,
                        controller: TextEditingController(
                          text: DateFormat.yMMMd().format(targetDate),
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16), // Add some space between columns
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Amount Left to Save',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${amountLeft.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Progress',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${progressPercentage.toStringAsFixed(2)}%',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(10),
          value: max(0.03, widget.goal.progress ?? 0),
          minHeight: 10,
          backgroundColor: Colors.grey[400],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ],
    );
  }
}

class AmountLimitingTextInputFormatter extends TextInputFormatter {
  final double maxAmount;

  AmountLimitingTextInputFormatter({required this.maxAmount});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    double? parsedValue = double.tryParse(newValue.text);
    if (parsedValue != null && parsedValue > maxAmount) {
      // If the new value exceeds maxAmount, keep the old value
      return oldValue;
    }

    // Otherwise, allow the new value
    return newValue;
  }
}
