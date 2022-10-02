import 'package:kassakuitti/kassakuitti.dart';

void main() {
  var kassakuitti = Kassakuitti(
      textFilePath: '/path/to/textFile.txt',
      htmlFilePath: '/path/to/htmlFile.html');
  print(kassakuitti);

  kassakuitti.run();
}
