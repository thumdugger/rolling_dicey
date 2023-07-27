import 'package:petitparser/definition.dart';
import 'package:petitparser/parser.dart';

class DiceyGrammar extends GrammarDefinition {
  Parser token(Object input) {
    if (input is Parser) {
      print('DiceGrammar.token(input=$input is Parser)');
      return input.token().trim();
    } else if (input is String) {
      print('DiceGrammar.token(input=$input is String)');
      return token(input.toParser());
    }
    throw ArgumentError.value(input, 'Invalid token parser');
  }

  // -----------------------------------------------------------
  // Keyword definitions
  // -----------------------------------------------------------
  Parser chooseToken() => ref1(token, 'choose');
  Parser firstToken() => ref1(token, 'first');
  Parser lastToken() => ref1(token, 'last');
  Parser lowestToken() => ref1(token, 'lowest');
  Parser highestToken() => ref1(token, 'highest');

  Parser ofToken() => ref1(token, 'of');

  Parser additionToken() => [
        ref1(token, '+'),
        ref1(token, 'plus'),
      ].toChoiceParser();

  Parser subtractionToken() => [
        ref1(token, '-'),
        ref1(token, 'minus'),
      ].toChoiceParser();

  Parser multiplicationToken() => [
        ref1(token, '*'),
        ref1(token, 'x'),
        ref1(token, 'times')
      ].toChoiceParser();

  Parser divisionToken() => [
        ref1(token, '/'),
        ref1(token, '÷'),
        ref1(token, 'divided by')
      ].toChoiceParser();

  Parser diceToken() => [
        (whitespace().star() & dieQuantity().optional()).flatten().trim(),
        char('d'),
        GeqToTwo(),
      ].toSequenceParser();

  // -----------------------------------------------------------
  // Grammar productions
  // -----------------------------------------------------------
  @override
  Parser start() => ref0(rolls).end();

  Parser rolls() => [
        ref0(setDirective),
        ref0(roll),
        ref0(modifier),
      ].toChoiceParser();

  Parser setDirective() => [
        char('(').trim(),
        ref0(rolls).star(),
        char(')'),
      ].toSequenceParser();

  Parser roll() => [
        // '3d6', 'd12', etc
        ref0(diceToken),
        ref0(GeqToZero),
      ].toChoiceParser();

  Parser dieQuantity() => ref0(GeqToOne);

  Parser dieSides() => ref0(GeqToTwo);

  Parser modifier() => [
        ref0(modifierOperator),
        ref0(rolls),
      ].toSequenceParser();

  Parser modifierOperator() => [
        [
          ref0(additionToken),
          ref0(subtractionToken),
          ref0(multiplicationToken),
          ref0(divisionToken),
        ].toChoiceParser(),
        ref0(rolls),
      ].toSequenceParser();

  Parser GeqToZero() => digit().plus().flatten().map(int.parse);

  Parser GeqToOne() => [
        ref0(countingDigit),
        digit().star(),
      ].toSequenceParser().flatten();

  Parser GeqToTwo() => [
        range('2', '9', 'number >= 2 expected'),
        digit().star(),
      ].toSequenceParser().flatten();

  Parser countingDigit() => [
        range('1', '9', 'number >= 1 expected'),
        digit().star(),
      ].toSequenceParser().flatten();
}
