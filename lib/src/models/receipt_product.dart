import 'package:kassakuitti/src/models/product.dart';

class ReceiptProduct implements Product {
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

  bool discountCounted;

  ReceiptProduct({
    this.name = 'Default receipt product name',
    this.totalPrice = 0.00,
    this.quantity = 1,
    this.pricePerUnit,
    this.eanCode = '',
    this.discountCounted = false,
  });

  bool get isFruitOrVegetable =>
      eanCode.startsWith('2') || eanCode.startsWith('02');

  @override
  String toString() {
    return '$quantity x'
        ' $name'
        '${quantity != 1 ? ' ($pricePerUnit e / pcs)' : ''}'
        ' = $totalPrice e.'
        '${eanCode.isNotEmpty ? ' EAN: $eanCode.' : ''}'
        '${discountCounted == true ? ' Discount counted: $discountCounted' : ''}';
  }
}
