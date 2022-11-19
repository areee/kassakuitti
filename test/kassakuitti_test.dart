import 'dart:io';

import 'package:kassakuitti/kassakuitti.dart';
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
      expect(
          kassakuittiDefaultValues.selectedFileFormat, SelectedFileFormat.xlsx);
    });
  });

  group('In ReceiptProduct class', () {
    final receiptProduct = ReceiptProduct(
        name: 'test',
        totalPrice: 1.0,
        quantity: 2,
        pricePerUnit: 0.5,
        eanCode: '1234567890123',
        isDiscountCounted: false);

    setUp(() {
      // Additional setup goes here.
    });

    test('Constructor works', () {
      expect(receiptProduct.name, 'test');
      expect(receiptProduct.totalPrice, 1.0);
      expect(receiptProduct.quantity, 2);
      expect(receiptProduct.pricePerUnit, 0.5);
      expect(receiptProduct.eanCode, '1234567890123');
      expect(receiptProduct.isDiscountCounted, false);
    });

    test('ToString works', () {
      expect(receiptProduct.toString(),
          '2 x test (0.5 e / pcs) = 1.0 e. EAN: 1234567890123.');
    });

    test('Default values work', () {
      final receiptProductDefaultValues = ReceiptProduct();
      expect(receiptProductDefaultValues.name, 'Default receipt product name');
      expect(receiptProductDefaultValues.totalPrice, 0.00);
      expect(receiptProductDefaultValues.quantity, 1);
      expect(receiptProductDefaultValues.pricePerUnit, null);
      expect(receiptProductDefaultValues.eanCode, '');
      expect(receiptProductDefaultValues.isDiscountCounted, false);
    });
  });

  group('In EANProduct class', () {
    final eanProduct = EANProduct(
        name: 'test',
        totalPrice: 1.0,
        quantity: 2,
        pricePerUnit: 0.5,
        eanCode: '1234567890123',
        moreDetails: 'test details');

    setUp(() {
      // Additional setup goes here.
    });

    test('Constructor works', () {
      expect(eanProduct.name, 'test');
      expect(eanProduct.totalPrice, 1.0);
      expect(eanProduct.quantity, 2);
      expect(eanProduct.pricePerUnit, 0.5);
      expect(eanProduct.eanCode, '1234567890123');
      expect(eanProduct.moreDetails, 'test details');
    });

    test('ToString works', () {
      expect(eanProduct.toString(),
          '2 x test (0.5 e / pcs) = 1.0 e. EAN: 1234567890123. More details: test details');
    });

    test('Default values work', () {
      final eanProductDefaultValues = EANProduct();
      expect(eanProductDefaultValues.name, 'Default EAN product name');
      expect(eanProductDefaultValues.totalPrice, 0.00);
      expect(eanProductDefaultValues.quantity, 1);
      expect(eanProductDefaultValues.pricePerUnit, null);
      expect(eanProductDefaultValues.eanCode, '');
      expect(eanProductDefaultValues.moreDetails, null);
    });
  });

  group('When the shop is S-kaupat and the format is CSV', () {
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

    test('Receipt products type is ok', () async {
      expect(await receiptProducts, isA<List<ReceiptProduct>>());
    });

    test('EAN products type is ok', () async {
      expect(await eanProducts, isA<List<EANProduct>>());
    });

    test('Receipt products\' amount is non-zero', () async {
      expect((await receiptProducts).length, isNonZero);
    });

    test('EAN products\' amount is non-zero', () async {
      expect((await eanProducts).length, isNonZero);
    });

    test('Null text file path throws an argument error', () {
      final kassakuitti = Kassakuitti(null, 'example/s-kaupat_example.html');
      expect(kassakuitti.readReceiptProducts(), throwsArgumentError);
    });

    test('Exception is thrown when receiptProducts is null in export',
        () async {
      expect(kassakuitti.export(null, await eanProducts), throwsArgumentError);
    });

    test('Exported receiptProducts is not null', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item1!, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts is not null', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts file exists', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(await File(filePaths.item1!).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file exists', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(await File(filePaths.item2).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts file extension is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item1!.endsWith('.csv'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts mime type is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(lookupMimeType(filePaths.item1!), 'text/csv');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file extension is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2.endsWith('.csv'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts mime type is CSV', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(lookupMimeType(filePaths.item2), 'text/csv');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });
  });

  group('When the shop is S-kaupat and the format is XLSX', () {
    final kassakuitti = Kassakuitti(
        'example/cash_receipt_example.txt', 'example/s-kaupat_example.html',
        selectedShop: SelectedShop.sKaupat,
        selectedFileFormat: SelectedFileFormat.xlsx);

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

    test('Receipt products type is ok', () async {
      expect(await receiptProducts, isA<List<ReceiptProduct>>());
    });

    test('EAN products type is ok', () async {
      expect(await eanProducts, isA<List<EANProduct>>());
    });

    test('Receipt products\' amount is non-zero', () async {
      expect((await receiptProducts).length, isNonZero);
    });

    test('EAN products\' amount is non-zero', () async {
      expect((await eanProducts).length, isNonZero);
    });

    test('Null text file path throws an argument error', () {
      final kassakuitti = Kassakuitti(null, 'example/s-kaupat_example.html');
      expect(kassakuitti.readReceiptProducts(), throwsArgumentError);
    });

    test('Exception is thrown when receiptProducts is null in export',
        () async {
      expect(kassakuitti.export(null, await eanProducts), throwsArgumentError);
    });

    test('Exported receiptProducts is not null', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item1!, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts is not null', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts file exists', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(await File(filePaths.item1!).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file exists', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(await File(filePaths.item2).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts file extension is XLSX', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item1!.endsWith('.xlsx'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported receiptProducts mime type is XLSX', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(lookupMimeType(filePaths.item1!),
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file extension is XLSX', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2.endsWith('.xlsx'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts mime type is XLSX', () async {
      final receiptProducts = await kassakuitti.readReceiptProducts();
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(receiptProducts, eanProducts,
          filePath: Directory.current.path);
      expect(lookupMimeType(filePaths.item2),
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item1!).delete();
      await File(filePaths.item2).delete();
    });
  });

  group('When the shop is K-ruoka and the format is CSV', () {
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

    test('EAN products type is ok', () async {
      expect(await eanProducts, isA<List<EANProduct>>());
    });

    test('EAN products\' amount is non-zero', () async {
      expect((await eanProducts).length, isNonZero);
    });

    test('Reading receipt products throws an argument error', () {
      expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
    });

    test('Exported eanProducts is not null', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file exists', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(await File(filePaths.item2).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file extension is CSV', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2.endsWith('.csv'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts mime type is CSV', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(lookupMimeType(filePaths.item2), 'text/csv');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });
  });

  group('When the shop is K-ruoka and the format is XLSX', () {
    final kassakuitti = Kassakuitti(null, 'example/k-ruoka_example.html',
        selectedShop: SelectedShop.kRuoka,
        selectedFileFormat: SelectedFileFormat.xlsx);

    final eanProducts = kassakuitti.readEANProducts();

    setUp(() {
      // Additional setup goes here.
    });

    test('EAN products are not null', () {
      expect(eanProducts, isNotNull);
    });

    test('EAN products type is ok', () async {
      expect(await eanProducts, isA<List<EANProduct>>());
    });

    test('EAN products\' amount is non-zero', () async {
      expect((await eanProducts).length, isNonZero);
    });

    test('Reading receipt products throws an argument error', () {
      expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
    });

    test('Exported eanProducts is not null', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2, isNotNull);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file exists', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(await File(filePaths.item2).exists(), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts file extension is XLSX', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(filePaths.item2.endsWith('.xlsx'), true);
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });

    test('Exported eanProducts mime type is XLSX', () async {
      final eanProducts = await kassakuitti.readEANProducts();
      final filePaths = await kassakuitti.export(null, eanProducts,
          filePath: Directory.current.path);
      expect(lookupMimeType(filePaths.item2),
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      // sleep(Duration(seconds: 2));
      await File(filePaths.item2).delete();
    });
  });

  group('In S-kaupat examples', () {
    final kassakuitti = Kassakuitti(
        'example/cash_receipt_example.txt', 'example/s-kaupat_example.html',
        selectedShop: SelectedShop.sKaupat);
    setUp(() {
      // Additional setup goes here.
    });

    test('Reading receiptProducts work', (() async {
      var receiptProducts = await kassakuitti.readReceiptProducts();
      expect(receiptProducts.length, 5);
      expect(receiptProducts[0].name, 'ruusukaali');
      expect(receiptProducts[0].totalPrice, 5.96);
      expect(receiptProducts[0].quantity, 2);
      expect(receiptProducts[0].pricePerUnit, 2.98);
      expect(receiptProducts[1].name, 'porkkanapussi');
      expect(receiptProducts[1].totalPrice, 1.35);
      expect(receiptProducts[1].quantity, 1);
      expect(receiptProducts[1].pricePerUnit, null);
      expect(receiptProducts[2].name, 'kurkku suomi');
      expect(receiptProducts[2].totalPrice, 4.5);
      expect(receiptProducts[2].quantity, 3);
      expect(receiptProducts[2].pricePerUnit, 1.5);
      expect(receiptProducts[3].name, 'pakkausmateriaalit');
      expect(receiptProducts[3].totalPrice, 0.6);
      expect(receiptProducts[3].quantity, 1);
      expect(receiptProducts[3].pricePerUnit, null);
      expect(receiptProducts[4].name, 'toimitusmaksu 10,90');
      expect(receiptProducts[4].totalPrice, 10.9);
      expect(receiptProducts[4].quantity, 1);
      expect(receiptProducts[4].pricePerUnit, null);
    }));

    test('Reading eanProducts work', (() async {
      var eanProducts = await kassakuitti.readEANProducts();
      expect(eanProducts.length, 5);
      expect(eanProducts[0].name, 'Kotimaista ruusukaali 300 g Suomi');
      expect(eanProducts[0].totalPrice, 5.96);
      expect(eanProducts[0].quantity, 2);
      expect(eanProducts[0].pricePerUnit, 2.98);
      expect(eanProducts[0].eanCode, '6414894502399');
      expect(eanProducts[0].moreDetails, null);
      expect(eanProducts[1].name, 'Kotimaista 1 kg suomalainen porkkana');
      expect(eanProducts[1].totalPrice, 1.35);
      expect(eanProducts[1].quantity, 1);
      expect(eanProducts[1].pricePerUnit, null);
      expect(eanProducts[1].eanCode, '6414894501231');
      expect(eanProducts[1].moreDetails, null);
      expect(eanProducts[2].name, 'Kurkku Suomi');
      expect(eanProducts[2].totalPrice, 4.83);
      expect(eanProducts[2].quantity, 3);
      expect(eanProducts[2].pricePerUnit, 1.61);
      expect(eanProducts[2].eanCode, '2000604700007');
      expect(eanProducts[2].moreDetails, null);
      expect(eanProducts[3].name, 'Pakkausmateriaalimaksu');
      expect(eanProducts[3].totalPrice, 0.6);
      expect(eanProducts[3].quantity, 1);
      expect(eanProducts[3].pricePerUnit, null);
      expect(eanProducts[3].eanCode, '0200060667032');
      expect(eanProducts[3].moreDetails, null);
      expect(eanProducts[4].name, 'Kotiinkuljetus');
      expect(eanProducts[4].totalPrice, 10.9);
      expect(eanProducts[4].quantity, 1);
      expect(eanProducts[4].pricePerUnit, null);
      expect(eanProducts[4].eanCode, '0200096900752');
      expect(eanProducts[4].moreDetails, null);
    }));
  });

  group('In K-ruoka examples', () {
    final kassakuitti = Kassakuitti(null, 'example/k-ruoka_example.html',
        selectedShop: SelectedShop.kRuoka);
    setUp(() {
      // Additional setup goes here.
    });

    test('Reading eanProducts work', (() async {
      var eanProducts = await kassakuitti.readEANProducts();
      expect(eanProducts.length, 5);
      expect(eanProducts[0].name, 'Pirkka suomalainen pesty porkkana 1kg 1 lk');
      expect(eanProducts[0].totalPrice, 2.0);
      expect(eanProducts[0].quantity, 2);
      expect(eanProducts[0].pricePerUnit, 1.0);
      expect(eanProducts[0].eanCode, '6410402008896');
      expect(eanProducts[0].moreDetails, null);
      expect(eanProducts[1].name, 'Kurkku Suomi');
      expect(eanProducts[1].totalPrice, 3.09);
      expect(eanProducts[1].quantity, 3);
      expect(eanProducts[1].pricePerUnit, 1.03);
      expect(eanProducts[1].eanCode, '2000604700007');
      expect(eanProducts[1].moreDetails, null);
      expect(eanProducts[2].name, 'Pirkka Vikkelät kanan jauheliha 400g');
      expect(eanProducts[2].totalPrice, 3.15);
      expect(eanProducts[2].quantity, 1);
      expect(eanProducts[2].pricePerUnit, null);
      expect(eanProducts[2].eanCode, '6410405284075');
      expect(eanProducts[2].moreDetails, null);
      expect(eanProducts[3].name, 'Kotiinkuljetus');
      expect(eanProducts[3].totalPrice, 9.9);
      expect(eanProducts[3].quantity, 1);
      expect(eanProducts[3].pricePerUnit, null);
      expect(eanProducts[3].eanCode, '');
      expect(eanProducts[3].moreDetails, null);
      expect(eanProducts[4].name, 'Pakkausmateriaalikustannukset');
      expect(eanProducts[4].totalPrice, 0.0);
      expect(eanProducts[4].quantity, -1);
      expect(eanProducts[4].pricePerUnit, 0.75);
      expect(eanProducts[4].eanCode, '');
      expect(eanProducts[4].moreDetails,
          'TODO: fill in the amount of packaging materials and the total price.');
    }));
  });
}
