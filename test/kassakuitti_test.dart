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
}
