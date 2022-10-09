class ReceiptProduct {
  String name;
  String totalPrice;
  int quantity;
  String pricePerUnit;
  String eanCode;
  String discountCounted;

  ReceiptProduct({
    this.name = 'Default receipt product name',
    this.totalPrice = '0',
    this.quantity = 1,
    this.pricePerUnit = '',
    this.eanCode = '',
    this.discountCounted = '',
  });

  @override
  String toString() {
    return '$quantity x $name${quantity > 1 ? ' ($pricePerUnit e / pcs)' : ''} = $totalPrice e';
  }
}
