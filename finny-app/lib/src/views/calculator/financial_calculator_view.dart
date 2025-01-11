import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finny/src/finance/finance.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _formKey = GlobalKey<FormState>();
  bool _showResults = false;

  final TextEditingController _annualExpenseController =
      TextEditingController();
  final TextEditingController _currentAgeController = TextEditingController();
  final TextEditingController _retirementAgeController =
      TextEditingController();
  final TextEditingController _currentSavingsController =
      TextEditingController();

  String _freedomNumberToday = '';
  String _freedomNumberAtRetirement = '';

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _annualExpenseController.dispose();
    _currentAgeController.dispose();
    _retirementAgeController.dispose();
    _currentSavingsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Financial Independence'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputForm(),
              const SizedBox(height: 20),
              if (_showResults) _buildResults(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _unfocus();
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _freedomNumberToday = _getTargetFreedomNumberAtToday();
                      _freedomNumberAtRetirement =
                          _getTargetFreedomNumberAtRetirement();
                      _showResults = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Calculate', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNumberInput(
            label: 'Annual Expense (\$)',
            hintText: 'Enter your annual expenses',
            controller: _annualExpenseController,
          ),
          const SizedBox(height: 16),
          _buildNumberInput(
            label: 'Current Age',
            hintText: 'Enter your current age',
            controller: _currentAgeController,
          ),
          const SizedBox(height: 16),
          _buildNumberInput(
            label: 'Desired Retirement Age',
            hintText: 'Enter your desired retirement age',
            controller: _retirementAgeController,
          ),
          const SizedBox(height: 16),
          _buildNumberInput(
            label: 'Current Savings (\$)',
            hintText: 'Enter your current savings',
            controller: _currentSavingsController,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required String hintText,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildResults() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildResultRow('Freedom Number Today:', _freedomNumberToday),
            _buildResultRow(
                'Freedom Number at Retirement:', _freedomNumberAtRetirement),
            _buildResultRow('Monthly Savings Goal:', '\$2,500'),
            _buildResultRow('Projected Retirement Savings:', '\$4,000,000'),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLargeNumber(num value) {
    if (value.abs() >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '\$${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }

  String _getTargetFreedomNumberAtToday() {
    double annualExpense = double.tryParse(_annualExpenseController.text) ?? 0;
    double freedomNumber = annualExpense / 12;
    return _formatLargeNumber(freedomNumber);
  }

  String _getTargetFreedomNumberAtRetirement() {
    double annualExpense = double.tryParse(_annualExpenseController.text) ?? 0;
    int currentAge = int.tryParse(_currentAgeController.text) ?? 0;
    int retirementAge = int.tryParse(_retirementAgeController.text) ?? 0;
    double currentSavings =
        double.tryParse(_currentSavingsController.text) ?? 0;

    const double inflationRate = 0.02;
    double nper = (retirementAge - currentAge).toDouble();
    double monthlyExpense = annualExpense / 12;

    num futureValue = Finance.fv(
      rate: inflationRate,
      nper: nper,
      pmt: monthlyExpense,
      pv: currentSavings,
    );
    return _formatLargeNumber(futureValue.abs());
  }
}
