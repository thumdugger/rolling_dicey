import 'package:petitparser/debug.dart';
import 'package:petitparser/reflection.dart';
import 'package:rolling_dicey/src/grammar.dart';
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
      verify('20', [null, 20, []]);
    });

    test('d20', () {
      verify('d20', [
        // (assignment)
        null,
        // (roll)
        [
          // (dice[(quantity), 'd', (sides)])
          [null, 'd', 20],
          // (modifier)
          [],
        ],
        // (actions)
        [],
      ]);
    });

    test(
        '3d6',
        () => verify('3d6', [
              // (assignment)
              null,
              // (roll)
              [
                // (dice[(quantity), 'd', (sides)])
                [3, 'd', 6],
                // (modifier)
                [],
              ],
              // (actions)
              [],
            ]));

    test(
        '3d6+2',
        () => verify('3d6+2', [
              // (assignment)
              null,
              // (roll)
              [
                // (dice[(quantity), 'd', (sides)])
                [3, 'd', 6],
                // (modifier)
                [
                  ['+', 2],
                ],
              ],
              // (actions)
              [],
            ]));
  });

  group('explicit roll tests', () {
    test('roll 20', () {
      verify('roll 20', [
        [
          ['roll', 20],
          []
        ]
      ]);
    });

    test('roll d20', () {
      verify('roll d20', [
        [
          [
            'roll',
            [null, 'd', 20]
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
            [3, 'd', 6]
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
            [3, 'd', 6]
          ],
          []
        ],
        [
          [
            null,
            ['+', 2]
          ],
          []
        ]
      ]);
    });
  });

  group('rolling with actions tests', () {
    test('2d20 keeping lowest', () {
      verify('2d20 keep lowest', [
        null,
        [
          [2, 'd', 20],
          []
        ],
        [
          [
            'keep',
            ['lowest', null]
          ]
        ]
      ]);
    });

    test('4d6 keep highest 3', () {
      verify('4d6 keep highest 3', [
        null,
        [
          [4, 'd', 6],
          []
        ],
        [
          [
            'keep',
            ['highest', 3]
          ]
        ]
      ]);
    });
  });

  group('assignments', () {
    test('Geography<d6> <= {(1..3): Wilderness, (4..6): Urban,}', () {
      verify('2d20 keep lowest', [
        null,
        [
          [2, 'd', 20],
          []
        ],
        [
          [
            'keep',
            ['lowest', null]
          ]
        ]
      ]);
    });

    test('4d6 keep highest 3', () {
      verify('4d6 keep highest 3', [
        null,
        [
          [4, 'd', 6],
          []
        ],
        [
          [
            'keep',
            ['highest', 3]
          ]
        ]
      ]);
    });
  });
}

// // NamedMapList with each key value chosen from a SelectionList
// Quadrant[1-4] {
//   // NamedRandomSelectionList with value determined via die roll from SelectionList
//   Geography<d6> {
//     // LambdaList mapped to List<RandomSelectionList<String>>
//     [1-3]: Wilderness<d6> {
//       // [selection criteria list] => [{"large woods", "rock formation"}, {"small pool", "clump of foilage"}]
//       [1]: "1 large woods or rock ...",
//       [2,3]: "1 large woods or rock ...",
//       [4,5]: "1 large rock formation ...",
//       else: "d3 large broken down ...",
//     } else: Urban<d6> {
//       [1]: ["large structure", "small structure"],
//       [2,3]: ["large structure ...", {"small ruin", "small wood"}],
//       [4,5]: [d3"large structures ...", {"small wood", "foilage"}]
//       else: [d3"large structures ...", d3"small structures"]
//     } then: Terrain_Type<d6> {
//       [1-3]: ["Normal Terrain"],
//       [4,5]: ["Difficult Terrain"],
//       else: ["Dangerous Terrain"]
//     }
//   }
// }
// think of things like '[1-3]: ["Normal Terrain]' meaning 'replace the list,
// [1-3], with the list, ["Normal Terrain"]. The dice maps always return lists
// of things of an empty list.
//
// Creature<d20> {
//   [1-4]: <d6> {
//     [1]: "1 large woods or rock ...",
//     [2,3]: "1 large woods or rock ...",
//     [4,5]: "1 large rock formation ...",
//     else: "d3 large broken down ...",
//   },
//   else: Urban<d6> {
//     [1]: ["large structure", "small structure"],
//     [2,3]: ["large structure ...", {"small ruin", "small wood"}],
//     [4,5]: [d3"large structures ...", {"small wood", "foilage"}]
//     else: [d3"large structures ...", d3"small structures"]
//   },
// }
