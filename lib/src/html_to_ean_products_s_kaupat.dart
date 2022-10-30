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
  var allProductsDiv = htmlDocument.body!.children[1].children[1].children[1]
      .children[0].children[0].children[0].children[5];

  for (var i = 1; i < allProductsDiv.children.length; i++) {
    var product = allProductsDiv.children[i];
    var productPrice = double.parse(product.children[0].children[0].children[1]
        .children[1].children[1].children[1].text
        .trim()
        .removeAllEuros()
        .replaceAllCommasWithDots());
    var quantity = double.parse(product.children[0].children[0].children[1]
            .children[1].children[1].children[0].children[0].text)
        .ceil();

    eanProducts.add(EANProduct(
      name: product
          .children[0].children[0].children[1].children[0].children[0].text
          .trim()
          .removeAllNewLines()
          .replaceAll(RegExp(r'\s{30}'), ' '),
      totalPrice: productPrice,
      quantity: quantity,
      eanCode: product.attributes['data-product-id'] ?? '',
      pricePerUnit:
          quantity == 1 ? null : (productPrice / quantity).toPrecision(2),
    ));
  }
}
