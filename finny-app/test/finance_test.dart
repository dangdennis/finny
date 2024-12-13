import 'package:finny/src/finance/finance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Finance", () {
    group("should calculate fv", () {
      final structuredTestCases = [
        FvTestCase(
          name: '8% interest rate',
          nper: 1,
          pmt: -1,
          pv: -1,
          rate: 0.08,
          expected: 2.080000000000001,
        ),
        FvTestCase(
          name: 'multiple periods with high interest',
          nper: 3,
          pmt: -100,
          pv: -1000,
          rate: 0.15,
          expected: 1868.1249999999993,
        ),
      ];

      for (final testCase in structuredTestCases) {
        test('should calculate fv with ${testCase.name}', () {
          final fv = Finance.fv(
            nper: testCase.nper,
            pmt: testCase.pmt,
            pv: testCase.pv,
            rate: testCase.rate,
          );
          expect(fv, closeTo(testCase.expected, 0.001));
        });
      }
    });

    group("should calculate pmt", () {
      final structuredTestCases = [
        PmtTestCase(
          name: 'simple loan payment',
          rate: 0.1, // 10% annual rate
          nper: 12, // 12 months
          pv: 1000, // 1000 present value
          fv: 0, // 0 future value
          expected: -146.76, //payment
        ),
        PmtTestCase(
          name: 'zero interest rate',
          rate: 0,
          nper: 12,
          pv: 1200,
          fv: 0,
          expected: -100,
        ),
        PmtTestCase(
          name: 'with future value',
          rate: 0.08,
          nper: 24,
          pv: 5000,
          fv: 1000,
          expected: -489.87,
        ),

        // end = false. Payments are paid in the beginning of the month and therefore do not accrue additional interest.
        PmtTestCase(
          name: 'beginning of period payments',
          rate: 0.12,
          nper: 12,
          pv: 1000,
          fv: 0,
          end: false,
          expected: -144.14,
        ),
        PmtTestCase(
          name: 'end of period payments',
          rate: 0.12,
          nper: 12,
          pv: 1000,
          fv: 0,
          end: true,
          expected: -161.44,
        ),

        PmtTestCase(
          name: 'negative principal with short term',
          rate: 0.06,
          nper: 6,
          pv: -5000,
          fv: 0,
          expected: 1016.81,
        ),
        PmtTestCase(
          name: 'very long term loan',
          rate: 0.035,
          nper: 360,
          pv: 300000,
          fv: 0,
          expected: -10500.04,
        ),
        PmtTestCase(
          name: 'saving for future with negative fv',
          rate: 0.09,
          nper: 16,
          pv: 0,
          fv: -50000,
          expected: 1515,
        ),
      ];

      for (final testCase in structuredTestCases) {
        test('should calculate pmt with ${testCase.name}', () {
          final pmt = Finance.pmt(
            rate: testCase.rate,
            nper: testCase.nper,
            pv: testCase.pv,
            fv: testCase.fv,
            end: testCase.end,
          );
          expect(pmt, closeTo(testCase.expected, 0.01));
        });
      }
    });

    group("should calculate nper", () {
      final structuredTestCases = [
        NperTestCase(
          name: 'standard loan term',
          rate: 0.07, // 7% annually
          pmt: 150, //pmt needs to be positive
          pv: 8000, //present value
          expected: -22.97,
        ),
        NperTestCase(
          name: 'high interest loan',
          rate: .12,
          pmt: 300,
          pv: 10000,
          expected: -14.20,
        ),
        NperTestCase(
          name: "low interest loan",
          rate: .045,
          pmt: 500,
          pv: 20000,
          expected: -23.39,
        ),
        NperTestCase(
          name: 'beginning of period',
          rate: .10,
          pmt: 250,
          pv: 5000,
          end: false,
          expected: -10.87,
        ),
      ];

      for (final testCase in structuredTestCases) {
        test('should calculate nper with ${testCase.name}', () {
          final periods = Finance.nper(
            rate: testCase.rate,
            pmt: testCase.pmt,
            pv: testCase.pv,
            fv: testCase.fv,
            end: testCase.end,
          );
          expect(periods, closeTo(testCase.expected, 0.01));
        });
      }
    });

    group("should calculate pv", () {
      final structureTestCases = [
        PvTestCase(
            name: 'standard loan calculation',
            rate: .10, // 10% annual rate
            nper: 12, // 12 payments
            pmt: 100, // 100 amount
            fv: 0,
            expected: -681.37),
      ];

      for (final testCase in structureTestCases) {
        test('should calculate pv with ${testCase.name}', () {
          final pv = Finance.pv(
            rate: testCase.rate,
            nper: testCase.nper,
            pmt: testCase.pmt,
            fv: testCase.fv,
            end: testCase.end,
          );
          expect(pv, closeTo(testCase.expected, 0.01));
        });
      }
    });

    // test rate
  });
}

class FvTestCase {
  final String name;
  final int nper;
  final double pmt;
  final double pv;
  final double rate;
  final double expected;

  FvTestCase({
    required this.name,
    required this.nper,
    required this.pmt,
    required this.pv,
    required this.rate,
    required this.expected,
  });
}

class PmtTestCase {
  final String name;
  final double rate;
  final int nper;
  final double pv;
  final double fv;
  final bool end;
  final double expected;

  PmtTestCase({
    required this.name,
    required this.rate,
    required this.nper,
    required this.pv,
    required this.fv,
    this.end = true,
    required this.expected,
  });
}

class NperTestCase {
  final String name;
  final double rate;
  final double pmt;
  final double pv;
  final double fv;
  final bool end;
  final double expected;

  NperTestCase({
    required this.name,
    required this.rate,
    required this.pmt,
    required this.pv,
    this.fv = 0,
    this.end = true,
    required this.expected,
  });
}

class PvTestCase {
  final String name;
  final double rate;
  final int nper;
  final double pmt;
  final double fv;
  final bool end;
  final double expected;

  PvTestCase({
    required this.name,
    required this.rate,
    required this.nper,
    required this.pmt,
    required this.fv,
    this.end = true,
    required this.expected,
  });
}
