import 'dart:math';

import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/routes.dart';
import 'package:finny/src/widgets/gradient_banner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoalDetailView extends StatefulWidget {
  const GoalDetailView({super.key, required this.goal});

  final Goal goal;

  static const routeName = Routes.goalDetails;

  @override
  State<GoalDetailView> createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends State<GoalDetailView> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late DateTime targetDate;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _targetAmountFocusNode = FocusNode();
  final FocusNode _targetDateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.goal.name);
    amountController = TextEditingController(
        text: widget.goal.targetAmount.toStringAsFixed(2));
    targetDate = widget.goal.targetDate;
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _unfocusAll() {
    _nameFocusNode.unfocus();
    _targetAmountFocusNode.unfocus();
    _targetDateFocusNode.unfocus();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final double amountLeft = double.tryParse(amountController.text) ??
        0.0 - (widget.goal.targetAmount * (widget.goal.progress ?? 0));
    final double progressPercentage = (widget.goal.progress ?? 0) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Implement save functionality here, e.g., update the goal object and save it to a database.
              print("Save changes");
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _unfocusAll,
        child: GradientBanner(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
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
                                  'Name:',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: nameController,
                                  focusNode: _nameFocusNode,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Amount:',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: amountController,
                                  focusNode: _targetAmountFocusNode,
                                  keyboardType: TextInputType.number,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    prefixText: '\$',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Target Date:',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      focusNode: _targetDateFocusNode,
                                      controller: TextEditingController(
                                        text: DateFormat.yMMMd()
                                            .format(targetDate),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
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
                          const SizedBox(
                              width: 16), // Add some space between columns
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Amount Left to Save:',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${amountLeft.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Progress:',
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
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
