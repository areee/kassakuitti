import 'package:html/dom.dart';
import 'package:kassakuitti/src/models/ean_product.dart';
import 'package:kassakuitti/src/utils/extensions/double_extension.dart';
import 'package:kassakuitti/src/utils/reader_helper.dart';

/// Read EAN products from html file.
Future<List<EANProduct>> html2EANProducts(String? filePath) async {
  if (filePath == null) {
    throw Exception('HTML file path is null');
  }
  var htmlDocument = await readHTMLFile(filePath);
  var eanProducts = <EANProduct>[];
  _html2EANProductsFromDocument(htmlDocument, eanProducts);
  return eanProducts;
}

/// Read EAN products from a [Document] and return as a [List<EANProduct>].
void _html2EANProductsFromDocument(
    Document htmlDocument, List<EANProduct> eanProducts) {
  var listOfSubstitutedElements = htmlDocument
      .getElementsByClassName('old-order-substituted-products-list');

  // If list of substituted elements is empty, skip this section.
  if (listOfSubstitutedElements.isNotEmpty) {
    _handleSubstitutedProducts(listOfSubstitutedElements, eanProducts);
  }
  _handleNormalProducts(htmlDocument, eanProducts);

  _handleHomeDeliveryDetails(htmlDocument, eanProducts);

  // Get packaging material costs
  // TODO

  /**
   * Get packaging material price.
   * - Start where the price starts, e.g. 0,75
   * - End before unit (euros per box)
   */
  // TODO
}

/// Handle substituted products.
void _handleSubstitutedProducts(
    List<Element> listOfSubstitutedElements, List<EANProduct> eanProducts) {
  var substitutedProducts = listOfSubstitutedElements.first;
  for (var product in substitutedProducts.children) {
    var productInfo = product.children[1].children[0];
    var productQuantity = productInfo.children[0].children[3].children[0].text
        .replaceAll('kpl', '')
        .replaceAll('kg', '')
        .replaceAll(',', '.');
    var quantity = double.parse(productQuantity)
        .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)
    var priceElement =
        productInfo.children[0].children[3].children[1].children[0];
    var finalPrice = StringBuffer();
    for (var i = 0; i < priceElement.children.length; i++) {
      if (i != 3) {
        finalPrice.write(priceElement.children[i].text);
      }
    }
    var productPrice =
        double.parse(finalPrice.toString().replaceAll(RegExp(r','), '.'));

    eanProducts.add(
      EANProduct(
        name: productInfo.children[0].children[2].children[0].children[0].text
            .trim()
            .replaceAll('\n', '')
            .replaceAll(RegExp(r'\s{40,50}'), ' '),
        totalPrice: productPrice,
        quantity: quantity,
        eanCode: productInfo.id.replaceAll('department-product-item-', ''),
        pricePerUnit:
            quantity == 1 ? null : (productPrice / quantity).toPrecision(2),
      ),
    );
  }
}

/// Handle normal products.
void _handleNormalProducts(
    Document htmlDocument, List<EANProduct> eanProducts) {
  var pickedProducts =
      htmlDocument.getElementsByClassName('old-order-departments')[0];
  for (var department in pickedProducts.children) {
    var itemListing = department.children[1];
    for (var productRow in itemListing.children) {
      var productItem = productRow.children[0];
      var productQuantity = productItem.children[0].children[2].children[0].text
          .replaceAll('kpl', '')
          .replaceAll('kg', '')
          .replaceAll(',', '.');
      var quantity = double.parse(productQuantity)
          .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)
      var priceElement =
          productItem.children[0].children[2].children[1].children[0];
      var finalPrice = StringBuffer();
      for (var i = 0; i < priceElement.children.length; i++) {
        if (i != 3) {
          finalPrice.write(priceElement.children[i].text);
        }
      }
      var productPrice =
          double.parse(finalPrice.toString().replaceAll(RegExp(r','), '.'));
      eanProducts.add(
        EANProduct(
          name: productItem.children[0].children[1].children[0].children[0].text
              .trim()
              .replaceAll('\n', '')
              .replaceAll(RegExp(r'\s{40,50}'), ' '),
          totalPrice: productPrice,
          quantity: quantity,
          eanCode: productItem.id.replaceAll('department-product-item-', ''),
          pricePerUnit:
              quantity == 1 ? null : (productPrice / quantity).toPrecision(2),
        ),
      );
    }
  }
}

/// Handle home delivery details.
void _handleHomeDeliveryDetails(
    Document htmlDocument, List<EANProduct> eanProducts) {
  var orderDetailsSection =
      htmlDocument.getElementsByClassName('old-order-details')[0];
  var homeDeliveryPriceSection = orderDetailsSection.children[0];
  eanProducts.add(
    EANProduct(
      name: homeDeliveryPriceSection.children[0].text,
      totalPrice: double.parse(homeDeliveryPriceSection.children[1].text
          .replaceAll(' €', '')
          .replaceAll(RegExp(r','), '.')),
    ),
  );
}
