import 'package:petitparser/definition.dart';
import 'package:petitparser/parser.dart';

class DiceyGrammar extends GrammarDefinition {
  Parser token(Object input) {
    if (input is Parser) {
      return input.token().trim(ref0(ignorables));
    } else if (input is String) {
      return token(input.toParser());
    } else if (input is List<String>) {
      return token(
          ChoiceParser([for (String choice in input) choice.toParser()]));
    }
    throw ArgumentError.value(input, 'Invalid token parser [input]=$input');
  }

  // -----------------------------------------------------------
  // Keyword definitions
  // -----------------------------------------------------------
  Parser chooseToken() => ref1(token, 'choose');
  Parser firstToken() => ref1(token, ['<', 'first']);
  Parser highestToken() => ref1(token, ['^', 'highest']);
  Parser lastToken() => ref1(token, ['>', 'last']);
  Parser lowestToken() => ref1(token, ['v', 'lowest']);
  Parser ofToken() => ref1(token, 'of');
  Parser additionToken() => ref1(token, ['+', 'plus']);
  Parser subtractionToken() => ref1(token, ['-', 'minus']);
  Parser multiplicationToken() => ref1(token, ['*', 'x', 'times']);
  Parser divisionToken() => ref1(token, ['/', '÷', 'divided by']);
  Parser ignorables() => whitespace().star();

  Parser formulaTerms() =>
      [ref0(formulaTerm), ref0(modifierTerm).star()].toSequenceParser();

  Parser formulaTerm() => [
        ref0(listTerm),
        // ref0(diceTerm),
        // ref0(constantTerm),
      ].toChoiceParser();

  Parser listTerm() => [
        ref1(rigidList, ref0(formulaTerms)),
        ref1(yieldingList, ref0(formulaTerms)),
        ref1(randomList, ref0(formulaTerms)),
        ref1(uniqueList, ref0(formulaTerms)),
      ].toChoiceParser();

  Parser rigidList(Parser parser) => [
        char('[').trim(),
        parser,
        char(']').trim(),
      ].toSequenceParser();

  Parser yieldingList(Parser parser) => [
        char('(').trim(),
        parser,
        char(')').trim(),
      ].toSequenceParser();

  Parser randomList(Parser parser) => [
        char('%').trim(),
        parser,
        char('%').trim(),
      ].toSequenceParser();

  Parser uniqueList(Parser parser) => [
        char('{').trim(),
        parser,
        char('}').trim(),
      ].toSequenceParser();

  Parser roll() => [
        // '3d6', 'd12', etc
        ref0(diceToken),
        ref0(ge0),
      ].toChoiceParser();

  Parser diceToken() => [
        (whitespace().star() & dieQuantity().optional()).flatten().trim(),
        char('d'),
        ge2(),
      ].toSequenceParser();

  // -----------------------------------------------------------
  // Grammar productions
  // -----------------------------------------------------------

  @override
  Parser start() => ref0(rolls).end();

  Parser rolls() => [
        ref0(setDirective),
        ref0(roll),
        ref0(modifierTerm),
      ].toChoiceParser(failureJoiner: selectFarthest);

  Parser setDirective() => [
        char('(').trim(),
        ref0(rolls).star(),
        char(')'),
      ].toSequenceParser();

  Parser dieQuantity() => ref0(ge1);

  Parser dieSides() => ref0(ge2);

  Parser modifierTerm() => [
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

  Parser ge0() => digit().plus().flatten().map(int.parse);

  Parser ge1() => [
        ref0(countingDigit),
        digit().star(),
      ].toSequenceParser().flatten();

  Parser ge2() => [
        range('2', '9', 'number >= 2 expected'),
        digit().star(),
      ].toSequenceParser().flatten();

  Parser countingDigit() => [
        range('1', '9', 'number >= 1 expected'),
        digit().star(),
      ].toSequenceParser().flatten();
}
