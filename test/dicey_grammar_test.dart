import 'package:petitparser/debug.dart';
import 'package:petitparser/reflection.dart';
import 'package:rolling_dicey/src/dicey/grammar.dart';
import 'package:test/test.dart';

final grammar = DiceyGrammar();
final parser = grammar.build();

void verify(String input, dynamic expected) {
  print('verify(input="$input", expected=$expected)');
  final result = trace(parser).parse(input);
  // print('  result.value=${result.value}');
  expect(result.value, expected);
}

void main() {
  test('detect common parser issues', () {
    expect(linter(parser), isEmpty);
  });

  group('implicit roll tests', () {
    test('20', () {
      verify('20', [null, '20', []]);
    });

    test('d20', () {
      verify('d20', [
        null,
        [null, 'd', '20'],
        []
      ]);
    });

    test(
        '3d6',
        () => verify('3d6', [
              null,
              ['3', 'd', '6'],
              []
            ]));

    test(
        '3d6+2',
        () => verify('3d6+2', [
              null,
              ['3', 'd', '6'],
              ['+', '2']
            ]));
  });

  group('explicit roll tests', () {
    test('roll 20', () {
      verify('roll 20', [
        [
          ['roll', '20'],
          []
        ]
      ]);
    });

    test('roll d20', () {
      verify('roll d20', [
        [
          [
            'roll',
            [null, 'd', '20']
          ],
          []
        ]
      ]);
    });

    test('roll 3d6', () {
      verify('roll 3d6', [
        [
          [
            'roll',
            ['3', 'd', '6']
          ],
          []
        ]
      ]);
    });

    test('roll 3d6+2', () {
      verify('roll 3d6+2', [
        [
          [
            'roll',
            ['3', 'd', '6']
          ],
          []
        ],
        [
          [null, '+2'],
          []
        ]
      ]);
    });
  });

  group('rolling with actions tests', () {
    test('roll 2d20 keeping lowest', () {
      verify('roll 2d20 keeping lowest', [
        [
          [
            'roll',
            ['2', 'd', '20']
          ],
          [
            [
              'keeping',
              ['lowest', null]
            ]
          ]
        ]
      ]);
    });
  });
}
