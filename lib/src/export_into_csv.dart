import 'dart:io';

import 'package:kassakuitti/src/constants.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/date_helper.dart';
import 'package:kassakuitti/src/utils/home_directory_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';
import 'package:path/path.dart';

/// Export receipt products into CSV file.
Future<String> exportReceiptProductsIntoCsv(
    List<ReceiptProduct> receiptProducts, String? filePath) async {
  var csv = StringBuffer();

  // Write the header.
  var discountCounted = false;
  var finalHeader = [...header];

  // If there's any product with discount, add discount column to CSV file:
  if (receiptProducts.any((product) => product.isDiscountCounted)) {
    discountCounted = true;
    finalHeader.add(isDiscountCountedHeader);
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
      productDataList.add(product.isDiscountCounted);
    }
    csv.write('${productDataList.join(';')}\n');
  }
  // Save to the CSV file:
  return await _saveToCsvFile(
      csv.toString(), 'receipt_products_${formattedDateTime()}', filePath);
}

/// Export EAN products into CSV file.
Future<String> exportEANProductsIntoCsv(List<EANProduct> eanProducts,
    SelectedShop selectedShop, String? filePath) async {
  var csv = StringBuffer();

  // Write the header:
  var finalHeader = [...header, moreDetailsHeader];
  csv.write('${finalHeader.join(';')}\n');

  // Write the products:
  for (var product in eanProducts) {
    var productDataList = [
      product.name,
      product.quantity,
      product.pricePerUnit ?? '',
      product.totalPrice,
      product.eanCode,
      product.moreDetails ?? '',
    ];
    csv.write('${productDataList.join(';')}\n');
  }

  // Save to the CSV file:
  return await _saveToCsvFile(csv.toString(),
      '${selectedShop.name}_ean_products_${formattedDateTime()}', filePath);
}

/// Save to the CSV file.
Future<String> _saveToCsvFile(
    String csv, String fileName, String? filePath) async {
  String finalFilePath;
  if (filePath != null) {
    finalFilePath = join(filePath, '$fileName.csv');
  } else {
    finalFilePath =
        join(replaceTildeWithHomeDirectory(userDownloadsPath), '$fileName.csv');
  }
  var file = File(finalFilePath);
  await file.writeAsString(csv.toString());
  return finalFilePath;
}
