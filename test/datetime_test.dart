import 'dart:collection';
import 'dart:core';

void main() {
  TimeStampable pivot = TimeStampable();
  SplayTreeMap<DateTime, TimeStampable> history =
      add_timestamps(SplayTreeMap(), count: 3);

  print('history:');
  print(history);
  print('');

  pivot = history[history.firstKeyAfter(pivot.timestamp)] ?? TimeStampable();

  print('revising history ...');
  history.removeWhere((key, value) => key.isAfter(pivot.timestamp));
  print('');

  add_timestamps(history, count: 3);

  print('reivisionist history:');
  print(history);
  print('');
}

class TimeStampable implements Comparable<TimeStampable> {
  final DateTime timestamp;

  TimeStampable() : timestamp = DateTime.now();

  @override
  int compareTo(TimeStampable other) => timestamp.compareTo(other.timestamp);

  @override
  toString() => '$runtimeType{createdDtm: $timestamp}';
}

SplayTreeMap<DateTime, TimeStampable> add_timestamps(
    SplayTreeMap<DateTime, TimeStampable> history,
    {int count = 1}) {
  if (count < 0) throw ArgumentError.value(count, '[count] must be >= 0');
  if (count == 0) return history;

  TimeStampable ts = TimeStampable();
  for (int i = 0; i < count; i++) {
    while (history.containsKey(ts.timestamp)) {
      ts = TimeStampable();
    }
    history[ts.timestamp] = ts;
    ts = TimeStampable();
  }
  return history;
}
