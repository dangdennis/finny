import 'dart:math';

class FinancialCalculator {
  static const double defaultInflationRate = 0.02;
  static const double sp500ReturnRate = 0.08;
  static const int monthsInYear = 12;

  static double getTargetFreedomNumberAtToday(double avgMonthlyExp) {
    const double annualYieldRate = 0.04;
    double annualExpense = avgMonthlyExp * monthsInYear;
    return annualExpense / annualYieldRate;
  }

  static double getTargetFreedomNumberAtRetirement({
    required double presentValue,
    required int currentAge,
    required int retirementAge,
    double inflationRate = defaultInflationRate,
  }) {
    int yearsToRetirement = retirementAge - currentAge;
    if (yearsToRetirement <= 0) {
      throw ArgumentError('Retirement age must be greater than current age');
    }
    return presentValue * pow((1 + inflationRate), yearsToRetirement);
  }

  static double getTargetMonthlyFreedomSavings({
    required double retirementFreedomTarget,
    required int years,
    required double currentBalance,
    double interestRate = sp500ReturnRate,
  }) {
    // PMT = (FV - PV * (1 + r)^n) * r / ((1 + r)^n - 1)
    double r = interestRate;
    double fv = -retirementFreedomTarget; // Negative as it's an outflow
    double pv = -currentBalance; // Negative as it's an initial investment
    int n = years;

    double yearlyPayment = (fv - pv * pow(1 + r, n)) * r / (pow(1 + r, n) - 1);
    return yearlyPayment / monthsInYear; // Convert to monthly payment
  }

  static double getActualFreedomNumberAtRetirement({
    required double presentValue,
    required int currentAge,
    required int retirementAge,
    required double monthlyPayment,
    double interestRate = sp500ReturnRate,
  }) {
    int years = retirementAge - currentAge;
    if (years <= 0) {
      throw ArgumentError('Retirement age must be greater than current age');
    }

    double yearlyPayment = monthlyPayment * monthsInYear;
    double pv = -presentValue; // Negative as it's an initial investment
    double r = interestRate;

    // FV = -PV * (1 + r)^n - PMT * ((1 + r)^n - 1) / r
    double fv =
        -pv * pow(1 + r, years) - yearlyPayment * (pow(1 + r, years) - 1) / r;

    return fv;
  }

  static int getActualRetirementAge({
    required int currentAge,
    required double currentBalance,
    required double monthlyPayment,
    required double targetAmount,
    double interestRate = sp500ReturnRate,
  }) {
    double yearlyPayment = monthlyPayment * monthsInYear;
    double pv = -currentBalance;
    double fv = targetAmount;
    double r = interestRate;

    // Solving for n using numerical approximation (Newton's method)
    // This is because solving for n directly is complex
    double n = _solveForYears(pv, yearlyPayment, fv, r);

    // Round up to the nearest year and add to current age
    return currentAge + n.ceil();
  }

  // Helper method to solve for years using Newton's method
  static double _solveForYears(double pv, double pmt, double fv, double r,
      {double tolerance = 0.0001, int maxIterations = 100}) {
    double n = 20.0; // Initial guess
    int iteration = 0;

    while (iteration < maxIterations) {
      double currentFv = -pv * pow(1 + r, n) - pmt * (pow(1 + r, n) - 1) / r;
      double diff = currentFv - fv;

      if (diff.abs() < tolerance) {
        break;
      }

      double derivative =
          -pv * pow(1 + r, n) * log(1 + r) - pmt * pow(1 + r, n - 1);
      n = n - diff / derivative;

      iteration++;
    }

    return n;
  }
}
