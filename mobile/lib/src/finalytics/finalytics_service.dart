import 'dart:math';

import 'package:finny/src/accounts/accounts_service.dart';
import 'package:finny/src/goals/goal_model.dart';
import 'package:finny/src/goals/goals_service.dart';
import 'package:finny/src/powersync/database.dart';
import 'package:finny/src/profile/profile_service.dart';

class FinalyticsService {
  final AppDatabase appDb;
  late final GoalsService goalsService;
  late final ProfileService profileService;

  FinalyticsService({required this.appDb}) {
    goalsService = GoalsService(
        appDb: appDb, accountsService: AccountsService(appDb: appDb));
    profileService = ProfileService(appDb: appDb);
  }

  Future<int> getActualRetirementAge() async {
    final fv = await getFreedomFutureValueOfCurrentExpenses();
    final pv = await getAssignedBalanceOnRetirementGoal();
    final pmt = await getActualSavingsThisMonthForRetirementGoal() * 12;
    const interest = 0.08;
    final currentAge = (await profileService.getProfile()).age!;

    final n = calculatePeriodFromFutureValue(
      fv: fv,
      pv: pv,
      payment: pmt,
      annualInterestRate: interest,
    );

    return n + currentAge;
  }

  // Calculate the total amount of money (future value) I need today to sustain my expenses in perpetuity at 4% interest
  Future<double> getFreedomFutureValueOfCurrentExpenses() async {
    final averageMonthlyInflowOutflow = await getAverageMonthlyInflowOutflow();
    return averageMonthlyInflowOutflow.outflows * 12 / 0.04;
  }

  Future<double> getFreedomFutureValueOfCurrentExpensesAtRetirement() async {
    final freedomFVCurrentAge = await getFreedomFutureValueOfCurrentExpenses();
    final yearsToRetirement = await calculateYearsToRetirement();

    return calculateFutureValue(
        presentValue: freedomFVCurrentAge.abs(),
        yearlyInvestment: 0,
        annualInterestRate: 0.02, // 2% inflation rate
        years: yearsToRetirement);
  }

  Future<double> getTargetSavingsAndInvestmentsThisMonth() async {
    final pv = -((await getAssignedBalanceOnRetirementGoal()).abs());
    final period = await calculateYearsToRetirement();
    const interest = 8.0;
    final fv = await getFreedomFutureValueOfCurrentExpensesAtRetirement();
    final yearlySavingsTarget = calculatePaymentFromFutureValue(
      fv: fv,
      pv: pv,
      interest: interest,
      years: period,
    );

    return yearlySavingsTarget / 12;
  }

  Future<double> getActualSavingsAndInvestmentsThisMonth() async {
    final savings = await getActualSavingsThisMonthForRetirementGoal();
    final investment = await getActualInvestmentThisMonthForRetirementGoal();
    return savings + investment;
  }

  Future<double> getActualSavingsAtRetirement() async {
    const interestRate = 0.08;
    final period = await calculateYearsToRetirement();
    final pv = -((await getAssignedBalanceOnRetirementGoal()).abs());
    final pmt =
        -((await getActualSavingsThisMonthForRetirementGoal()).abs() * 12);

    return calculateFutureValue(
        presentValue: pv,
        yearlyInvestment: pmt,
        annualInterestRate: interestRate,
        years: period);
  }

  Future<double> getActualSavingsThisMonthForRetirementGoal() async {
    final result = await appDb.customSelect('''
      WITH retirement_goal AS (
        SELECT
          id
        FROM
          goals
        WHERE
          goals.goal_type = 'retirement'
        LIMIT 1
      ),
      assigned_accounts AS (
        SELECT
          account_id
        FROM
          goal_accounts
          JOIN retirement_goal ON retirement_goal.id = goal_accounts.goal_id
        WHERE
          goal_accounts.goal_id = retirement_goal.id
      ),
      start_of_month_balances AS (
        -- Get the earliest balance in the current month for each account
        SELECT
          ab.account_id,
          ab.balance_date AS start_balance_date,
          ab.current_balance AS start_balance
        FROM
          account_balances ab
        WHERE
          ab.balance_date = (
            SELECT
              min(balance_date)
            FROM
              account_balances
            WHERE
              account_id = ab.account_id
              AND balance_date >= date('now', 'start of month') -- Start of the current month in SQLite
          ) 
          AND ab.account_id IN (SELECT account_id FROM assigned_accounts)
      ),
      most_recent_balances AS (
        -- Get the most recent balance for each account
        SELECT
          ab.account_id,
          ab.balance_date AS most_recent_balance_date,
          ab.current_balance AS most_recent_balance
        FROM
          account_balances ab
        WHERE
          ab.balance_date = (
            SELECT
              max(balance_date)
            FROM
              account_balances
            WHERE
              account_id = ab.account_id
          )
          AND ab.account_id IN (SELECT account_id FROM assigned_accounts)
      )
      SELECT
        mr.account_id,
        (mr.most_recent_balance - som.start_balance) AS net_balance_change
      FROM
        most_recent_balances mr
        JOIN start_of_month_balances som ON mr.account_id = som.account_id
        JOIN accounts ON mr.account_id = accounts.id
      WHERE
        mr.most_recent_balance_date >= som.start_balance_date;
        ''').get();

    return result.fold<double>(
      0.0,
      (sum, row) => sum + row.read<double>('net_balance_change'),
    );
  }

