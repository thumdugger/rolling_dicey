import 'package:rolling_dicey/src/core.dart';
import 'package:test/test.dart';

void main() {
  var range = Range(10);
  group('Testing default constructed object', () {
    test('Range(10) is Range', () {
      expect(range, isA<Range>());
    });

    test('range.steps == 10', () {
      expect(range.steps, equals(10));
    });

    test('range.stepSize == 1', () {
      expect(range.stepSize, equals(1));
    });

    test('  range.min == 0', () {
      expect(range.min, equals(0));
    });

    test('  range.max == 9', () {
      expect(range.max, equals(9));
    });

    test('  range.first == 0', () {
      expect(range.first, equals(0));
    });

    test('  range.last == 9', () {
      expect(range.last, equals(9));
    });
  });

  group('Testing contained values', () {
    test('  range.contains(0) == true', () {
      expect(range.contains(0), true);
    });
    test('  range.contains(5) == true', () {
      expect(range.contains(5), true);
    });
    test('  range.contains(9) == true', () {
      expect(range.contains(9), true);
    });
  });

  group('Testing for values NOT contained', () {
    test('  range.contains(null) == false', () {
      expect(range.contains(-1), false);
    });
    test('  range.contains(-1) == false', () {
      expect(range.contains(null), false);
    });
    test('  range.contains("ABC") == false', () {
      expect(range.contains("ABC"), false);
    });
    test('  range.contains(5.5) == false', () {
      expect(range.contains(5.5), false);
    });
    test('  range.contains(10) == false', () {
      expect(range.contains(-1), false);
    });
  });
}
