import 'package:kassakuitti/kassakuitti.dart';
import 'package:kassakuitti/src/utils/selected_file_format_helper.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';

void main() async {
  var selectedShop = SelectedShop.sKaupat; // TODO: Change to your shop
  var selectedFileFormat =
      SelectedFileFormat.csv; // TODO: Change to your file format
  String htmlFilePath;

  if (selectedShop == SelectedShop.sKaupat) {
    print('Selected shop is ${SelectedShop.sKaupat.value}');

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

    kassakuitti.export(receiptProducts, eanProducts);
  } else {
    print('Selected shop is ${SelectedShop.kRuoka.value}');

    htmlFilePath = 'example/k-ruoka_example.html';
    var kassakuitti = Kassakuitti(null, htmlFilePath,
        selectedShop: selectedShop, selectedFileFormat: selectedFileFormat);
    print(kassakuitti);

    var eanProducts = await kassakuitti.readEANProducts();

    print('EAN products:');

    for (var element in eanProducts) {
      print(element);
    }

    kassakuitti.export(null, eanProducts);
  }
}
