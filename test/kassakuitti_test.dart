import 'package:kassakuitti/kassakuitti.dart';
import 'package:kassakuitti/src/utils/selected_file_format_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Kassakuitti', () {
    final kassakuitti = Kassakuitti('test.txt', 'test.html',
        selectedShop: SelectedShop.kRuoka,
        selectedFileFormat: SelectedFileFormat.csv);

    setUp(() {
      // Additional setup goes here.
    });
    test('Kassakuitti constructor', () {
      expect(kassakuitti.textFilePath, 'test.txt');
      expect(kassakuitti.htmlFilePath, 'test.html');
      expect(kassakuitti.selectedShop, SelectedShop.kRuoka);
      expect(kassakuitti.selectedFileFormat, SelectedFileFormat.csv);
    });

    test('Kassakuitti toString', () {
      expect(kassakuitti.toString(),
          'Kassakuitti(textFilePath: test.txt, htmlFilePath: test.html, selectedShop: K-ruoka, selectedFileFormat: CSV)');
    });

    test('Kassakuitti default values', () {
      final kassakuittiDefaultValues = Kassakuitti('test.txt', 'test.html');
      expect(kassakuittiDefaultValues.textFilePath, 'test.txt');
      expect(kassakuittiDefaultValues.htmlFilePath, 'test.html');
      expect(kassakuittiDefaultValues.selectedShop, SelectedShop.sKaupat);
      expect(kassakuittiDefaultValues.selectedFileFormat,
          SelectedFileFormat.excel);
    });
  });

  group('Read example cash receipt', () {
    final kassakuitti =
        Kassakuitti('example/cash_receipt_example.txt', 'test.html');
    setUp(() {
      // Additional setup goes here.
    });

    test('Read receipt products', (() {
      kassakuitti.readReceiptProducts().then((receiptProducts) {
        expect(receiptProducts.length, 4);
        expect(receiptProducts[0].name, 'peruna-sipulisekoitus');
        expect(receiptProducts[0].totalPrice, 0.85);
        expect(receiptProducts[0].quantity, 1);
        expect(receiptProducts[0].pricePerUnit, null);
        expect(receiptProducts[1].name, 'ruusukaali');
        expect(receiptProducts[1].totalPrice, 5.96);
        expect(receiptProducts[1].quantity, 2);
        expect(receiptProducts[1].pricePerUnit, 2.98);
        expect(receiptProducts[2].name, 'pakkausmateriaalit');
        expect(receiptProducts[2].totalPrice, 0.6);
        expect(receiptProducts[2].quantity, 1);
        expect(receiptProducts[2].pricePerUnit, null);
        expect(receiptProducts[3].name, 'toimitusmaksu 10,90');
        expect(receiptProducts[3].totalPrice, 10.9);
        expect(receiptProducts[3].quantity, 1);
        expect(receiptProducts[3].pricePerUnit, null);
      });
    }));
  });

  group('Kassakuitti with S-kaupat', (() {
    final kassakuitti =
        Kassakuitti(null, 'test.html', selectedShop: SelectedShop.sKaupat);
    setUp(() {
      // Additional setup goes here.
    });

    test('Null text file path throws an argument error', () {
      expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
    });
  }));

  group('Kassakuitti with K-ruoka', () {
    final kassakuitti =
        Kassakuitti(null, 'test.html', selectedShop: SelectedShop.kRuoka);
    setUp(() {
      // Additional setup goes here.
    });

    test('Read receipt products throws an argument error', () {
      expect(() => kassakuitti.readReceiptProducts(), throwsArgumentError);
    });
  });
}
