import 'package:html/dom.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/utils/extensions/double_extension.dart';
import 'package:kassakuitti/src/utils/extensions/element_extension.dart';
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
  var allProducts = htmlDocument.querySelectorAll('article');

  for (var product in allProducts) {
    var totalPriceString = product
        .getChildByIndex(1)
        .getChildByIndex(2)
        .getChildByIndex(0)
        .getChildByIndex(0)
        .getChildByIndex(0)
        .text
        .trim()
        .removeAllEuros()
        .replaceAllCommasWithDots();

    var totalPrice = double.tryParse(totalPriceString);

    if (totalPrice == null) {
      throw Exception(
          'Unable to parse total price from string: $totalPriceString');
    }

    /*
      Try to get the second child of the product (quantity div).
      If it doesn't exist (e.g. packaging material payment and home delivery don't have quantity div),
      then set quantity to 1.
    */
    int quantityInt = 1;
    if (product.children.length > 2) {
      var quantityString = product
          .getChildByIndex(2)
          .getChildByIndex(0)
          .getChildByIndex(0)
          .text
          .replaceAllCommasWithDots();

      var quantityDouble = double.tryParse(quantityString);

      if (quantityDouble == null) {
        throw Exception(
            'Unable to parse quantity from string: $quantityString');
      }

      quantityInt = quantityDouble.ceil();
    }
    eanProducts.add(EANProduct(
      name: product
          .getChildByIndex(1)
          .getChildByIndex(0)
          .text
          .trim()
          .removeAllNewLines()
          .replaceAllWhitespacesWithSingleSpace(),
      totalPrice: totalPrice,
      quantity: quantityInt,
      eanCode: product.attributes['data-product-id'] ?? '',
      pricePerUnit: quantityInt == 1 || quantityInt == 0
          ? null
          : (totalPrice / quantityInt).toPrecision(2),
    ));
  }
}
