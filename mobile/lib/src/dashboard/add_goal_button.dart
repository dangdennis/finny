import 'package:finny/src/routes.dart';
import 'package:flutter/material.dart';

class AddGoalButton extends StatelessWidget {
  const AddGoalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.goalsNew);
      },
      label: const Text('Goals'),
      icon: const Icon(Icons.add),
    );
  }
}
