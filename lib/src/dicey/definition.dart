import 'package:petitparser/definition.dart';
import 'package:petitparser/parser.dart';
import 'package:rolling_dicey/src/dicey/types.dart';

class DiceyDefinition extends GrammarDefinition<DiceRoller> {
  Parser token(Object input) {
    if (input is Parser) {
      return input.token().trim();
    } else if (input is String) {
      return token(input.toParser);
    }
    throw ArgumentError.value(input, 'invalid token parser');
  }

  @override
  Parser start() => ref0(tasks).star().end();

  Parser tasks() => [
        ref0(commandTask),
        ref0(actionTask).star(),
        ref0(assignmentTask).optional(),
      ].toSequenceParser();

  Parser assignmentTask() => [
        word().plus().flatten('word expected').trim(),
        char('=').trim(),
      ].toSequenceParser();

  Parser commandTask() => [
        // ref0(rollCommand),
        ref0(numberValue),
      ].toChoiceParser();

  // Parser rollCommand() => [
  // ref0(rollCommandToken).optional().map((cmd) => MapEntry('command', cmd)),
  // ref0(numberValue).optional().map((rolls) => MapEntry('rolls', rolls)),
  // ref0(dieDescriptor).optional().map((sides) => MapEntry('dice', ))
  // ].toSequenceParser().map3((String cmd, int rolls, int sides) => {'cmd': $cmd, 'value': $value});

  Parser numberValue() => [
        [
          range('1', '9'),
          digit().star(),
        ].toSequenceParser(),
        digit(),
      ].toChoiceParser().flatten().trim().map(int.parse);

  Parser actionTask() => [
        ref0(keepAction),
        // ref0(sortAction),
        // ref0(dropAction),
        // ref0(rerollAction),
        // ref0(modifyAction),
      ].toChoiceParser();

  Parser keepAction() => [
        ref0(keepActionToken),
        ref0(actionOption).optional(),
      ].toSequenceParser();

  Parser keepActionToken() => ref1(token, 'keep');

  Parser actionOption() => [
        ref0(firstActionOption),
        // ref0(lastActionOption),
        // ref0(lowestActionOption),
        // ref0(highestActionOption),
        // ref0(randomActionOption),
      ].toChoiceParser();

  Parser firstActionOption() => [
        ref0(firstActionOptionToken),
        ref0(numberValue).optional()
      ].toSequenceParser();

  Parser firstActionOptionToken() => ref1(token, 'first');
}
