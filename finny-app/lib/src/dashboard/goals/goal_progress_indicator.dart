import 'package:flutter/material.dart';

class GoalProgressIndicator extends StatefulWidget {
  final double progress;
  const GoalProgressIndicator({
    required this.progress,
    super.key,
  });

  @override
  State<GoalProgressIndicator> createState() => _GoalProgressIndicatorState();
}

class _GoalProgressIndicatorState extends State<GoalProgressIndicator> {
  bool _showProgressText = false;

  void _toggleProgressView() {
    setState(() {
      _showProgressText = !_showProgressText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleProgressView,
      child: _showProgressText
          ? Text(
              '${((widget.progress) * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          : SizedBox(
              height: 32,
              width: 32,
              child: CircularProgressIndicator(
                value: widget.progress,
                strokeWidth: 4.0,
                backgroundColor: Colors.grey[400],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
    );
  }
}
