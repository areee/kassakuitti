/// Selected shop: sKaupat (S-kaupat), kRuoka (K-ruoka)
enum SelectedShop {
  /// S-kaupat
  sKaupat('S-kaupat'),

  /// K-ruoka
  kRuoka('K-ruoka');

  /// A shop name.
  final String _shopName;

  /// Constructor for [SelectedShop] that sets a shop name.
  const SelectedShop(this._shopName);

  /// Returns a shop name.
  String get shopName => _shopName;
}
