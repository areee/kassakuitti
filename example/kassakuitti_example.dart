import 'package:kassakuitti/kassakuitti.dart';

void main() async {
  var textFilePath = 'example/cash_receipt_example.txt';
  var htmlFilePath = '/path/to/htmlFile.html';
  var kassakuitti = Kassakuitti(textFilePath, htmlFilePath);
  print(kassakuitti);

  var receiptProducts = await kassakuitti.readReceiptProducts();

  for (var element in receiptProducts) {
    print(element);
  }

  var eanProducts = await kassakuitti.readEANProducts();

  for (var element in eanProducts) {
    print(element);
  }
}
