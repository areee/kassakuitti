class Product {
  String name;
  double totalPrice;
  int quantity;
  double? pricePerUnit;
  String eanCode;

  Product({
    this.name = 'Default product name',
    this.totalPrice = 0.00,
    this.quantity = 1,
    this.pricePerUnit,
    this.eanCode = '',
  });
}
