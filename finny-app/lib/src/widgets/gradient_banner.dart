import 'dart:math';
import 'package:flutter/material.dart';

class GradientBanner extends StatefulWidget {
  const GradientBanner({super.key, required this.child});

  final Widget child;

  @override
  State<GradientBanner> createState() => _GradientBannerState();
}

class _GradientBannerState extends State<GradientBanner> {
  late final List<Color> colors;

  @override
  void initState() {
    super.initState();
    colors = [
      Colors.primaries[Random().nextInt(Colors.primaries.length)].withAlpha(1),
      Colors.primaries[Random().nextInt(Colors.primaries.length)]
          .withValues(alpha: 0.8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0.0, -110.0),
          child: widget.child,
        ),
      ],
    );
  }
}
