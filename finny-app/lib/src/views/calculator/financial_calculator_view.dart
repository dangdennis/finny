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
  final TextEditingController _monthlySavingsController =
      TextEditingController();

  String _freedomNumberToday = '';
  String _freedomNumberAtRetirement = '';
  String _monthlySavingsGoal = '';
  String _actualFreedomNumber = '';
  String _actualRetirementAge = '';

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    _annualExpenseController.dispose();
    _currentAgeController.dispose();
    _retirementAgeController.dispose();
    _currentSavingsController.dispose();
    _monthlySavingsController.dispose();
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
              const SizedBox(height: 10),
              if (_showResults) _buildResults(),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  _unfocus();
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _freedomNumberToday = _formatLargeNumber(
                          _getTargetFreedomNumberAtToday().abs());
                      _freedomNumberAtRetirement =
                          printTargetFreedomNumberAtRetirement();
                      _monthlySavingsGoal = printTargetMonthlyFreedomSavings();
                      _actualFreedomNumber = printActualFreedomNumber();
                      _actualRetirementAge = printActualRetirementAge();
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
          const SizedBox(height: 12),
          _buildNumberInput(
            label: 'Current Age',
            hintText: 'Enter your current age',
            controller: _currentAgeController,
          ),
          const SizedBox(height: 12),
          _buildNumberInput(
            label: 'Desired Retirement Age',
            hintText: 'Enter your desired retirement age',
            controller: _retirementAgeController,
          ),
          const SizedBox(height: 12),
          _buildNumberInput(
            label: 'Current Savings (\$)',
            hintText: 'Enter your current savings',
            controller: _currentSavingsController,
          ),
          const SizedBox(height: 12),
          _buildNumberInput(
            label: 'Monthly Savings (\$)',
            hintText: 'Enter your monthly savings',
            controller: _monthlySavingsController,
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          isDense: true),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildResultRow('Freedom Number Today:', _freedomNumberToday),
            _buildResultRow(
                'Freedom Number at Retirement:', _freedomNumberAtRetirement),
            _buildResultRow('Monthly Savings Goal:', _monthlySavingsGoal),
            _buildResultRow('Actual Retirement Savings:', _actualFreedomNumber),
            _buildResultRow('Actual Retirement Age:', _actualRetirementAge),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
    return '\$${value.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  num _getTargetFreedomNumberAtToday() {
    double annualExpense = double.tryParse(_annualExpenseController.text) ?? 0;
    double freedomNumber = annualExpense / 0.04;
    return freedomNumber;
  }

  num _getTargetFreedomNumberAtRetirement() {
    int currentAge = int.tryParse(_currentAgeController.text) ?? 0;
    int retirementAge = int.tryParse(_retirementAgeController.text) ?? 0;
    final pv = _getTargetFreedomNumberAtToday();

    const double inflationRate = 0.02;
    double nper = (retirementAge - currentAge).toDouble();

    num futureValue = Finance.fv(
      rate: inflationRate,
      nper: nper,
      pmt: 0,
      pv: pv,
    );

    return futureValue;
  }

  String printTargetFreedomNumberAtRetirement() {
    return _formatLargeNumber(_getTargetFreedomNumberAtRetirement().abs());
  }

  num _getTargetMonthlyFreedomSavings() {
    int currentAge = int.tryParse(_currentAgeController.text) ?? 0;
    int retirementAge = int.tryParse(_retirementAgeController.text) ?? 0;
    double currentSavings =
        double.tryParse(_currentSavingsController.text) ?? 0;

    final nper = retirementAge - currentAge;
    final fv = -_getTargetFreedomNumberAtRetirement();
    final pv = -currentSavings;

    num annualSavingsGoal = Finance.pmt(
      rate: 0.08,
      nper: nper,
      pv: pv,
      fv: fv,
    );

    return annualSavingsGoal / 12;
  }

  String printTargetMonthlyFreedomSavings() {
    return _formatLargeNumber(_getTargetMonthlyFreedomSavings().abs());
  }

  num _getActualFreedomNumberAtRetirement() {
    int currentAge = int.tryParse(_currentAgeController.text) ?? 0;
    int retirementAge = int.tryParse(_retirementAgeController.text) ?? 0;
    const double inflationRate = 0.08;
    double nper = (retirementAge - currentAge).toDouble();
    double monthlySavings =
        double.tryParse(_monthlySavingsController.text) ?? 0;
    double currentSavings =
        double.tryParse(_currentSavingsController.text) ?? 0;

    final pv = -currentSavings;

    num trueFutureValue = Finance.fv(
      rate: inflationRate,
      nper: nper,
      pmt: monthlySavings,
      pv: pv,
    );

    return trueFutureValue;
  }

  String printActualFreedomNumber() {
    return _formatLargeNumber(_getActualFreedomNumberAtRetirement().abs());
  }

  num _getActualRetirementAge() {
    int currentAge = int.tryParse(_currentAgeController.text) ?? 0;
    const double inflationRate = 0.08;
    double currentSavings =
        double.tryParse(_currentSavingsController.text) ?? 0;

    final pv = -currentSavings;
    double monthlySavings =
        double.tryParse(_monthlySavingsController.text) ?? 0;
    final fv = _getTargetFreedomNumberAtRetirement();

    num nper = Finance.nper(
      pmt: monthlySavings,
      rate: inflationRate,
      pv: pv,
      fv: -fv,
    );

    final trueRetirementAge = nper + currentAge;

    return trueRetirementAge;
  }

  String printActualRetirementAge() {
    num age = _getActualRetirementAge();
    if (age.isFinite) {
      return '${age.ceil()} years old'; // or just '${age.ceil()}'
    }
    return 'N/A';
  }
}
