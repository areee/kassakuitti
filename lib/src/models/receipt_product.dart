class ReceiptProduct {
  String name;
  double totalPrice;
  int quantity;
  double? pricePerUnit;
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
