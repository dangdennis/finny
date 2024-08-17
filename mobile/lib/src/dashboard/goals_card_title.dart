import 'package:flutter/material.dart';

class GoalsCardTitle extends StatelessWidget {
  const GoalsCardTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Goals",
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
