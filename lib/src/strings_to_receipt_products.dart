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
    // Replace non-breaking space with a normal space
    row = row.replaceAll(RegExp(r'\u00a0'), ' ');

    // Do not handle sum rows (after a row of strokes):
    if (row.contains('----------')) {
      break;
    }
    // Refund row:
    else if (row.contains('palautus')) {
      helper.previousRow = PreviousRow.refund;
    } else if (helper.previousRow == PreviousRow.refund) {
      _handleRefundRow(helper);
    } else if (row.contains('alennus') || row.contains('kampanja')) {
      _handleDiscountOrCampaignRow(row, receiptProducts);
    } else if (row.startsWith(RegExp(r'^\d+\s{1}kpl'))) {
      _handleQuantityAndPricePerUnitRow(row, receiptProducts);
    }

    /*
      A "normal" row. An example:
      PERUNA-SIPULISEKOITUS                0,85
    */
    else {
      var items = row.split(RegExp(r'\s{8,35}'));
      var name = items[0];
      var price = double.parse(items[1].trim().replaceAll(RegExp(r','), '.'));

      var product = ReceiptProduct(name: name, totalPrice: price);
      receiptProducts.add(product);
    }
  }
  return receiptProducts;
}

/// Handle a refund row.
/// When the previous row is a refund row, skip the next two rows.
RowHelper _handleRefundRow(RowHelper helper) {
  if (helper.previousRow == PreviousRow.refund) {
    if (helper.rowAmount == 1) {
      helper.rowAmount = 0;
      helper.previousRow = PreviousRow.notSet;
    } else {
      helper.rowAmount++;
    }
  }
  return helper;
}

/// Handle a discount or campaign row.
/// Campaign row = usually means that there's a mistake in the previous row BUT not always
/// -> let's assume that it's a discount row.
List<ReceiptProduct> _handleDiscountOrCampaignRow(
    String row, List<ReceiptProduct> receiptProducts) {
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
  var origTotalPrice = lastProduct.totalPrice;

  var discountedPrice = (origTotalPrice - discountPrice).toPrecision(2);

  if (lastProduct.quantity > 1) {
    lastProduct.pricePerUnit =
        (discountedPrice / lastProduct.quantity).toPrecision(2);
  }
  lastProduct.totalPrice = discountedPrice;
  lastProduct.discountCounted = true;

  return receiptProducts;
}

/// Handle a quantity and price per unit row.
/// If a row starts with a digit (e.g. 4 kpl), it is a quantity and price per unit row.
List<ReceiptProduct> _handleQuantityAndPricePerUnitRow(
    String row, List<ReceiptProduct> receiptProducts) {
  /*
    Split by 6-7 whitespaces between quantity and price per unit.
    An example:
    2 kpl       2,98 €/kpl
  */
  var items = row.split(RegExp(r'\s{6,7}'));
  var quantity = items[0].substring(0, 2).trim().replaceAll(RegExp(r','), '.');

  var lastProduct = receiptProducts.last;
  lastProduct.quantity = double.parse(quantity)
      .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)
  lastProduct.pricePerUnit = double.parse(
      items[1].substring(0, 5).trim().replaceAll(RegExp(r','), '.'));
  return receiptProducts;
}
