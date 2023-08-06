class Range extends Iterable {
  Range(int steps, {int start = 0, int stepSize = 1})
      : this._internal(start, steps, stepSize);

  Range._internal(this.min, this.steps, this.stepSize)
      : max = min + (steps - 1) * stepSize;

  late final int min;
  late final int max;
  late final int steps;
  late final int stepSize;
  late final List<int>? _list;

  bool contains(Object? value) {
    if (value is! int) return false;
    if (_list == null) {
      if (value < min) return false;
      if (value > max) return false;
      if ((value - min) % stepSize == 0) return true;
    } else {}
    return false;
  }

  Iterator<int> get iterator => RangeIterator(this);

  int get first => min;

  int get last => max;

  /// The int at the given index of values in the range.
  ///
  /// The [index] must be in the interval [0, steps)
  int operator [](int index) {
    if (index < 0) throw ArgumentError('[index]=$index but must be >= 0');
    if (index > steps)
      throw ArgumentError('[index]=$index but must be < length=$steps');
    return min + (index * stepSize);
  }

  @override
  String toString() =>
      '${runtimeType}{min: $min, steps: $steps, stepSize: $stepSize}';
}

class RangeIterator implements Iterator<int> {
  RangeIterator(Range range, {int start = 0})
      : _range = range,
        _index = start;

  final Range _range;
  int _index;

  @override
  int get current => _index < _range.steps
      ? _range[_index]
      : throw StateError('no values remain to iterate through');

  @override
  bool moveNext() {
    _index += 1;
    return _index < _range.steps;
  }

  @override
  String toString() => '$runtimeType{current: $current}';
}
