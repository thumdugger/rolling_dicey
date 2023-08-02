import 'package:petitparser/petitparser.dart';

class DiceyGrammar extends GrammarDefinition {
  @override
  Parser start() => ref0(diceRoll).star().end();

  Parser diceRoll() => [
    ref0(assignment).optional(),
    ref0(roll),
    ref0(actions).star(),
  ].toSequenceParser();

  Parser assignment() => [
    ref0(label).trim(ref0(space)),
    char('=').trim(ref0(space)),
  ].toSequenceParser();

  Parser roll() => [
    ref0(diceQuantity).optional(),
    ref0(diceOperator),
    ref0(diceSides),
    ref0(diceModifier).optional(),
  ].toSequenceParser();

  Parser diceQuantity => [
    ref0(digitZero),
    ref0(digitNonZero) & digit().star(),
  ].toChoiceParser();

  Parser digitZero() => char('0');
  Parser digitNonZero() => range('1', '9');
  Parser diceOperator() => anyOf('dD');



  Parser space() => whitespace();

  Parser token(Object parser, [String? message]) {
    if (parser is Parser) {
      return parser.flatten(message).trim();
    } else if (parser is List<String>) {
      return token(
          ChoiceParser([for (String choice in parser) choice.toParser()]));
    } else if (parser is String) {
      return token(parser.toParser(message: message ?? '$parser expected'));
    }
    throw ArgumentError.value(parser, 'parser', 'Invalid parser type');
  }

  Parser numberGT(int lesser) {
    return ref0(number).where((value) => num.parse(value) > lesser,
        failureFactory: (context, success) =>
            context.failure('value is not int parseable'));
  }

  Parser rules() => ref0(rule).star();
  Parser rule() => ref0(roll) & ref0(action).star();

  Parser roll() => ref0(rollToken).optional() & (ref0(dice) | ref0(number));
  Parser rollToken() => ref1(token, 'roll');
  Parser dice() =>
      (ref0(number).optional() & ref0(diceToken) & ref1(numberGT, 1)) |
      ref0(number);
  Parser number() => (anyOf('+-').optional() &
          ((range('1', '9') & digit().star()) | char('0')))
      .flatten()
      .trim();
  Parser diceToken() => ref1(token, 'd');

  Parser action() =>
      ref0(keepingAction) |
      ref0(sortingAction) |
      ref0(rerollingAction) |
      ref0(droppingAction);

  Parser keepingAction() => ref0(keepingToken) & ref0(keepingOption).optional();
  Parser keepingToken() => ref1(token, 'keeping');
  Parser keepingOption() => ref0(standardOption);

  Parser standardOption() =>
      (ref0(firstToken) |
          ref0(lastToken) |
          ref0(highestToken) |
          ref0(lowestToken) |
          ref0(randomToken)) &
      ref1(numberGT, 0).optional();
  Parser firstToken() => ref1(token, 'first');
  Parser lastToken() => ref1(token, 'last');
  Parser highestToken() => ref1(token, 'highest');
  Parser lowestToken() => ref1(token, 'lowest');
  Parser randomToken() => ref1(token, 'random');

  Parser sortingAction() => ref0(sortingToken) & ref0(sortingOption).optional();
  Parser sortingToken() => ref1(token, 'sorting');
  Parser sortingOption() => ref0(standardOption);

  Parser rerollingAction() =>
      ref0(rerollingToken) & ref0(rerollingOption).optional();
  Parser rerollingToken() => ref1(token, 'rerolling');
  Parser rerollingOption() => ref0(standardOption);

  Parser droppingAction() =>
      ref0(droppingToken) & ref0(droppingOption).optional();
  Parser droppingToken() => ref1(token, 'dropping');
  Parser droppingOption() => ref0(standardOption);
}
