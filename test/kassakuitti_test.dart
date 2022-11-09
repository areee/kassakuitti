import 'dart:io';

import 'package:kassakuitti/kassakuitti.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/selected_file_format_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';
import 'package:mime/mime.dart';
import 'package:test/test.dart';

void main() {
  group('In Kassakuitti class', () {
    final kassakuitti = Kassakuitti('test.txt', 'test.html',
        selectedShop: SelectedShop.kRuoka,
        selectedFileFormat: SelectedFileFormat.csv);

    setUp(() {
      // Additional setup goes here.
    });

    test('Constructor works', () {
      expect(kassakuitti.textFilePath, 'test.txt');
      expect(kassakuitti.htmlFilePath, 'test.html');
      expect(kassakuitti.selectedShop, SelectedShop.kRuoka);
      expect(kassakuitti.selectedFileFormat, SelectedFileFormat.csv);
    });

    test('ToString works', () {
      expect(kassakuitti.toString(),
          'Kassakuitti(textFilePath: test.txt, htmlFilePath: test.html, selectedShop: K-ruoka, selectedFileFormat: CSV)');
    });

    test('Default values work', () {
      final kassakuittiDefaultValues = Kassakuitti('test.txt', 'test.html');
      expect(kassakuittiDefaultValues.textFilePath, 'test.txt');
      expect(kassakuittiDefaultValues.htmlFilePath, 'test.html');
      expect(kassakuittiDefaultValues.selectedShop, SelectedShop.sKaupat);
      expect(kassakuittiDefaultValues.selectedFileFormat,
          SelectedFileFormat.excel);
    });
  });

  group('When selected shop is S-kaupat', () {
    final kassakuitti = Kassakuitti(
        'example/cash_receipt_example.txt', 'example/s-kaupat_example.html',
        selectedShop: SelectedShop.sKaupat,
        selectedFileFormat: SelectedFileFormat.csv);

    final receiptProducts = kassakuitti.readReceiptProducts();
    final eanProducts = kassakuitti.readEANProducts();

    setUp(() {
      // Additional setup goes here.
    });

    test('Receipt products are not null', () {
      expect(receiptProducts, isNotNull);
    });

    test('EAN products are not null', () {
      expect(eanProducts, isNotNull);
    });

    test('Receipt products type is ok', () {
      receiptProducts.then(
        (x) {
          expect(x, isA<List<ReceiptProduct>>());
        },
      );
    });

    test('EAN products type is ok', () {
      eanProducts.then(
        (x) {
          expect(x, isA<List<EANProduct>>());
        },
      );
    });

    test('Receipt products\' amount is non-zero', () {
      receiptProducts.then(
        (x) {
          expect(x.length, isNonZero);
        },
      );
    });

    test('EAN products\' amount is non-zero', () {
      eanProducts.then(
        (x) {
          expect(x.length, isNonZero);
        },
      );
    });

    test('Null text file path throws an argument error', () {
      final kassakuitti = Kassakuitti(null, 'example/s-kaupat_example.html');
      expect(kassakuitti.readReceiptProducts(), throwsArgumentError);
    });

    test('Exported receiptProducts is not null', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(filePaths.item1!, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts is not null', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(filePaths.item2, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts file exists', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(await File(filePaths.item1!).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file exists', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(await File(filePaths.item2).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts file extension is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(filePaths.item1!.endsWith('.csv'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts mime type is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(lookupMimeType(filePaths.item1!), 'text/csv');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file extension is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(filePaths.item2.endsWith('.csv'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts mime type is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(lookupMimeType(filePaths.item2), 'text/csv');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });
  });

  group('When selected shop is K-ruoka', () {
    final kassakuitti = Kassakuitti(null, 'example/k-ruoka_example.html',
        selectedShop: SelectedShop.kRuoka,
        selectedFileFormat: SelectedFileFormat.csv);

    final eanProducts = kassakuitti.readEANProducts();

    setUp(() {
      // Additional setup goes here.
    });

    test('EAN products are not null', () {
      expect(eanProducts, isNotNull);
    });

    test('EAN products type is ok', () {
      eanProducts.then(
        (x) {
          expect(x, isA<List<EANProduct>>());
        },
      );
    });

    test('EAN products\' amount is non-zero', () {
      eanProducts.then(
        (x) {
          expect(x.length, isNonZero);
        },
      );
    });

    test('Reading receipt products throws an argument error', () {
      expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
    });

    test('Exported eanProducts is not null', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts);
      expect(filePaths.item2, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file exists', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts);
      expect(await File(filePaths.item2).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file extension is CSV', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts);
      expect(filePaths.item2.endsWith('.csv'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts mime type is CSV', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts);
      expect(lookupMimeType(filePaths.item2), 'text/csv');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });
  });

  // TODO: Add more updated tests

  // group('Read example cash receipt', () {
  //   final kassakuitti =
  //       Kassakuitti('example/cash_receipt_example.txt', 'test.html');
  //   setUp(() {
  //     // Additional setup goes here.
  //   });

  //   test('Read receipt products', (() {
  //     kassakuitti.readReceiptProducts().then((receiptProducts) {
  //       expect(receiptProducts.length, 4);
  //       expect(receiptProducts[0].name, 'peruna-sipulisekoitus');
  //       expect(receiptProducts[0].totalPrice, 0.85);
  //       expect(receiptProducts[0].quantity, 1);
  //       expect(receiptProducts[0].pricePerUnit, null);
  //       expect(receiptProducts[1].name, 'ruusukaali');
  //       expect(receiptProducts[1].totalPrice, 5.96);
  //       expect(receiptProducts[1].quantity, 2);
  //       expect(receiptProducts[1].pricePerUnit, 2.98);
  //       expect(receiptProducts[2].name, 'pakkausmateriaalit');
  //       expect(receiptProducts[2].totalPrice, 0.6);
  //       expect(receiptProducts[2].quantity, 1);
  //       expect(receiptProducts[2].pricePerUnit, null);
  //       expect(receiptProducts[3].name, 'toimitusmaksu 10,90');
  //       expect(receiptProducts[3].totalPrice, 10.9);
  //       expect(receiptProducts[3].quantity, 1);
  //       expect(receiptProducts[3].pricePerUnit, null);
  //     });
  //   }));
  // });
}
