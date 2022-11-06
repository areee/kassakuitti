import 'dart:io';

import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/date_helper.dart';
import 'package:kassakuitti/src/utils/home_directory_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';
import 'package:path/path.dart';

/// Export file path.
const String _exportFilePath = '~/Downloads'; // TODO: Add this to settings

/// Export receipt products into CSV file.
Future<void> exportReceiptProductsIntoCsv(
    List<ReceiptProduct> receiptProducts) async {
  var csv = StringBuffer();
  var header = '';
  var discountCounted = false;

  // If there's any product with discount, add discount column to CSV file:
  if (receiptProducts.any((product) => product.discountCounted)) {
    discountCounted = true;
    header =
        'Name;Amount;Price per unit;Total price;Discount counted;EAN code\n';
  } else {
    header = 'Name;Amount;Price per unit;Total price;EAN code\n';
  }
  // Write the header:
  csv.write(header);

  // Write the products:
  for (var product in receiptProducts) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit ?? ''};${product.totalPrice}${discountCounted ? ';${product.discountCounted}' : ''};${product.eanCode}\n');
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
  csv.write('Name;Amount;Price per unit;Total price;EAN code;More details\n');

  // Write the products:
  for (var item in eanProducts) {
    csv.write(
        '${item.name};${item.quantity};${item.pricePerUnit ?? ''};${item.totalPrice};${item.eanCode};${item.moreDetails}\n');
  }

  // Save to the CSV file:
  await _saveToCsvFile(csv.toString(),
      '${selectedShop.name}_ean_products_${formattedDateTime()}');
}

/// Save to the CSV file.
Future<void> _saveToCsvFile(String csv, String fileName) async {
  var file = File(
      join(replaceTildeWithHomeDirectory(_exportFilePath), '$fileName.csv'));
  await file.writeAsString(csv.toString());
}
