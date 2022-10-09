import 'package:kassakuitti/kassakuitti.dart';

void main() {
  var textFilePath = '/path/to/textFile.txt';
  var htmlFilePath = '/path/to/htmlFile.html';
  var kassakuitti = Kassakuitti(textFilePath, htmlFilePath);
  print(kassakuitti);

  var a = kassakuitti.readReceiptProducts();
}
