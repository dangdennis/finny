import 'dart:math';

import 'package:flutter/material.dart';

class GradientBanner extends StatelessWidget {
  const GradientBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(1),
                Colors.primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0.0, -100.0),
          child: child,
        )
      ],
    );
  }
}
