import 'package:flutter/material.dart';

class GoalCardTitle extends StatelessWidget {
  const GoalCardTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Goals",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
