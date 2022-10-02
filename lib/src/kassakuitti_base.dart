// TODO: Put public facing types in this file.

import 'package:kassakuitti/src/utils/selected_file_format_helper.dart';
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
  SelectedShop selectedShop;
  SelectedFileFormat selectedFileFormat;

  Kassakuitti(
      {this.textFilePath,
      required this.htmlFilePath,
      this.selectedShop = SelectedShop.sKaupat,
      this.selectedFileFormat = SelectedFileFormat.excel});

  // Kassakuitti.anotherConstructor(this.textFilePath, this.htmlFilePath,
  //     {this.selectedShop = SelectedShop.sKaupat,
  //     this.selectedFileFormat = SelectedFileFormat.excel});

  @override
  String toString() {
    return 'Kassakuitti(textFilePath: $textFilePath, htmlFilePath: $htmlFilePath, selectedShop: $selectedShop, selectedFileFormat: $selectedFileFormat)';
  }
}
