import 'package:finny/src/finance/finance.dart';
import 'package:flutter_test/flutter_test.dart';

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

    // test pmt
    // test nper
    // test pv
    // test rate
  });
}
