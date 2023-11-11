import 'package:html/dom.dart';

/// Extension methods for [Element].
extension ElementExtension on Element {
  /// Get the child by the given [index].
  Element getChildByIndex(int index) {
    final children = this.children;
    if (index >= 0 && index < children.length) return children[index];

    throw Exception(
        'Child index $index is out of bounds (children length is ${children.length})');
  }
}
