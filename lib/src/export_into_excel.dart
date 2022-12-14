import 'dart:io';

import 'package:flutter_excel/excel.dart';
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
    List<ReceiptProduct> receiptProducts, String? filePath) async {
  var excel = Excel.createExcel();
  var sheetObject = excel.sheets[excel.getDefaultSheet()];

  // Write the header.
  var discountCounted = false;
  var finalHeader = [...header];

  // If there's any product with discount, add discount column to Excel file.
  if (receiptProducts.any((product) => product.isDiscountCounted)) {
    discountCounted = true;
    finalHeader.add(isDiscountCountedHeader);
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
      productDataList.add(product.isDiscountCounted ? 'yes' : '');
    }
    sheetObject?.insertRowIterables(
        productDataList, receiptProducts.indexOf(product) + 1);

    // If the product is a fruit or vegetable, change the background color to green.
    if (product.isFruitOrVegetable) {
      sheetObject?.updateSelectedRowStyle(receiptProducts.indexOf(product) + 1,
          CellStyle(backgroundColorHex: '#00FF00'));
    }

    // If the product is a discount, change the background color to yellow.
    if (product.isDiscountCounted) {
      sheetObject?.updateSelectedRowStyle(receiptProducts.indexOf(product) + 1,
          CellStyle(backgroundColorHex: '#FFFF00'));
    }
  }
  // Save to the Excel (xlsx) file:
  return await _saveToExcelFile(
      excel, 'receipt_products_${formattedDateTime()}', filePath);
}

/// Export EAN products into Excel (xlsx) file.
Future<String> exportEANProductsIntoExcel(List<EANProduct> eanProducts,
    SelectedShop selectedShop, String? filePath) async {
  var excel = Excel.createExcel();
  var sheetObject = excel.sheets[excel.getDefaultSheet()];

  // Write the header.
  var finalHeader = [...header, moreDetailsHeader];
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
      product.moreDetails ?? '',
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
  return await _saveToExcelFile(excel,
      '${selectedShop.name}_ean_products_${formattedDateTime()}', filePath);
}

/// Save to the Excel (xlsx) file.
Future<String> _saveToExcelFile(Excel excel, fileName, String? filePath) async {
  String finalFilePath;
  if (filePath != null) {
    finalFilePath = join(filePath, '$fileName.xlsx');
  } else {
    finalFilePath = join(
        replaceTildeWithHomeDirectory(userDownloadsPath), '$fileName.xlsx');
  }
  var fileBytes = excel.save();
  var file = File(finalFilePath);
  await file.writeAsBytes(fileBytes!);
  return finalFilePath;
}
