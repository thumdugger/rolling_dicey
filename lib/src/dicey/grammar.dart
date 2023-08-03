import 'package:petitparser/petitparser.dart';

class DiceyGrammar extends GrammarDefinition {
  @override
  Parser start() => [
        ref0(assignment).optional().trim(),
        ref0(roll).trim(),
        ref0(actions).star(),
      ].toSequenceParser().end();

  // TODO define assignment action
  Parser assignment() => undefined();

  Parser roll() => [
        [ref0(dice), ref0(modifier).star()].toSequenceParser(),
        ref0(quantity),
      ].toChoiceParser();

  /// Production for dice operator of form: (quantity)? 'd' (sides)
  Parser dice() => [
        ref0(quantity).optional(),
        char('d'),
        ref0(sides),
      ].toSequenceParser();

  /// Production for numeric values that are without leading zeroes or
  /// are zero.
  Parser quantity() => [
        ref0(digitZero),
        [
          ref0(digitNonZero),
          digit().star(),
        ].toSequenceParser(),
      ].toChoiceParser().flatten().trim();

  Parser digitZero() => char('0');

  Parser digitNonZero() => pattern('1-9');

  Parser sides() => [
        [
          ref0(digitZero),
          ref0(digitNonZero),
          digit().star(),
        ].toSequenceParser(),
        ref0(quantity),
      ].toChoiceParser().flatten().trim();

  Parser modifier() => [
        anyOf('+-*/'),
        ref0(quantity),
      ].toSequenceParser();

  Parser actions() => ref0(action) & ref0(actions).star();

  Parser action() => [
        ref0(choose),
        ref0(drop),
        ref0(reroll),
      ].toChoiceParser();

  // TODO define choose action
  Parser choose() => failure('TODO define choose action');

  // TODO define drop action
  Parser drop() => failure('TODO define drop action');

  // TODO define reroll action
  Parser reroll() => failure('TODO define reroll action');
}
