import 'package:kassakuitti/kassakuitti.dart';

void main() async {
  var selectedShop = SelectedShop.sKaupat; // or SelectedShop.kRuoka
  var selectedFileFormat = SelectedFileFormat.xlsx; // or SelectedFileFormat.csv
  String htmlFilePath;

  if (selectedShop == SelectedShop.sKaupat) {
    print('Selected shop is ${SelectedShop.sKaupat.shopName}');

    var textFilePath = 'example/cash_receipt_example.txt';
    htmlFilePath = 'example/s-kaupat_example.html';
    var kassakuitti = Kassakuitti(textFilePath, htmlFilePath,
        selectedShop: selectedShop, selectedFileFormat: selectedFileFormat);
    print(kassakuitti);

    var receiptProducts = await kassakuitti.readReceiptProducts();

    print('Receipt products:');

    for (var element in receiptProducts) {
      print(element);
    }
    print('');

    var eanProducts = await kassakuitti.readEANProducts();

    print('EAN products:');

    for (var element in eanProducts) {
      print(element);
    }

    var exportedFilePaths =
        await kassakuitti.export(receiptProducts, eanProducts);

    print('Exported file paths: $exportedFilePaths');
  } else {
    print('Selected shop is ${SelectedShop.kRuoka.shopName}');

    htmlFilePath = 'example/k-ruoka_example.html';
    var kassakuitti = Kassakuitti(null, htmlFilePath,
        selectedShop: selectedShop, selectedFileFormat: selectedFileFormat);
    print(kassakuitti);

    var eanProducts = await kassakuitti.readEANProducts();

    print('EAN products:');

    for (var element in eanProducts) {
      print(element);
    }

    var exportedFilePaths = await kassakuitti.export(null, eanProducts);
    print('Exported file paths: $exportedFilePaths');
  }
}
