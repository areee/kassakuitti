import 'package:kassakuitti/src/models/product.dart';

/// Creates a new [EANProduct] instance.
class EANProduct extends Product {
  /// More details.
  String? moreDetails;

  /// Constructor for [EANProduct].
  EANProduct({
    super.name = 'Default EAN product name',
    super.totalPrice = 0.00,
    super.quantity = 1,
    super.pricePerUnit,
    super.eanCode = '',
    this.moreDetails,
  });

  /// Is product packaging material.
  bool get isPackagingMaterial => name == 'Pakkausmateriaalikustannukset';

  /// Is product home delivery.
  bool get isHomeDelivery => name == 'Kotiinkuljetus';

  /// Override [toString] method.
  @override
  String toString() {
    return '$quantity x'
        ' $name'
        '${quantity != 1 ? ' ($pricePerUnit e / pcs)' : ''}'
        ' = $totalPrice e.'
        '${eanCode.isNotEmpty ? ' EAN: $eanCode.' : ''}'
        '${moreDetails != null ? ' More details: $moreDetails' : ''}';
  }
}
