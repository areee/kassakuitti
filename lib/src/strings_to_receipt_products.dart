import 'dart:io';

import 'package:kassakuitti/src/models/receipt_product.dart';

/// Read a text file and return as a list of lines.
Future<List<String>?> _readReceiptFile(String filePath) async {
  File file = File(filePath);
  try {
    return await file.readAsLines();
  } on FileSystemException {
    rethrow;
  }
}

/// Read receipt products from text file.
Future<List<ReceiptProduct>> strings2ReceiptProducts(String? filePath) async {
  if (filePath == null) {
    throw Exception('Text file path is null');
  }
  var stringList = await _readReceiptFile(filePath);
  return [];
}
