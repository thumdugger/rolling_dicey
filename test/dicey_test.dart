import 'package:rolling_dicey/src/dicey/parser.dart';
import 'package:test/test.dart';

final grammar = DiceyGrammar();
final parser = grammar.build();

void verify(String input, dynamic expected) {
  final ast = parser.parse(input);
  expect(ast.value, expected);
}

void main() {
  test('constants', () {
    verify('0', '0');
    verify('42', '42');
    verify('+1', '+1');
    verify('-1', '-1');
    verify('+0', '0');
  });

  test('whitespaced constants', () {
    verify('  42', [42]);
    verify('42  ', '42');
    verify('  42  ', '42');
  });

  test('single die rolls', () {
    verify('1d4', ['1', 'd', '4']);
    verify('d6', ['', 'd', '6']);
    verify('  1d12  ', ['', 'd', '12']);
    verify('  d20  ', ['1', 'd', '20']);
  });

  test('modified dice rolls', () {
    verify('3d6 +3', [
      ['3', 'd', '6'],
      ['+', '3']
    ]);
  });
}
