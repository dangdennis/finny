import 'package:flutter/material.dart';

class OnboardingItem extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final VoidCallback? onTap;
  final String? subtitle;

  const OnboardingItem({
    super.key,
    required this.title,
    required this.isCompleted,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.circle_outlined,
        color: isCompleted ? Colors.green : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: isCompleted ? null : onTap,
    );
  }
}
