import 'package:kassakuitti/src/export_into_csv.dart';
import 'package:kassakuitti/src/export_into_excel.dart';
import 'package:kassakuitti/src/html_to_ean_products_k_ruoka.dart' as k_ruoka;
import 'package:kassakuitti/src/html_to_ean_products_s_kaupat.dart' as s_kaupat;
import 'package:kassakuitti/src/models/ean_product.dart';
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
    if (selectedShop == SelectedShop.sKaupat) {
      return await strings2ReceiptProducts(textFilePath);
    } else {
      throw ArgumentError(
          'selectedShop should be ${SelectedShop.sKaupat.value}, but it was ${selectedShop.value}.');
    }
  }

  /// Read EAN products from html file.
  Future<List<EANProduct>> readEANProducts() async {
    return selectedShop.value == SelectedShop.sKaupat.value
        ? await s_kaupat.html2EANProducts(htmlFilePath)
        : await k_ruoka.html2EANProducts(htmlFilePath);
  }

  /// Export recept products and EAN products into CSV or Excel file.
  Future<void> export(List<ReceiptProduct>? receiptProducts,
      List<EANProduct> eanProducts) async {
    if (selectedShop == SelectedShop.sKaupat) {
      // Selected shop is S-kaupat
      if (receiptProducts == null) {
        throw ArgumentError('receiptProducts should not be null.');
      }
      if (selectedFileFormat == SelectedFileFormat.csv) {
        // Export into CSV file
        exportReceiptProductsIntoCsv(receiptProducts);
        exportEANProductsIntoCsv(eanProducts, selectedShop);
      } else {
        // Export into Excel file
        exportReceiptProductsIntoExcel(receiptProducts);
        exportEANProductsIntoExcel(eanProducts);
      }
    } else {
      // Selected shop is K-ruoka
      if (selectedFileFormat == SelectedFileFormat.csv) {
        // Export into CSV file
        exportEANProductsIntoCsv(eanProducts, selectedShop);
      } else {
        // Export into Excel file
        exportEANProductsIntoExcel(eanProducts);
      }
    }
  }
}
