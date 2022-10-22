import 'dart:math';

/// Extends the [double] class with some useful methods.
extension DoubleExtension on double {
  // Source (edited): https://stackoverflow.com/a/53500405/12518132
  /// Rounds the double to the specified number of decimal places.
  double toPrecision(int n) {
    num mod = pow(10.0, n);
    return ((this * mod).round().toDouble() / mod);
  }
}
