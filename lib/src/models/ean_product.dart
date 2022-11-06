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

  bool get isFruitOrVegetable =>
      eanCode.startsWith("2") || eanCode.startsWith("02");

  bool get isPackagingMaterial => name == 'Pakkausmateriaalikustannukset';

  bool get isHomeDelivery => name == 'Kotiinkuljetus';

  @override
  String toString() {
    return '$quantity x'
        ' $name'
        '${quantity != 1 ? ' ($pricePerUnit e / pcs)' : ''}'
        ' = $totalPrice e.'
        '${eanCode.isNotEmpty ? ' EAN: $eanCode.' : ''}'
        '${moreDetails.isNotEmpty ? ' More details: $moreDetails' : ''}';
  }
}
