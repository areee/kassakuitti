import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/extensions/double_extension.dart';
import 'package:kassakuitti/src/utils/reader_helper.dart';
import 'package:kassakuitti/src/utils/row_helper.dart';

/// Read receipt products from text file.
Future<List<ReceiptProduct>> strings2ReceiptProducts(String? filePath) async {
  if (filePath == null) {
    throw Exception('Text file path is null');
  }
  var stringList = await readTextFile(filePath);
  var receiptProducts = <ReceiptProduct>[];
  _strings2ReceiptProductsFromList(stringList, receiptProducts);
  return receiptProducts;
}

/// Read receipt products from a list of strings.
void _strings2ReceiptProductsFromList(
    List<String> stringList, List<ReceiptProduct> receiptProducts) {
  var helper = RowHelper();
  for (var row in stringList) {
    // If row is empty, skip it.
    if (row.isEmpty) {
      continue;
    }
    row = row.trim();
    row = row.toLowerCase();
    // Replace non-breaking space with a normal space
    row = row.replaceAll(RegExp(r'\u00a0'), ' ');

    // Do not handle sum rows (after a row of strokes):
    if (row.contains('----------')) {
      break;
    } else if (row.contains('palautus')) {
      helper.previousRow = PreviousRow.refund;
    } else if (helper.previousRow == PreviousRow.refund) {
      _handleRefundRow(helper);
    } else if (row.contains('alennus') || row.contains('kampanja')) {
      _handleDiscountOrCampaignRow(row, receiptProducts);
    } else if (row.startsWith(RegExp(r'^\d+\s{1}kpl'))) {
      _handleQuantityAndPricePerUnitRow(row, receiptProducts);
    } else {
      _handleNormalRow(row, receiptProducts);
    }
  }
}

/// Handle a refund row.
/// When the previous row is a refund row, skip the next two rows.
void _handleRefundRow(RowHelper helper) {
  if (helper.previousRow == PreviousRow.refund) {
    if (helper.rowAmount == 1) {
      helper.rowAmount = 0;
      helper.previousRow = PreviousRow.notSet;
    } else {
      helper.rowAmount++;
    }
  }
}

/// Handle a discount or campaign row.
/// Campaign row = usually means that there's a mistake in the previous row BUT not always
/// -> let's assume that it's a discount row.
void _handleDiscountOrCampaignRow(
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
  var discountedPrice = (lastProduct.totalPrice - discountPrice).toPrecision(2);

  if (lastProduct.quantity > 1) {
    lastProduct.pricePerUnit =
        (discountedPrice / lastProduct.quantity).toPrecision(2);
  }
  lastProduct.totalPrice = discountedPrice;
  lastProduct.discountCounted = true;
}

/// Handle a quantity and price per unit row.
/// If a row starts with a digit (e.g. 4 kpl), it is a quantity and price per unit row.
void _handleQuantityAndPricePerUnitRow(
    String row, List<ReceiptProduct> receiptProducts) {
  /*
    Split by 6-7 whitespaces between quantity and price per unit.
    An example:
    2 kpl       2,98 €/kpl
  */
  var items = row.split(RegExp(r'\s{6,7}'));
  var quantity = items[0].substring(0, 2).trim().replaceAll(RegExp(r','), '.');

  var lastProduct = receiptProducts.last;
  // ceiling means e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)
  lastProduct.quantity = double.parse(quantity).ceil();
  lastProduct.pricePerUnit = double.parse(
      items[1].substring(0, 5).trim().replaceAll(RegExp(r','), '.'));
}

/// Handle a "normal" row. An example:
/// PERUNA-SIPULISEKOITUS                0,85
void _handleNormalRow(String row, List<ReceiptProduct> receiptProducts) {
  var items = row.split(RegExp(r'\s{8,35}'));
  var product = ReceiptProduct(
      name: items[0],
      totalPrice: double.parse(items[1].trim().replaceAll(RegExp(r','), '.')));
  receiptProducts.add(product);
}