  Future<double> getActualInvestmentThisMonthForRetirementGoal() async {
    final result = await appDb.customSelect('''
        WITH start_of_month AS (
            -- Get the earliest holding in the current month for each account and security
            SELECT
                ihd.account_id,
                ihd.investment_security_id,
                ihd.holding_date AS earliest_holding_date,
                ihd.quantity AS start_quantity,
                ihd.institution_price AS start_price
            FROM investment_holdings_daily ihd
            WHERE ihd.holding_date = (
                SELECT MIN(holding_date)
                FROM investment_holdings_daily
                WHERE account_id = ihd.account_id
                  AND investment_security_id = ihd.investment_security_id
                  AND holding_date >= DATE('now', 'start of month')  -- Start of the current month
            )
        ),
        most_recent_holdings AS (
            -- Get the most recent holdings for each account and security
            SELECT
                ihd.account_id,
                ihd.investment_security_id,
                ihd.holding_date AS most_recent_holding_date,
                ihd.quantity AS current_quantity,
                ihd.institution_price AS current_price
            FROM investment_holdings_daily ihd
            WHERE ihd.holding_date = (
                SELECT MAX(holding_date)
                FROM investment_holdings_daily
                WHERE account_id = ihd.account_id
                  AND investment_security_id = ihd.investment_security_id
            )
        )
        SELECT
            mrh.account_id,
            mrh.investment_security_id,
            (mrh.current_quantity - som.start_quantity) * mrh.current_price AS personal_investment
        FROM
            most_recent_holdings mrh
        JOIN
            start_of_month som
            ON mrh.account_id = som.account_id
            AND mrh.investment_security_id = som.investment_security_id
        WHERE
            mrh.current_quantity > som.start_quantity  -- Only consider increases in quantity (personal investment)
            AND mrh.most_recent_holding_date >= som.earliest_holding_date;  -- Compare from the earliest date in the current month
    ''').get();

    final totalPersonalInvestment = result.fold<double>(
      0.0,
      (sum, row) => sum + row.read<double>('personal_investment'),
    );

    return totalPersonalInvestment;
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

  Future<int> calculateYearsToRetirement() async {
    final profile = await profileService.getProfile();

    if (profile.age == null) {
      throw Exception('Age is not set');
    }

    if (profile.retirementAge == null) {
      throw Exception('Retirement age is not set');
    }

    return profile.retirementAge! - profile.age!;
  }

  Future<double> getAssignedBalanceOnRetirementGoal() async {
    final retirementGoal = (await goalsService.getGoals()).firstWhere(
      (goal) => goal.goalType == GoalType.retirement,
      orElse: () => throw Exception('No retirement goal found'),
    );

    return (await goalsService.getTotalBalanceAssignedGoals(retirementGoal.id))
        .abs();
  }

  /// Calculate future value with both present value and monthly contributions
  double calculateFutureValue({
    required double presentValue,
    required double yearlyInvestment,
    required double annualInterestRate,
    required int years,
  }) {
    double futureValue = presentValue * pow(1 + annualInterestRate, years) +
        yearlyInvestment *
            ((pow(1 + annualInterestRate, years) - 1) / annualInterestRate);

    if (yearlyInvestment < 0 && presentValue < 0) {
      futureValue = -futureValue;
    }

    return futureValue;
  }

  double calculatePaymentFromFutureValue({
    required double fv,
    required double pv,
    required double interest,
    required int years,
  }) {
    // Convert interest rate to decimal
    double rate = interest / 100;

    // Calculate the payment using the future value formula for annual payments
    double payment;
    if (rate == 0) {
      // If interest rate is 0, use simple division
      payment = (fv - pv) / years;
    } else {
      payment = (fv - pv * pow(1 + rate, years)) /
          ((pow(1 + rate, years) - 1) / rate);
    }

    // Adjust the sign if both FV and PV are negative
    if (fv < 0 && pv < 0) {
      payment = -payment;
    }

    // Round to 2 decimal places
    return double.parse(payment.toStringAsFixed(2));
  }

  int calculatePeriodFromFutureValue({
    required double fv,
    required double pv,
    required double payment,
    required double annualInterestRate,
  }) {
    if (annualInterestRate == 0) {
      // If interest rate is 0, use simple division
      return ((fv - pv) / payment).round();
    }

    fv = fv.abs();
    pv = pv.abs();
    payment = payment.abs();

    double n = log((fv * annualInterestRate + payment) /
            (pv * annualInterestRate + payment)) /
        log(1 + annualInterestRate);

    return n.round();
  }
}

class AverageMonthlyInflowOutflow {
  final double inflows;
  final double outflows;

  AverageMonthlyInflowOutflow({required this.inflows, required this.outflows});
}
