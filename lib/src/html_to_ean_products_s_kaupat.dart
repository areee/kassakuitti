import 'package:html/dom.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/utils/extensions/double_extension.dart';
import 'package:kassakuitti/src/utils/extensions/string_extension.dart';
import 'package:kassakuitti/src/utils/reader_helper.dart';

/// Read EAN products from [String] filePath and returns a [Future] of [List] of [EANProduct].
Future<List<EANProduct>> html2EANProducts(String? filePath) async {
  if (filePath == null) {
    throw Exception('HTML file path is null');
  }
  var htmlDocument = await readHTMLFile(filePath);
  var eanProducts = <EANProduct>[];
  _html2EANProductsFromDocument(htmlDocument, eanProducts);
  return eanProducts;
}

/// Read EAN products from a [Document].
void _html2EANProductsFromDocument(
    Document htmlDocument, List<EANProduct> eanProducts) {
  var allProductsDiv = htmlDocument.body!.children[1].children[1].children[2]
      .children[0].children[0].children[1].children[5];
  var childrenOfAllProductsDiv = allProductsDiv.children;
  for (var i = 1; i < childrenOfAllProductsDiv.length; i++) {
    var product = childrenOfAllProductsDiv[i];
    var totalPrice = double.parse(product
        .children[1].children[1].children[0].text
        .trim()
        .removeAllEuros()
        .replaceAllCommasWithDots());

    /*
      Try to get the second child of the product (quantity div).
      If it doesn't exist (e.g. packaging material payment and home delivery don't have quantity div),
      then set quantity to 1.
    */
    int quantity = 1;
    if (product.children.length > 2) {
      quantity = double.parse(product.children[2].children[0].children[0].text
              .replaceAllCommasWithDots())
          .ceil();
    }
    eanProducts.add(EANProduct(
      name: product.children[1].children[0].text
          .trim()
          .removeAllNewLines()
          .replaceAllWhitespacesWithSingleSpace(),
      totalPrice: totalPrice,
      quantity: quantity,
      eanCode: product.attributes['data-product-id'] ?? '',
      pricePerUnit: quantity == 1 || quantity == 0
          ? null
          : (totalPrice / quantity).toPrecision(2),
    ));
  }
}
