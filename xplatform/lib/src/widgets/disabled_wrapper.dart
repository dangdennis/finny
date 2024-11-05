import 'package:flutter/material.dart';

class DisabledWrapper extends StatelessWidget {
  final bool isDisabled;
  final Widget child;

  const DisabledWrapper({
    super.key,
    required this.isDisabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: child,
      ),
    );
  }
}
