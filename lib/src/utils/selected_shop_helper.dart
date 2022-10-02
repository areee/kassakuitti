/// Selcted shop: sKaupat (S-kaupat), kRuoka (K-ruoka)
enum SelectedShop {
  sKaupat('S-kaupat'),
  kRuoka('K-ruoka');

  final String term;
  const SelectedShop(this.term);

  String get value => term;
}
