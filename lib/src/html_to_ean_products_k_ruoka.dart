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
  _handleSubstitutedProducts(htmlDocument, eanProducts);
  _handleNormalProducts(htmlDocument, eanProducts);
  var orderDetailsSection =
      htmlDocument.getElementsByClassName('old-order-details')[0];
  _handleHomeDeliveryDetails(orderDetailsSection, eanProducts);
  _handlePackagingMaterialCosts(orderDetailsSection, eanProducts);
}

/// Handle substituted products.
void _handleSubstitutedProducts(
    Document htmlDocument, List<EANProduct> eanProducts) {
  var listOfSubstitutedElements = htmlDocument
      .getElementsByClassName('old-order-substituted-products-list');
  // If list of substituted elements is empty, skip this section.
  if (listOfSubstitutedElements.isNotEmpty) {
    var substitutedProducts = listOfSubstitutedElements.first;
    for (var productRow in substitutedProducts.children) {
      var productItem = productRow.children[1].children[0];
      var quantity = double.parse(productItem
              .children[0].children[0].children[3].children[0].text
              .removeAllKplsAndKgs()
              .replaceAllCommasWithDots())
          .ceil();
      var priceElement = productItem
          .children[0].children[0].children[3].children[1].children[0];
      var productPrice =
          double.parse(_getFinalPrice(priceElement).replaceAllCommasWithDots());
      eanProducts.add(
        EANProduct(
          name: productItem
              .children[0].children[0].children[2].children[0].children[0].text
              .trim()
              .removeAllNewLines()
              .replaceAllWhitespacesWithSingleSpace(),
          totalPrice: productPrice,
          quantity: quantity,
          eanCode: productItem.id.replaceAll('department-product-item-', ''),
          pricePerUnit: quantity == 1 || quantity == 0
              ? null
              : (productPrice / quantity).toPrecision(2),
        ),
      );
    }
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
      var quantity = double.parse(productItem
              .children[0].children[0].children[2].children[0].text
              .removeAllKplsAndKgs()
              .replaceAllCommasWithDots())
          .ceil();
      var priceElement = productItem
          .children[0].children[0].children[2].children[1].children[0];
      var productPrice =
          double.parse(_getFinalPrice(priceElement).replaceAllCommasWithDots());

      eanProducts.add(
        EANProduct(
          name: productItem
              .children[0].children[0].children[1].children[0].children[0].text
              .trim()
              .removeAllNewLines()
              .replaceAllWhitespacesWithSingleSpace(),
          totalPrice: productPrice,
          quantity: quantity,
          eanCode: productItem.id.replaceAll('department-product-item-', ''),
          pricePerUnit: quantity == 1 || quantity == 0
              ? null
              : (productPrice / quantity).toPrecision(2),
        ),
      );
    }
  }
}

/// Get the final price of a product.
String _getFinalPrice(Element priceElement) {
  var childrenOfPriceElement = priceElement.children;
  var finalPrice = StringBuffer();
  for (var i = 0; i < childrenOfPriceElement.length; i++) {
    if (i != 3) {
      finalPrice.write(childrenOfPriceElement[i].text);
    }
  }
  return finalPrice.toString();
}

/// Handle home delivery details.
void _handleHomeDeliveryDetails(
    Element orderDetailsSection, List<EANProduct> eanProducts) {
  var homeDeliveryPriceSection = orderDetailsSection.children[0];
  eanProducts.add(
    EANProduct(
      name: homeDeliveryPriceSection.children[0].text,
      totalPrice: double.parse(homeDeliveryPriceSection.children[1].text
          .removeAllEuros()
          .replaceAllCommasWithDots()),
    ),
  );
}

void _handlePackagingMaterialCosts(
    Element orderDetailsSection, List<EANProduct> eanProducts) {
  // Get packaging material costs
  var packagingMaterialTexts = orderDetailsSection.children[1].children[0].text;
  /**
   * A way to get a packaging material price:
   * - Start where the price starts, e.g. 0,75
   * - End before unit (euros per box)
   */
  eanProducts.add(
    EANProduct(
      name: packagingMaterialTexts
          .substring(0, packagingMaterialTexts.indexOf(':'))
          .trim(),
      quantity: -1,
      pricePerUnit: double.parse(packagingMaterialTexts
          .substring(packagingMaterialTexts.indexOf(RegExp(r'\d+\,\d+')),
              packagingMaterialTexts.indexOf('€/ltk'))
          .trim()
          .replaceAllCommasWithDots()),
      moreDetails:
          'TODO: fill in the amount of packaging materials and the total price.',
    ),
  );
}
