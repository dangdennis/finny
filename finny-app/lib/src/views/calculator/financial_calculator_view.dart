import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finny/src/finance/finance.dart';
import 'package:finny/src/providers/ynab_provider.dart';
import 'package:finny/src/views/calculator/ynab_auth_dialog.dart';
import 'package:provider/provider.dart';

class FinancialCalculatorView extends StatefulWidget {
  const FinancialCalculatorView({super.key});

  @override
  State<FinancialCalculatorView> createState() =>
      _FinancialCalculatorViewState();
}

class _FinancialCalculatorViewState extends State<FinancialCalculatorView> {
  final _formKey = GlobalKey<FormState>();
  bool _showResults = false;
  final _expenseInputMode = ExpenseInputMode.manual;

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

  bool _isLoading = false;

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    fetchAuthorizationStatus();
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
                      _freedomNumberAtRetirement = _formatLargeNumber(
                          _getTargetFreedomNumberAtRetirement().abs());
                      _monthlySavingsGoal = _formatLargeNumber(
                          _getTargetMonthlyFreedomSavings().abs());
                      _actualFreedomNumber = _formatLargeNumber(
                          _getActualFreedomNumberAtRetirement().abs());
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
          _buildYnabSection(),
          const SizedBox(height: 12),
          _buildNumberInput(
            label: 'Annual Expense (\$)',
            hintText: 'Enter your annual expenses',
            controller: _annualExpenseController,
            enabled: _expenseInputMode == ExpenseInputMode.manual,
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
            label: 'Estimated Monthly Savings (\$)',
            hintText: 'Enter your estimated monthly savings',
            controller: _monthlySavingsController,
          ),
        ],
      ),
    );
  }

  Widget _buildYnabSection() {
    final ynabProvider = context.watch<YNABProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ynabProvider.authStatus != YnabAuthStatus.authorized) ...[
          OutlinedButton.icon(
            onPressed: ynabProvider.authStatus == YnabAuthStatus.loading
                ? null
                : () => _handleYnabAuthorization(),
            icon: ynabProvider.authStatus == YnabAuthStatus.loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.link),
            label: Text(ynabProvider.authStatus == YnabAuthStatus.loading
                ? 'Connecting...'
                : 'Connect YNAB'),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await ynabProvider.fetchExpenseTotal();
                      if (ynabProvider.annualExpenses != null && mounted) {
                        setState(() {
                          _annualExpenseController.text =
                              ynabProvider.annualExpenses!.toStringAsFixed(0);
                        });
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to fetch YNAB expenses'),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.sync),
            label: Text(_isLoading ? 'Fetching...' : 'Use YNAB Expense'),
          ),
        ],
      ],
    );
  }

  Future<void> _handleYnabAuthorization() async {
    if (_isLoading) return;

    final ynabService = context.read<YNABProvider>();

    final authorizedByUser = await showDialog<bool>(
        context: context,
        builder: (context) => YnabAuthDialog(
              ynabService: ynabService,
            ));

    if (authorizedByUser == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        await ynabService.authorize();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Retry YNAB connection'),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildNumberInput({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool enabled = true,
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
      enabled: enabled,
    );
  }

  Widget _buildResults() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Results',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildResultRow(
              'Freedom Number Today:',
              _freedomNumberToday,
              tooltip:
                  'This is the amount of money you need to have invested today to be financially independent based on your current annual expenses.',
            ),
            _buildResultRow(
                'Freedom Number at Retirement:', _freedomNumberAtRetirement,
                tooltip:
                    'This is your required savings at retirement, adjusted for 2% inflation.'),
            _buildResultRow('Monthly Savings Goal:', _monthlySavingsGoal,
                tooltip:
                    'This is how much you need to save monthly to reach your freedom number by your target retirement age.'),
            _buildResultRow('Actual Retirement Savings:', _actualFreedomNumber,
                tooltip:
                    'This is how much you will actually have saved at retirement with your current savings rate.'),
            _buildResultRow('Actual Retirement Age:', _actualRetirementAge,
                tooltip:
                    'This is the age you will reach financial independence with your current savings rate.'),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {String? tooltip}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                if (tooltip != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      offset: const Offset(-100, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[800],
                      icon: const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          enabled: false,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              tooltip,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
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

  String printTargetFreedomNumberToday() {
    return _formatLargeNumber(_getTargetFreedomNumberAtToday().abs());
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
      return '${age.ceil()} years old';
    }
    return 'N/A';
  }

  Future<void> fetchAuthorizationStatus() async {
    final ynabProvider = context.read<YNABProvider>();
    await ynabProvider.fetchAuthorizationStatus();
  }
}

enum ExpenseInputMode {
  manual,
  ynab,
}
