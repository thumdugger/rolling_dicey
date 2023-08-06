import 'package:petitparser/petitparser.dart';

class DiceyGrammar extends GrammarDefinition {
  Parser token(Object input) {
    if (input is Parser) {
      return input.trim();
    } else if (input is String) {
      return token(input.toParser());
    }
    throw ArgumentError.value(input, 'Invalid token parser');
  }

  // -----------------------------------------------------------------
  // Keyword definitions
  // -----------------------------------------------------------------

  /// Parser for keyword token string:: all
  Parser allToken() => ref1(token, 'all');

  /// Parser for keyword token string:: ascending
  Parser ascendingToken() => ref1(token, 'ascending');

  /// Parser for keyword token string:: descending
  Parser descendingToken() => ref1(token, 'descending');

  /// Parser for keyword token string:: drop
  Parser dropToken() => ref1(token, 'drop');

  /// Parser for keyword token string:: first
  Parser firstToken() => ref1(token, 'first');

  /// Parser for keyword token string:: highest
  Parser highestToken() => ref1(token, 'highest');

  /// Parser for keyword token string:: keep
  Parser keepToken() => ref1(token, 'keep');

  /// Parser for keyword token string:: last
  Parser lastToken() => ref1(token, 'last');

  /// Parser for keyword token string:: lowest
  Parser lowestToken() => ref1(token, 'lowest');

  /// Parser for keyword token string:: random
  Parser randomToken() => ref1(token, 'random');

  /// Parser for keyword token string:: roll
  Parser rollToken() => ref1(token, 'roll');

  // -----------------------------------------------------------------
  // Grammar productions
  // -----------------------------------------------------------------

  @override
  Parser start() => [
        ref0(assignment).optional().trim(),
        ref0(roll).trim(),
        ref0(action).star(),
      ].toSequenceParser().end();

  // TODO define assignment action
  Parser assignment() => [
        ref1(quoted, ref0(variable)),
        char('=').trim(),
      ].toSequenceParser();

  /// Parser for production of form: ['"] (variable) ['"]
  Parser quoted(Parser parser) => [
        anyOf('\'"'),
        parser,
        anyOf('\'"'),
      ].toSequenceParser();

  /// Parser for production of form:
  Parser variable() => [letter(), word().star()].toSequenceParser();

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
      ].toChoiceParser().flatten().trim().map(int.parse);

  Parser digitZero() => char('0');

  Parser digitNonZero() => pattern('1-9');

  Parser sides() => [
        [
          ref0(digitZero),
          ref0(digitNonZero),
          digit().star(),
        ].toSequenceParser(),
        ref0(quantity),
      ].toChoiceParser().flatten().trim().map(int.parse);

  Parser modifier() => [
        anyOf('+-*/'),
        ref0(quantity),
      ].toSequenceParser();

  Parser action() => [
        ref0(keep),
        ref0(drop),
        ref0(reroll),
      ].toChoiceParser();

  // TODO define choose action
  Parser keep() => [
        ref0(keepToken),
        ref0(standardOption),
      ].toSequenceParser();

  Parser standardOption() => [
        [
          ref0(allToken),
          ref0(firstToken),
          ref0(lastToken),
          ref0(highestToken),
          ref0(lowestToken),
          ref0(randomToken),
        ].toChoiceParser(),
        ref0(quantity).optional(),
      ].toSequenceParser();

  // TODO define drop action
  Parser drop() => failure('TODO define drop action');

  // TODO define reroll action
  Parser reroll() => failure('TODO define reroll action');
}
