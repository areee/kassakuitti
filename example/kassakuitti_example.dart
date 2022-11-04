import 'package:kassakuitti/kassakuitti.dart';
import 'package:kassakuitti/src/utils/selected_shop_helper.dart';

void main() async {
  var selectedShop = SelectedShop.kRuoka; // TODO: Change to your shop
  String htmlFilePath;

  if (selectedShop == SelectedShop.sKaupat) {
    print('Selected shop is S-kaupat');

    var textFilePath = 'example/cash_receipt_example.txt';
    htmlFilePath = '/path/to/htmlFile.html'; // TODO: Add an example html file
    var kassakuitti = Kassakuitti(textFilePath, htmlFilePath,
        selectedShop: SelectedShop.sKaupat);
    print(kassakuitti);

    var receiptProducts = await kassakuitti.readReceiptProducts();

    for (var element in receiptProducts) {
      print(element);
    }

    var eanProducts = await kassakuitti.readEANProducts();

    for (var element in eanProducts) {
      print(element);
    }
  } else {
    print('Selected shop is K-ruoka');

    htmlFilePath = 'example/k-ruoka_example.html';
    var kassakuitti =
        Kassakuitti(null, htmlFilePath, selectedShop: SelectedShop.kRuoka);
    print(kassakuitti);

    var eanProducts = await kassakuitti.readEANProducts();

    for (var element in eanProducts) {
      print(element);
    }
  }
}
