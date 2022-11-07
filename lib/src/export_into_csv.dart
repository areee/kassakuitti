import 'dart:io';

import 'package:kassakuitti/src/constants.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/date_helper.dart';
import 'package:kassakuitti/src/utils/home_directory_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';
import 'package:path/path.dart';

/// Export receipt products into CSV file.
Future<void> exportReceiptProductsIntoCsv(
    List<ReceiptProduct> receiptProducts) async {
  var csv = StringBuffer();

  // Write the header.
  var discountCounted = false;
  var finalHeader = [...header];

  // If there's any product with discount, add discount column to CSV file:
  if (receiptProducts.any((product) => product.discountCounted)) {
    discountCounted = true;
    finalHeader.add('Discount counted');
  }
  // Write the header:
  csv.write('${finalHeader.join(';')}\n');

  // Write the products:
  for (var product in receiptProducts) {
    var productDataList = [
      product.name,
      product.quantity,
      product.pricePerUnit ?? '',
      product.totalPrice,
      product.eanCode,
    ];
    if (discountCounted) {
      productDataList.add(product.discountCounted);
    }
    csv.write('${productDataList.join(';')}\n');
  }
  // Save to the CSV file:
  await _saveToCsvFile(
      csv.toString(), 'receipt_products_${formattedDateTime()}');
}

/// Export EAN products into CSV file.
Future<void> exportEANProductsIntoCsv(
    List<EANProduct> eanProducts, SelectedShop selectedShop) async {
  var csv = StringBuffer();

  // Write the header:
  var finalHeader = [...header, 'More details'];
  csv.write('${finalHeader.join(';')}\n');

  // Write the products:
  for (var product in eanProducts) {
    var productDataList = [
      product.name,
      product.quantity,
      product.pricePerUnit ?? '',
      product.totalPrice,
      product.eanCode,
      product.moreDetails,
    ];
    csv.write('${productDataList.join(';')}\n');
  }

  // Save to the CSV file:
  await _saveToCsvFile(csv.toString(),
      '${selectedShop.name}_ean_products_${formattedDateTime()}');
}

/// Save to the CSV file.
Future<void> _saveToCsvFile(String csv, String fileName) async {
  var file = File(
      join(replaceTildeWithHomeDirectory(exportFilePath), '$fileName.csv'));
  await file.writeAsString(csv.toString());
}
