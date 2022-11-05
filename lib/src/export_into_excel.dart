import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/models/receipt_product.dart';

/// Export file path.
const String _exportFilePath = '~/Downloads'; // TODO: Add this to settings

/// Export receipt products into Excel file.
Future<void> exportReceiptProductsIntoExcel(
    List<ReceiptProduct> receiptProducts) async {
  // TODO: Implement this
  throw Exception('Not implemented yet.');
}

/// Export EAN products into Excel file.
Future<void> exportEANProductsIntoExcel(List<EANProduct> eanProducts) async {
  // TODO: Implement this
  throw Exception('Not implemented yet.');
}
