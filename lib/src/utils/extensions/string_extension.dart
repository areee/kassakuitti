/// Extends the [String] class with some useful methods.
extension StringExtension on String {
  /// Replace all commas with dots.
  String replaceAllCommasWithDots() {
    return replaceAll(',', '.');
  }

  /// Remove all euros from the string.
  String removeAllEuros() {
    return replaceAll(' €', '');
  }

  /// Remove all new lines from the string.
  String removeAllNewLines() {
    return replaceAll('\n', '');
  }

  /// Remove all kpls and kgs from the string.
  String removeAllKplsAndKgs() {
    return replaceAll('kpl', '').replaceAll('kg', '');
  }
}
