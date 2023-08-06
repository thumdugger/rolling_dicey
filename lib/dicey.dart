import 'dart:collection';

class DiceRoll {
  DiceRoll.fromRoll({required String roll});
}

class RollResult with TimeStamped {
  final int value;
  final Iterable<String> steps;
  final DateTime timestamp;

  RollResult({
    required this.value,
    required this.steps,
    DateTime? timestamp
  }) : timestamp = timestamp ?? DateTime.timestamp();
}


mixin TimeStamped implements Comparable<TimeStamped> {
  DateTime get timestamp;

  /// Return true if this occurs before [other]
  bool isBefore(TimeStamped other) => compareTo(other) < 0;

  /// Returns true if this occurs after [other]
  bool isAfter(TimeStamped other) => compareTo(other) > 0;

  /// Returns true if this occurs simultaneously with [other]
  bool isSimultaneous(TimeStamped other) => compareTo(other) == 0;

  @override
  int compareTo(TimeStamped other) => timestamp.compareTo(other.timestamp);
}

abstract class Rollable {
  int get roll;

  Rollable rollNext();

  List<DiceRoll> showStep({bool all = false});

  String toJson() {
    return '${this.runtimeType}:{}';
  }

  @override
  String toString();
}


class History {
  final _history = SplayTreeMap<DateTime, TimeStamped>();

  Iterable<DateTime> get timestamps => _history.keys;
  Iterable<TimeStamped> get events => _history.values;

  Iterable<MapEntry<DateTime, TimeStamped>> get entries => _history.entries;
}
