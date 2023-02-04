import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/extensions/double_extension.dart';
import 'package:kassakuitti/src/utils/extensions/string_extension.dart';
import 'package:kassakuitti/src/utils/reader_helper.dart';
import 'package:kassakuitti/src/utils/row_helper.dart';

/// Read receipt products from text file.
Future<List<ReceiptProduct>> strings2ReceiptProducts(
    String? textFilePath) async {
  if (textFilePath == null) {
    throw ArgumentError('textFilePath should not be null');
  }
  var stringList = await readTextFile(textFilePath);
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

    if (row.contains('----------')) {
      // A sum row: stop reading
      break;
    } else if (row.contains('palautus')) {
      // A refund row
      helper.previousRow = PreviousRow.refund;
    } else if (helper.previousRow == PreviousRow.refund) {
      _handleRefundRow(helper);
    } else if (row.contains('tasaerä')) {
      // An "equal instalment" row: skip it
      continue;
    } else if (row.contains('alennus') || row.contains('kampanja')) {
      // A discount or campaign row
      _handleDiscountOrCampaignRow(row, receiptProducts);
    } else if (row.startsWith(RegExp(r'^\d+\s{1}kpl'))) {
      // A quantity and price per unit row
      _handleQuantityAndPricePerUnitRow(row, receiptProducts);
    } else {
      // A "normal" row
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
    Split by two or more whitespaces.
    An example of a discount row:
    S-Etu alennus                        0,89-
  */
  var items = row.splitByFourOrMoreWhitespaces();
  var discountPrice = double.parse(items[1]
      .replaceAll(RegExp(r'\-'), '') // Remove minus sign.
      .replaceAllCommasWithDots());

  var lastProduct = receiptProducts.last;
  var discountedPrice = (lastProduct.totalPrice - discountPrice).toPrecision(2);

  if (lastProduct.quantity > 1) {
    lastProduct.pricePerUnit =
        (discountedPrice / lastProduct.quantity).toPrecision(2);
  }
  lastProduct.totalPrice = discountedPrice;
  lastProduct.isDiscountCounted = true;
}

/// Handle a quantity and price per unit row.
/// If a row starts with a digit (e.g. 4 kpl), it is a quantity and price per unit row.
void _handleQuantityAndPricePerUnitRow(
    String row, List<ReceiptProduct> receiptProducts) {
  /*
    Split by two or more whitespaces between quantity and price per unit.
    An example:
    2 kpl       2,98 €/kpl
  */
  var items = row.splitByFourOrMoreWhitespaces();
  var quantity = items[0].substring(0, 2).trim().replaceAllCommasWithDots();

  var lastProduct = receiptProducts.last;
  lastProduct.quantity = double.parse(quantity).ceil();
  lastProduct.pricePerUnit =
      double.parse(items[1].substring(0, 5).trim().replaceAllCommasWithDots());
}

/// Handle a "normal" row. An example:
/// PERUNA-SIPULISEKOITUS                0,85
void _handleNormalRow(String row, List<ReceiptProduct> receiptProducts) {
  var items = row.splitByFourOrMoreWhitespaces();
  var product = ReceiptProduct(
      name: items[0],
      totalPrice: double.parse(items[1].trim().replaceAllCommasWithDots()));
  receiptProducts.add(product);
}
