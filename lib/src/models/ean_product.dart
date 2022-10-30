class EANProduct {
  final String name;
  final double totalPrice;
  final int quantity;
  final double? pricePerUnit;
  final String eanCode;
  final String moreDetails;

  EANProduct(
      {this.name = 'Default EAN product name',
      this.totalPrice = 0.00,
      this.quantity = 1,
      this.pricePerUnit,
      this.eanCode = '',
      this.moreDetails = ''});

  @override
  String toString() {
    return '$quantity x $name${quantity > 1 ? ' ($pricePerUnit e / pcs)' : ''} = $totalPrice e';
  }
}
