// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Plus Operator', () {
    test('should add two numbers together', () {
      expect(1 + 1, 2);
    });
  });

  // write a test that runs some financial calculator
  //
  group('Financial Calculator', () {
    test('should calculate interest', () {
      expect(1 + 1, 2);
    });
  });
}
