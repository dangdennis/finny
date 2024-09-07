import 'dart:math';

import 'package:finny/src/goals/goals_service.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:finny/src/profile/profile_service.dart';

class FinalyticsService {
  final AppDatabase appDb;
  late final GoalsService goalsService;
  late final ProfileService profileService;

  FinalyticsService({required this.appDb}) {
    goalsService = GoalsService(appDb: appDb);
    profileService = ProfileService(appDb: appDb);
  }

  Future<double> getCurrentTotalInvestmentBalance() async {
    final result = await appDb.customSelect('''
      SELECT
        sum(current_balance) as current_investment_balance
      FROM
        accounts
      WHERE
        type = 'investment';
    ''').getSingle();

    return result.read<double>('current_investment_balance');
  }

  // Calculate the monthly investment goal based on the present value, future value, annual interest rate, and years
  MonthlyInvestmentOutput calculateMonthlyInvestment(
      MonthyInvestmentInput params) {
    double monthlyInterestRate = params.annualInterestRate / 12;
    int months = params.yearsPeriod * 12;

    // Formula to calculate the monthly investment including present value
    double monthlyInvestment = (params.futureValue -
            (params.presentValue * pow(1 + monthlyInterestRate, months))) *
        monthlyInterestRate /
        (pow(1 + monthlyInterestRate, months) - 1);

    return MonthlyInvestmentOutput(amount: monthlyInvestment);
  }

  Future<MonthlyInvestmentOutput> getActualMonthlyInvestment() async {
    // final input = MonthyInvestmentInput(
    //   presentValue: await getCurrentTotalInvestmentBalance(),
    //   futureValue: 0,
    //   annualInterestRate: 0,
    //   yearsPeriod: 0,
    // );
    // TODO: Get actual monthly investment from the database
    // return calculateMonthlyInvestment(monthlyinvestmentInput);
    // gets the sum of all transactions that are not transfers from investment accounts past month
    return MonthlyInvestmentOutput(amount: 0);
  }

  Future<MonthlyInvestmentOutput> getTargetMonthlyInvestment() async {
    final profile = await profileService.getProfile();
    final goals = await goalsService.getGoals();
    final totalTargetAmount =
        goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
    final currentAge = profile.age!;
    final retirementAge = profile.retirementAge ?? 67;
    final yearsPeriod = retirementAge - currentAge;
    final presentValue = await getCurrentTotalInvestmentBalance();

    final input = MonthyInvestmentInput(
      presentValue: presentValue,
      futureValue: totalTargetAmount,
      annualInterestRate: 0.08,
      yearsPeriod: yearsPeriod,
    );

    return MonthlyInvestmentOutput(
        amount: max(calculateMonthlyInvestment(input).amount, 0));
  }

  /// Calculate future value with both present value and monthly contributions
  FutureValueOutput calculateFutureValue(FutureValueInput params) {
    double monthlyInterestRate = params.annualInterestRate / 12;

    double futureValue =
        params.presentValue * pow(1 + monthlyInterestRate, params.months) +
            params.monthlyInvestment *
                (pow(1 + monthlyInterestRate, params.months) - 1) /
                monthlyInterestRate;

    return FutureValueOutput(futureValue: futureValue);
  }

  /// Get the current retirement interest return for all investment accounts.
  /// This is the sum of the current balance of all investment accounts multiplied by the 4% interest rate.
  Future<CurrentInvestmentInterestReturn>
      getCurrentInvestmentInterestReturn() async {
    final result = await appDb.customSelect('''
      SELECT
        sum(current_balance) * 0.08 AS current_retirement_interest_return
      FROM
        accounts
      WHERE
        type = 'investment';
    ''').getSingle();

    return CurrentInvestmentInterestReturn(
        amount: result.read<double>('current_retirement_interest_return'));
  }

  Future<AnnualInflowOutflow> getAnnualInflowOutflow() async {
    final result = await appDb.customSelect('''
      SELECT
        SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS annual_inflows,
        SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS annual_outflows
      FROM
        transactions
        JOIN accounts ON transactions.account_id = accounts.id
      WHERE
        date >= date('now', '-12 months');
    ''').getSingle();

    return AnnualInflowOutflow(
      inflows: result.read<double>('annual_inflows'),
      outflows: result.read<double>('annual_outflows'),
    );
  }

  /// Get the average monthly inflow and outflow for the last 12 months
  Future<AverageMonthlyInflowOutflow> getAverageMonthlyInflowOutflow() async {
    final result = await appDb.customSelect('''
      WITH monthly_totals AS (
        SELECT
          strftime('%Y-%m', date) AS month,
          SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) AS monthly_inflows,
          SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS monthly_outflows
        FROM
          transactions
          JOIN accounts ON transactions.account_id = accounts.id
        WHERE
          date >= date('now', '-12 months')
        GROUP BY
          month
      )
      SELECT
        AVG(monthly_inflows) AS average_inflows,
        AVG(monthly_outflows) AS average_outflows
      FROM
        monthly_totals;
    ''').getSingle();

    return AverageMonthlyInflowOutflow(
        inflows: result.read<double>('average_inflows'),
        outflows: result.read<double>('average_outflows'));
  }

  Future<List<MonthlyInflowOutflow>> getMonthlyInflowOutflow(
      String userId) async {
    final result = await appDb.customSelect('''
      SELECT
        date_trunc('month', date) AS month,
        avg(
          CASE WHEN amount < 0 THEN
            amount
          ELSE
            0
          END) AS average_inflows,
        avg(
          CASE WHEN amount > 0 THEN
            amount
          ELSE
            0
          END) AS average_outflows
      FROM
        transactions
        JOIN accounts ON transactions.account_id = accounts.id
      GROUP BY
        month
      ORDER BY
        month;
      ''').get();

    return result.map((row) {
      return MonthlyInflowOutflow(
        month: row.read<DateTime>('month'),
        averageInflows: row.read<double>('average_inflows'),
        averageOutflows: row.read<double>('average_outflows'),
      );
    }).toList();
  }
}

class MonthyInvestmentInput {
  final double presentValue;
  final double futureValue;
  final double annualInterestRate;
  final int yearsPeriod;

  MonthyInvestmentInput({
    required this.presentValue,
    required this.futureValue,
    required this.annualInterestRate,
    required this.yearsPeriod,
  });
}

class MonthlyInvestmentOutput {
  final double amount;

  MonthlyInvestmentOutput({required this.amount});
}

class CurrentInvestmentInterestReturn {
  final double amount;

  CurrentInvestmentInterestReturn({required this.amount});
}

class AnnualInflowOutflow {
  final double inflows;
  final double outflows;

  AnnualInflowOutflow({required this.inflows, required this.outflows});
}

class AverageMonthlyInflowOutflow {
  final double inflows;
  final double outflows;

  AverageMonthlyInflowOutflow({required this.inflows, required this.outflows});
}

class MonthlyInflowOutflow {
  final DateTime month;
  final double averageInflows;
  final double averageOutflows;

  MonthlyInflowOutflow({
    required this.month,
    required this.averageInflows,
    required this.averageOutflows,
  });
}

class FutureValueInput {
  final double presentValue;
  final double monthlyInvestment;
  final double annualInterestRate;
  final int months;

  FutureValueInput({
    required this.presentValue,
    required this.monthlyInvestment,
    required this.annualInterestRate,
    required this.months,
  });
}

class FutureValueOutput {
  final double futureValue;

  FutureValueOutput({required this.futureValue});
}
