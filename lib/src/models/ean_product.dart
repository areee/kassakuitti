import 'package:kassakuitti/src/models/product.dart';

class EANProduct implements Product {
  @override
  String name;

  @override
  double totalPrice;

  @override
  int quantity;

  @override
  double? pricePerUnit;

  @override
  String eanCode;

  String? moreDetails;

  EANProduct({
    this.name = 'Default EAN product name',
    this.totalPrice = 0.00,
    this.quantity = 1,
    this.pricePerUnit,
    this.eanCode = '',
    this.moreDetails,
  });

  bool get isFruitOrVegetable =>
      eanCode.startsWith('2') || eanCode.startsWith('02');

  bool get isPackagingMaterial => name == 'Pakkausmateriaalikustannukset';

  bool get isHomeDelivery => name == 'Kotiinkuljetus';

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
