/// Eingebaute Abteilungen. Die ID ist auf allen Geräten gleich
/// (`dep-<key>`), damit unabhängig eingerichtete Geräte beim Teilen keine
/// doppelten Abteilungen erzeugen. Neue Abteilungen nur am Ende anhängen.
enum BuiltinDepartment {
  produce,
  bakery,
  dairy,
  meat,
  fish,
  frozen,
  pasta,
  canned,
  baking,
  spices,
  breakfast,
  sweets,
  drinks,
  drugstore,
  household,
  baby,
  pet,
  other;

  String get id => 'dep-$name';

  static BuiltinDepartment? fromId(String id) {
    for (final d in values) {
      if (d.id == id) return d;
    }
    return null;
  }
}

/// Eingebaute Supermärkte (vorbelegt; umbenennen/löschen erlaubt).
enum BuiltinStore {
  aldi('Aldi', 0xFF1E5AA8),
  hit('HIT', 0xFFD52B1E),
  rewe('Rewe', 0xFFCC071E),
  netto('Netto', 0xFFF6C600);

  const BuiltinStore(this.label, this.color);

  final String label;
  final int color;

  String get id => 'store-$name';

  /// Typische Gang-Reihenfolge der Kette als Startwert. Wird beim
  /// Einkaufen nachgelernt (siehe `StoreOrderLearner`).
  List<BuiltinDepartment> get template => switch (this) {
    BuiltinStore.aldi || BuiltinStore.netto => const [
      BuiltinDepartment.produce,
      BuiltinDepartment.bakery,
      BuiltinDepartment.breakfast,
      BuiltinDepartment.pasta,
      BuiltinDepartment.canned,
      BuiltinDepartment.spices,
      BuiltinDepartment.baking,
      BuiltinDepartment.sweets,
      BuiltinDepartment.drinks,
      BuiltinDepartment.dairy,
      BuiltinDepartment.meat,
      BuiltinDepartment.fish,
      BuiltinDepartment.frozen,
      BuiltinDepartment.household,
      BuiltinDepartment.drugstore,
      BuiltinDepartment.baby,
      BuiltinDepartment.pet,
      BuiltinDepartment.other,
    ],
    BuiltinStore.hit => const [
      BuiltinDepartment.drinks,
      BuiltinDepartment.produce,
      BuiltinDepartment.bakery,
      BuiltinDepartment.meat,
      BuiltinDepartment.fish,
      BuiltinDepartment.dairy,
      BuiltinDepartment.breakfast,
      BuiltinDepartment.pasta,
      BuiltinDepartment.canned,
      BuiltinDepartment.spices,
      BuiltinDepartment.baking,
      BuiltinDepartment.sweets,
      BuiltinDepartment.frozen,
      BuiltinDepartment.drugstore,
      BuiltinDepartment.household,
      BuiltinDepartment.baby,
      BuiltinDepartment.pet,
      BuiltinDepartment.other,
    ],
    BuiltinStore.rewe => const [
      BuiltinDepartment.produce,
      BuiltinDepartment.bakery,
      BuiltinDepartment.dairy,
      BuiltinDepartment.meat,
      BuiltinDepartment.fish,
      BuiltinDepartment.pasta,
      BuiltinDepartment.canned,
      BuiltinDepartment.spices,
      BuiltinDepartment.baking,
      BuiltinDepartment.breakfast,
      BuiltinDepartment.sweets,
      BuiltinDepartment.frozen,
      BuiltinDepartment.drinks,
      BuiltinDepartment.drugstore,
      BuiltinDepartment.household,
      BuiltinDepartment.baby,
      BuiltinDepartment.pet,
      BuiltinDepartment.other,
    ],
  };
}
