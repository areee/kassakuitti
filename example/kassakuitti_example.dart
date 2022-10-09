import 'package:kassakuitti/kassakuitti.dart';

void main() async {
  var textFilePath = '/path/to/textFile.txt';
  var htmlFilePath = '/path/to/htmlFile.html';
  var kassakuitti = Kassakuitti(textFilePath, htmlFilePath);
  print(kassakuitti);

  var receiptProducts = await kassakuitti.readReceiptProducts();
}
