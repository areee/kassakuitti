// TODO: Put public facing types in this file.

import 'package:kassakuitti/src/utils/selected_shop_helper.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

// ======

/// Creates a new [Kassakuitti] instance.
class Kassakuitti {
  String? textFilePath;
  String htmlFilePath;
  String? selectedShop;
  String? selectedFileFormat;

  Kassakuitti(
      {this.textFilePath,
      required this.htmlFilePath,
      this.selectedShop, // TODO: Change to enum
      this.selectedFileFormat}); // TODO: Change to enum

  @override
  String toString() {
    return 'Kassakuitti(textFilePath: $textFilePath, htmlFilePath: $htmlFilePath, selectedShop: $selectedShop, selectedFileFormat: $selectedFileFormat)';
  }
}
