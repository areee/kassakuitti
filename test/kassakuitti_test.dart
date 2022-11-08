import 'dart:io';

import 'package:kassakuitti/kassakuitti.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/models/receipt_product.dart';
import 'package:kassakuitti/src/utils/selected_file_format_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';
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

    setUp(() {
      // Additional setup goes here.
    });
    test('Read receipt products works', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      expect(receiptProducts, isNotNull);
      expect(receiptProducts, isA<List<ReceiptProduct>>());
    });

    test('Null text file path throws an argument error', () {
      final kassakuitti = Kassakuitti(null, 'example/s-kaupat_example.html');
      expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
    });

    test('Read EAN products works', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      expect(eanProducts, isNotNull);
      expect(eanProducts, isA<List<EANProduct>>());
    });

    test('Export works with CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts);
      expect(filePaths.item1, isNotNull);
      expect(filePaths.item2, isNotNull);
      if (filePaths.item1 != null) {
        expect(await File(filePaths.item1!).exists(), true);
      }
      expect(await File(filePaths.item2).exists(), true);
      if (filePaths.item1 != null) {
        expect(filePaths.item1!.endsWith('.csv'), true);
      }
      expect(filePaths.item2.endsWith('.csv'), true);
      sleep(Duration(seconds: 2));
      if (filePaths.item1 != null) {
        await File(filePaths.item1!).delete();
      }
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

  // group('Kassakuitti with S-kaupat', (() {
  //   final kassakuitti =
  //       Kassakuitti(null, 'test.html', selectedShop: SelectedShop.sKaupat);
  //   setUp(() {
  //     // Additional setup goes here.
  //   });

  //   test('Null text file path throws an argument error', () {
  //     expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
  //   });
  // }));

  // group('Kassakuitti with K-ruoka', () {
  //   final kassakuitti =
  //       Kassakuitti(null, 'test.html', selectedShop: SelectedShop.kRuoka);
  //   setUp(() {
  //     // Additional setup goes here.
  //   });

  //   test('Read receipt products throws an argument error', () {
  //     expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
  //   });
  // });
}
