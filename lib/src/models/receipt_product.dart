import 'package:kassakuitti/src/models/product.dart';

/// Creates a new [ReceiptProduct] instance.
class ReceiptProduct extends Product {
  /// Is discount counted.
  bool isDiscountCounted;

  ReceiptProduct({
    super.name = 'Default receipt product name',
    super.totalPrice = 0.00,
    super.quantity = 1,
    super.pricePerUnit,
    super.eanCode = '',
    this.isDiscountCounted = false,
  });

  /// Override [toString] method.
  @override
  String toString() {
    return '$quantity x'
        ' $name'
        '${quantity != 1 ? ' ($pricePerUnit e / pcs)' : ''}'
        ' = $totalPrice e.'
        '${eanCode.isNotEmpty ? ' EAN: $eanCode.' : ''}'
        '${isDiscountCounted == true ? ' Is discount counted: $isDiscountCounted' : ''}';
  }
}
