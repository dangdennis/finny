import 'package:flutter/material.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Calculator'),
      ),
      body: const Center(
        child: Text('Financial Calculator'),
      ),
    );
  }
}
