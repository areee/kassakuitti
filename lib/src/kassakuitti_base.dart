import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/strings_to_receipt_products.dart';
import 'package:kassakuitti/src/utils/selected_file_format_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';

/// Creates a new [Kassakuitti] instance.
class Kassakuitti {
  String? textFilePath;
  String htmlFilePath;
  SelectedShop selectedShop;
  SelectedFileFormat selectedFileFormat;

  Kassakuitti(this.textFilePath, this.htmlFilePath,
      {this.selectedShop = SelectedShop.sKaupat,
      this.selectedFileFormat = SelectedFileFormat.excel});

  @override
  String toString() {
    return 'Kassakuitti(textFilePath: $textFilePath, htmlFilePath: $htmlFilePath'
        ', selectedShop: ${selectedShop.value}, selectedFileFormat: ${selectedFileFormat.value})';
  }

  /// Read receipt products from text file.
  Future<List<ReceiptProduct>> readReceiptProducts() async {
    return strings2ReceiptProducts(textFilePath);
  }
}
