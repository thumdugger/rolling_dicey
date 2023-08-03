class Range {
  Range({required int steps, int start = 0, int stepSize = 1})
      : this._internal(start, steps, stepSize);

  Range._internal(this.min, this.steps, this.stepSize)
      : max = min + (steps - 1) * stepSize;

  final int min;
  final int max;
  final int steps;
  final int stepSize;

  bool contains(int value) {
    if (value < min) return false;
    if (value > max) return false;
    if ((value - min) % stepSize == 0) return true;
    return false;
  }

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
