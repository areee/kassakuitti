/// Creates a new [Product] instance.
class Product {
  /// Product name.
  String name;

  /// Total price.
  double totalPrice;

  /// Quantity.
  int quantity;

  /// Price per unit.
  double? pricePerUnit;

  /// EAN code.
  String eanCode;

  /// Constructor for [Product].
  Product({
    this.name = 'Default product name',
    this.totalPrice = 0.00,
    this.quantity = 1,
    this.pricePerUnit,
    this.eanCode = '',
  });

  /// Is product fruit or vegetable (or other).
  bool get isFruitOrVegetable =>
      eanCode.startsWith('2') || eanCode.startsWith('02');
}
