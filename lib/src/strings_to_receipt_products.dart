import 'dart:io';

import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/extensions/double_extension.dart';
import 'package:kassakuitti/src/utils/row_helper.dart';

/// Read a text file and return as a list of rows.
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
  if (stringList == null) {
    throw Exception('Text file is empty');
  }
  return strings2ReceiptProductsFromList(stringList);
}

/// Read receipt products from a list of strings.
Future<List<ReceiptProduct>> strings2ReceiptProductsFromList(
    List<String> stringList) async {
  var helper = RowHelper();
  var receiptProducts = <ReceiptProduct>[];

  for (var row in stringList) {
    row = row.trim();
    // If row is empty, skip it.
    if (row.isEmpty) {
      continue;
    }
    row = row.toLowerCase();
    // Do not handle sum rows (after a row of strokes):
    if (row.contains('----------')) {
      break;
    }
    // Refund row:
    else if (row.contains('palautus')) {
      helper.previousRow = PreviousRow.refund;
    }
    // When the previous row is a refund row, skip the next two rows:
    else if (helper.previousRow == PreviousRow.refund) {
      if (helper.rowAmount == 1) {
        helper.rowAmount = 0;
        helper.previousRow = PreviousRow.notSet;
      } else {
        helper.rowAmount++;
      }
    }
    // A discount row:
    else if (row.contains('alennus')) {
      /*
        Split by 12-33 whitespaces.
        An example of a discount row:
        S-Etu alennus                        0,89-
      */
      var splittedItems = row.split(RegExp(r'\s{12,33}'));
      var discountPrice = double.parse(splittedItems[1]
          .replaceAll(RegExp(r'\-'), '') // Remove minus sign.
          .replaceAll(RegExp(r','), '.')); // Replace comma with dot.

      var lastProduct = receiptProducts.last;
      var origTotalPrice =
          double.parse(lastProduct.totalPrice.replaceAll(RegExp(r','), '.'));

      var discountedPrice = (origTotalPrice - discountPrice).toPrecision(2);
      var discountedPriceAsString =
          discountedPrice.toString().replaceAll(RegExp(r'\.'), ',');

      if (lastProduct.quantity > 1) {
        var discountedPricePerUnit = (discountedPrice / lastProduct.quantity)
            .toPrecision(2)
            .toString()
            .replaceAll(RegExp(r'\.'), ',');

        lastProduct.pricePerUnit = discountedPricePerUnit;
      }
      lastProduct.totalPrice = discountedPriceAsString;
      lastProduct.discountCounted = 'yes';
    }
  }

  return receiptProducts;
}
