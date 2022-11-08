import 'dart:io';

import 'package:excel/excel.dart';
import 'package:kassakuitti/src/constants.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/date_helper.dart';
import 'package:kassakuitti/src/utils/extensions/sheet_extension.dart';
import 'package:kassakuitti/src/utils/home_directory_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';
import 'package:path/path.dart';

/// Export receipt products into Excel (xlsx) file.
Future<String> exportReceiptProductsIntoExcel(
    List<ReceiptProduct> receiptProducts) async {
  var excel = Excel.createExcel();
  var sheetObject = excel.sheets[excel.getDefaultSheet()];

  // Write the header.
  var discountCounted = false;
  var finalHeader = [...header];

  // If there's any product with discount, add discount column to Excel file.
  if (receiptProducts.any((product) => product.discountCounted)) {
    discountCounted = true;
    finalHeader.add('Discount counted');
  }
  sheetObject?.insertRowIterables(finalHeader, 0);
  sheetObject?.updateSelectedRowStyle(0, CellStyle(bold: true));

  // Write the products.
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
    sheetObject?.insertRowIterables(
        productDataList, receiptProducts.indexOf(product) + 1);

    // If the product is a fruit or vegetable, change the background color to green.
    if (product.isFruitOrVegetable) {
      sheetObject?.updateSelectedRowStyle(receiptProducts.indexOf(product) + 1,
          CellStyle(backgroundColorHex: '#00FF00'));
    }
  }
  // Save to the Excel (xlsx) file:
  return await _saveToExcelFile(
      excel, 'receipt_products_${formattedDateTime()}');
}

/// Export EAN products into Excel (xlsx) file.
Future<String> exportEANProductsIntoExcel(
    List<EANProduct> eanProducts, SelectedShop selectedShop) async {
  var excel = Excel.createExcel();
  var sheetObject = excel.sheets[excel.getDefaultSheet()];

  // Write the header.
  var finalHeader = [...header, 'More details'];
  sheetObject?.insertRowIterables(finalHeader, 0);
  sheetObject?.updateSelectedRowStyle(0, CellStyle(bold: true));

  // Write the products.
  for (var product in eanProducts) {
    var productDataList = [
      product.name,
      product.quantity,
      product.pricePerUnit ?? '',
      product.totalPrice,
      product.eanCode,
      product.moreDetails
    ];
    sheetObject?.insertRowIterables(
        productDataList, eanProducts.indexOf(product) + 1);

    /*
      If the product is a fruit or vegetable,
      change the background color to green.
    */
    if (product.isFruitOrVegetable) {
      sheetObject?.updateSelectedRowStyle(eanProducts.indexOf(product) + 1,
          CellStyle(backgroundColorHex: '#00FF00'));
    }

    /*
      If the product is a packaging material,
      change the font color to red and the background color to green.
    */
    if (product.isPackagingMaterial) {
      sheetObject?.updateSelectedRowStyle(eanProducts.indexOf(product) + 1,
          CellStyle(backgroundColorHex: '#00FF00', fontColorHex: '#FF0000'));
    }

    /*
      If the product is a home delivery,
      change the background color to green.
    */
    if (product.isHomeDelivery) {
      sheetObject?.updateSelectedRowStyle(eanProducts.indexOf(product) + 1,
          CellStyle(backgroundColorHex: '#00FF00'));
    }
  }

  // Save to the Excel (xlsx) file:
  return await _saveToExcelFile(
      excel, '${selectedShop.name}_ean_products_${formattedDateTime()}');
}

/// Save to the Excel (xlsx) file.
Future<String> _saveToExcelFile(Excel excel, fileName) async {
  var fileBytes = excel.save();
  var filePath =
      join(replaceTildeWithHomeDirectory(exportFilePath), '$fileName.xlsx');
  var file = File(filePath);
  await file.writeAsBytes(fileBytes!);
  return filePath;
}
