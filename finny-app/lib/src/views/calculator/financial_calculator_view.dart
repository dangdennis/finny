import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finny/src/finance/finance.dart';
import 'package:finny/src/providers/ynab_provider.dart';
import 'package:finny/src/views/calculator/ynab_auth_dialog.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

class FinancialCalculatorView extends StatefulWidget {
  const FinancialCalculatorView({super.key});

  @override
  State<FinancialCalculatorView> createState() =>
      _FinancialCalculatorViewState();
}

class _FinancialCalculatorViewState extends State<FinancialCalculatorView>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  bool _showResults = false;
  final _expenseInputMode = ExpenseInputMode.manual;
  late AnimationController _celebrationAnimationController;

  final TextEditingController _annualExpenseController =
      TextEditingController();
  final TextEditingController _currentAgeController = TextEditingController();
  final TextEditingController _retirementAgeController =
      TextEditingController(text: '65');
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

  final themeColors = {
    'primary': const Color(0xFF6C63FF),
    'secondary': const Color(0xFF00BFA6),
    'accent': const Color(0xFFFF6584),
    'background': const Color(0xFFF0F3FF),
  };

  @override
  void initState() {
    super.initState();
    _celebrationAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    fetchAuthorizationStatus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _celebrationAnimationController.dispose();
    _annualExpenseController.dispose();
    _currentAgeController.dispose();
    _retirementAgeController.dispose();
    _currentSavingsController.dispose();
    _monthlySavingsController.dispose();
    super.dispose();
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: themeColors['background'],
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '✨ Financial Freedom Calculator ✨',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeColors['primary'],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildInputForm(),
                const SizedBox(height: 20),
                _buildCalculateButton(),
                const SizedBox(height: 20),
                if (_showResults) _buildResults(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Form(
      key: _formKey,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildYnabSection(),
              const SizedBox(height: 16),
              _buildNumberInput(
                label: 'Annual Expense 💰',
                hintText: 'Enter your annual expenses',
                controller: _annualExpenseController,
                icon: Icons.attach_money,
                enabled: _expenseInputMode == ExpenseInputMode.manual,
              ),
              const SizedBox(height: 12),
              _buildNumberInput(
                label: 'Current Age 🎂',
                hintText: 'Enter your current age',
                controller: _currentAgeController,
                icon: Icons.cake,
              ),
              const SizedBox(height: 12),
              _buildNumberInput(
                label: 'Retirement Age 🎯',
                hintText: 'Enter your desired retirement age',
                controller: _retirementAgeController,
                icon: Icons.flag,
              ),
              const SizedBox(height: 12),
              _buildNumberInput(
                label: 'Current Savings 💲',
                hintText: 'Enter your current savings',
                controller: _currentSavingsController,
                icon: Icons.savings,
              ),
              const SizedBox(height: 12),
              _buildNumberInput(
                label: 'Monthly Savings 📈',
                hintText: 'Enter your monthly savings',
                controller: _monthlySavingsController,
                icon: Icons.trending_up,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: themeColors['primary']),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: themeColors['primary']!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: themeColors['secondary']!, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isDense: true,
      ),
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

  Widget _buildCalculateButton() {
    return ElevatedButton(
      onPressed: () async {
        _unfocus();
        if (_formKey.currentState!.validate()) {
          setState(() {
            _freedomNumberToday =
                _formatLargeNumber(_getTargetFreedomNumberAtToday().abs());
            _freedomNumberAtRetirement =
                _formatLargeNumber(_getTargetFreedomNumberAtRetirement().abs());
            _monthlySavingsGoal =
                _formatLargeNumber(_getTargetMonthlyFreedomSavings().abs());
            _actualFreedomNumber =
                _formatLargeNumber(_getActualFreedomNumberAtRetirement().abs());
            _actualRetirementAge = printActualRetirementAge();
            _showResults = true;
          });

          if (mounted) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: themeColors['primary'],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calculate_rounded, size: 24, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Calculate My Future!',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/partybirdlottie.json',
              height: 100,
              repeat: true,
              controller: _celebrationAnimationController,
              onLoaded: (composition) {
                _celebrationAnimationController
                  ..duration = composition.duration
                  ..repeat();
              },
            ),
            const SizedBox(height: 16),
            _buildAnimatedResultRow(
              'FIRE Today',
              _freedomNumberToday,
              'Amount needed today for financial independence. You can withdraw 4% annually to cover your current annual expenses (\$${double.parse(_annualExpenseController.text).toStringAsFixed(2)}).',
            ),
            _buildAnimatedResultRow(
              'FIRE at Retirement',
              _freedomNumberAtRetirement,
              'Amount needed at retirement for financial independence. This is the same as FIRE Today, but adjusted for an annual inflation rate of 2%.',
            ),
            _buildAnimatedResultRow(
              'Monthly Savings Goal',
              _monthlySavingsGoal,
              'Required monthly savings to reach your goal by desired retirement. This is based on an 8% annual return on investment. Try changing your retirement age to see how it affects your monthly savings goal.',
            ),
            _buildAnimatedResultRow(
              'Retirement Savings',
              _actualFreedomNumber,
              'Projected savings at retirement. This is based on your current savings, monthly savings, and an 8% annual return on investment.',
            ),
            _buildAnimatedResultRow(
              'Retirement Age',
              _actualRetirementAge,
              'When you\'ll reach financial independence. This is based on your current savings, monthly savings, and an 8% annual return on investment. If you are saving more or less than your monthly savings goal, this age will change.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedResultRow(String label, String value, String tooltip) {
    final uniqueKey =
        Key('$label-$value-${DateTime.now().millisecondsSinceEpoch}');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.help,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(label),
                            content: Text(tooltip),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Got it'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.info_outline,
                        size: 20,
                        color: themeColors['primary'],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 4,
              child: AnimatedTextKit(
                key: uniqueKey,
                animatedTexts: [
                  TyperAnimatedText(
                    value,
                    speed: const Duration(milliseconds: 20),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeColors['primary'],
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
                displayFullTextOnTap: true,
              )),
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.link),
            label: Text(ynabProvider.authStatus == YnabAuthStatus.loading
                ? 'Connecting...'
                : 'Connect YNAB'),
            style: OutlinedButton.styleFrom(
              foregroundColor: themeColors['primary'],
              side: BorderSide(color: themeColors['primary']!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            label: Text(_isLoading ? 'Fetching...' : 'Use YNAB Expense'),
            style: OutlinedButton.styleFrom(
              foregroundColor: themeColors['primary'],
              side: BorderSide(color: themeColors['secondary']!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
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
    const double rate = 0.08;
    double nper = (retirementAge - currentAge).toDouble();
    double pmt = -(double.tryParse(_monthlySavingsController.text) ?? 0) * 12;
    double currentSavings =
        double.tryParse(_currentSavingsController.text) ?? 0;
    final pv = -currentSavings;

    num trueFutureValue = Finance.fv(
      rate: rate,
      nper: nper,
      pmt: pmt,
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
      pmt: monthlySavings.abs() * 12 * -1,
      rate: inflationRate,
      pv: pv.abs() * -1,
      fv: fv.abs(),
    );

    final trueRetirementAge = nper + currentAge;

    return trueRetirementAge;
  }

  String printActualRetirementAge() {
    num age = _getActualRetirementAge();
    return '${age.round()} years old';
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
