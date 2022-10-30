import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/utils/extensions/double_extension.dart';

/// Read EAN products from html file.
Future<List<EANProduct>> html2EANProducts(String? filePath) async {
  if (filePath == null) {
    throw Exception('HTML file path is null');
  }
  var htmlDocument = await _readHTMLFile(filePath);
  return await _html2EANProductsFromDocument(htmlDocument);
}

/// Read a HTML file and return as a [Document].
Future<Document> _readHTMLFile(String filePath) async {
  try {
    var file = File(filePath);
    var html = await file.readAsString();
    return parse(html);
  } on Exception {
    rethrow;
  }
}

/// Read EAN products from a [Document] and return as a [List<EANProduct>].
Future<List<EANProduct>> _html2EANProductsFromDocument(
    Document htmlDocument) async {
  var eanProducts = <EANProduct>[];
  var allProductsDiv = htmlDocument.body!.children[1].children[1].children[1]
      .children[0].children[0].children[0].children[5];

  for (var i = 1; i < allProductsDiv.children.length; i++) {
    var product = allProductsDiv.children[i];
    var productQuantity = product.children[0].children[0].children[1]
        .children[1].children[1].children[0].children[0].text;
    var productPrice = double.parse(product.children[0].children[0].children[1]
        .children[1].children[1].children[1].text
        .trim()
        .replaceAll(' €', '')
        .replaceAll(RegExp(r','), '.'));
    var quantity = double.parse(productQuantity)
        .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)

    eanProducts.add(EANProduct(
      name: product
          .children[0].children[0].children[1].children[0].children[0].text
          .trim()
          .replaceAll('\n', '')
          .replaceAll(RegExp(r'\s{30}'), ' '),
      totalPrice: productPrice,
      quantity: quantity,
      eanCode: product.attributes['data-product-id'] ?? '',
      pricePerUnit:
          quantity == 1 ? null : (productPrice / quantity).toPrecision(2),
    ));
  }
  return eanProducts;
}
