import 'dart:math' as math;

/// Menge + Einheit + Rest, z. B. „2 l Milch“, „½ TL Salz“, „drei Paprika“.
class ParsedQuantity {
  const ParsedQuantity({this.amount, this.unit, required this.name});

  final double? amount;

  /// Kanonische Einheit (`l`, `g`, `EL` …) oder `null`.
  final String? unit;
  final String name;

  @override
  String toString() => 'ParsedQuantity($amount, $unit, $name)';
}

abstract final class Quantity {
  static const _numberWords = <String, double>{
    'ein': 1,
    'eine': 1,
    'einen': 1,
    'einem': 1,
    'einer': 1,
    'eins': 1,
    'zwei': 2,
    'drei': 3,
    'vier': 4,
    'fünf': 5,
    'sechs': 6,
    'sieben': 7,
    'acht': 8,
    'neun': 9,
    'zehn': 10,
    'elf': 11,
    'zwölf': 12,
    'fünfzehn': 15,
    'zwanzig': 20,
    'dreißig': 30,
    'fünfzig': 50,
    'hundert': 100,
    'halb': 0.5,
    'halbe': 0.5,
    'halben': 0.5,
    'halbes': 0.5,
    'einhalb': 1.5,
    'anderthalb': 1.5,
    'eineinhalb': 1.5,
    'viertel': 0.25,
    'dutzend': 12,
    'a': 1,
    'an': 1,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
    'twelve': 12,
    'half': 0.5,
    'dozen': 12,
  };

  /// Gesprochene/geschriebene Einheit → kanonische Kurzform.
  static const _units = <String, String>{
    'l': 'l',
    'liter': 'l',
    'litre': 'l',
    'liters': 'l',
    'ml': 'ml',
    'milliliter': 'ml',
    'cl': 'cl',
    'g': 'g',
    'gr': 'g',
    'gramm': 'g',
    'gram': 'g',
    'grams': 'g',
    'kg': 'kg',
    'kilo': 'kg',
    'kilogramm': 'kg',
    'pfund': 'Pfd.',
    'el': 'EL',
    'esslöffel': 'EL',
    'tbsp': 'EL',
    'tl': 'TL',
    'teelöffel': 'TL',
    'tsp': 'TL',
    'prise': 'Prise',
    'prisen': 'Prise',
    'msp': 'Msp.',
    'messerspitze': 'Msp.',
    'tasse': 'Tasse',
    'tassen': 'Tasse',
    'cup': 'Tasse',
    'cups': 'Tasse',
    'packung': 'Pck.',
    'packungen': 'Pck.',
    'pack': 'Pck.',
    'packs': 'Pck.',
    'pck': 'Pck.',
    'päckchen': 'Pck.',
    'pkg': 'Pck.',
    'dose': 'Dose',
    'dosen': 'Dose',
    'can': 'Dose',
    'cans': 'Dose',
    'flasche': 'Fl.',
    'flaschen': 'Fl.',
    'fl': 'Fl.',
    'bottle': 'Fl.',
    'bottles': 'Fl.',
    'bund': 'Bund',
    'bündel': 'Bund',
    'stück': 'Stk.',
    'stk': 'Stk.',
    'becher': 'Becher',
    'glas': 'Glas',
    'gläser': 'Glas',
    'beutel': 'Beutel',
    'tüte': 'Tüte',
    'tüten': 'Tüte',
    'netz': 'Netz',
    'kiste': 'Kiste',
    'kasten': 'Kasten',
    'tafel': 'Tafel',
    'tafeln': 'Tafel',
    'rolle': 'Rolle',
    'rollen': 'Rolle',
    'scheibe': 'Scheibe',
    'scheiben': 'Scheibe',
    'tube': 'Tube',
    'tuben': 'Tube',
    'zehe': 'Zehe',
    'zehen': 'Zehe',
    'stange': 'Stange',
    'stangen': 'Stange',
    'würfel': 'Würfel',
    'kopf': 'Kopf',
    'köpfe': 'Kopf',
    'handvoll': 'Handvoll',
    'schale': 'Schale',
    'schalen': 'Schale',
  };

  static const _fractions = <String, double>{
    '½': 0.5,
    '¼': 0.25,
    '¾': 0.75,
    '⅓': 1 / 3,
    '⅔': 2 / 3,
    '⅛': 0.125,
  };

  // Reihenfolge wichtig: „1 1/2“ vor „1/2“ vor „1½“ vor „1,5“.
  static final _amountPatterns = <RegExp>[
    RegExp(r'^(\d+)\s+(\d+)\s*/\s*(\d+)'),
    RegExp(r'^(\d+)\s*/\s*(\d+)'),
    RegExp(r'^(\d+)?\s*([½¼¾⅓⅔⅛])'),
    RegExp(r'^(\d+(?:[.,]\d+)?)'),
  ];

  /// Zerlegt „2 Liter Milch“ / „Milch 2 l“ / „½ TL Salz“ / „Salz“.
  static ParsedQuantity parse(String input) {
    var text = input.trim();
    if (text.isEmpty) return const ParsedQuantity(name: '');

    final lead = _leadingAmount(text);
    double? amount = lead?.$1;
    if (lead != null) text = lead.$2;

    String? unit;
    final unitMatch = _leadingUnit(text);
    if (unitMatch != null) {
      unit = unitMatch.$1;
      text = unitMatch.$2;
    }

    // Nachgestellte Menge: „Milch 2 Liter“, „Eier x10“.
    if (amount == null) {
      final trailing = RegExp(
        r'^(.*\S)\s+(?:x\s*)?(\d+(?:[.,]\d+)?)\s*([^\d\s]+)?$',
        caseSensitive: false,
      ).firstMatch(text);
      if (trailing != null) {
        final trailingUnit = trailing.group(3) == null
            ? null
            : _units[trailing.group(3)!.toLowerCase().replaceAll('.', '')];
        if (trailing.group(3) == null || trailingUnit != null) {
          amount = double.parse(trailing.group(2)!.replaceAll(',', '.'));
          unit = trailingUnit;
          text = trailing.group(1)!;
        }
      }
    }

    // Füllwörter zwischen Menge und Name: „ein Paket von Nudeln“.
    text = text.replaceFirst(
      RegExp(r'^(von|vom|mit|of)\s+', caseSensitive: false),
      '',
    );
    return ParsedQuantity(amount: amount, unit: unit, name: text.trim());
  }

  static (double, String)? _leadingAmount(String text) {
    for (final (i, pattern) in _amountPatterns.indexed) {
      final m = pattern.firstMatch(text);
      if (m == null) continue;
      final value = switch (i) {
        0 => _ratio(m.group(2)!, m.group(3)!) + int.parse(m.group(1)!),
        1 => _ratio(m.group(1)!, m.group(2)!),
        2 =>
          (m.group(1) == null ? 0 : int.parse(m.group(1)!)) +
              _fractions[m.group(2)]!,
        _ => double.parse(m.group(1)!.replaceAll(',', '.')),
      };
      return (value, text.substring(m.end).trim());
    }

    final firstSpace = text.indexOf(' ');
    if (firstSpace <= 0) return null;
    final word = text.substring(0, firstSpace).toLowerCase();
    final value = _numberWords[word];
    if (value == null) return null;
    var rest = text.substring(firstSpace + 1).trim();
    // „ein halbes“, „zwei einhalb“
    final next = rest.split(' ').first.toLowerCase();
    if ((next == 'halb' || next == 'halbe' || next == 'halbes') &&
        value >= 1) {
      rest = rest.substring(next.length).trim();
      return (value == 1 ? 0.5 : value + 0.5, rest);
    }
    if (next == 'einhalb') {
      rest = rest.substring(next.length).trim();
      return (value + 0.5, rest);
    }
    return (value, rest);
  }

  static double _ratio(String a, String b) {
    final d = int.parse(b);
    return d == 0 ? 0 : int.parse(a) / d;
  }

  static (String, String)? _leadingUnit(String text) {
    final match = RegExp(r'^([^\s\d]+)\.?(?:\s+|$)').firstMatch(text);
    if (match == null) return null;
    final unit = _units[match.group(1)!.toLowerCase().replaceAll('.', '')];
    if (unit == null) return null;
    final rest = text.substring(match.group(0)!.length).trim();
    // Einheit ohne Namen („2 Liter“) ist eher ein Name als eine Einheit.
    if (rest.isEmpty) return null;
    return (unit, rest);
  }

  /// Ganzzahlig zählbar (Stück, Dose …) — Skalierung rundet dann sinnvoll.
  static bool isCountUnit(String? unit) =>
      unit == null ||
      const {
        'Pck.',
        'Dose',
        'Fl.',
        'Bund',
        'Stk.',
        'Becher',
        'Glas',
        'Beutel',
        'Tüte',
        'Netz',
        'Kiste',
        'Kasten',
        'Tafel',
        'Rolle',
        'Scheibe',
        'Tube',
        'Zehe',
        'Stange',
        'Würfel',
        'Kopf',
        'Schale',
      }.contains(unit);

  /// Menge für die Anzeige: „2“, „1,5“, „½“, „250“. Deutsche Dezimalkomma.
  static String formatAmount(double value, {String decimal = ','}) {
    for (final entry in _fractions.entries) {
      if ((value - entry.value).abs() < 0.01) return entry.key;
    }
    final whole = value.truncate();
    final frac = value - whole;
    if (whole > 0 && frac > 0) {
      for (final entry in _fractions.entries) {
        if ((frac - entry.value).abs() < 0.01 && whole < 10) {
          return '$whole${entry.key}';
        }
      }
    }
    if ((value - value.roundToDouble()).abs() < 0.01) {
      return value.round().toString();
    }
    final digits = value >= 10 ? 0 : (value >= 1 ? 1 : 2);
    var s = value.toStringAsFixed(digits);
    if (s.contains('.')) {
      s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
    }
    return s.replaceAll('.', decimal);
  }

  /// Skaliert eine Menge; Stückzahlen werden zu einer Spanne („1–2“),
  /// wenn das Ergebnis nicht ganz aufgeht.
  static String formatScaled(
    double amount,
    String? unit,
    double factor, {
    String decimal = ',',
  }) {
    final value = amount * factor;
    if (isCountUnit(unit) && value >= 1) {
      final lower = value.floorToDouble();
      if ((value - lower).abs() < 0.05) return formatAmount(lower);
      if ((value - lower - 0.5).abs() < 0.05 && unit != null) {
        return formatAmount(value, decimal: decimal);
      }
      if (value - lower > 0.95) return formatAmount(lower + 1);
      return '${lower.toInt()}–${lower.toInt() + 1}';
    }
    // Gramm/Milliliter auf glatte Werte runden.
    if ((unit == 'g' || unit == 'ml') && value >= 50) {
      final step = value >= 500 ? 50 : 10;
      return formatAmount((value / step).round() * step.toDouble());
    }
    return formatAmount(_roundSensible(value), decimal: decimal);
  }

  static double _roundSensible(double v) {
    if (v == 0) return 0;
    final magnitude = math.pow(10, (math.log(v) / math.ln10).floor() - 1);
    return (v / magnitude).round() * magnitude.toDouble();
  }

  /// Große Mengen in die nächste Einheit: 1500 ml → 1,5 l, 1000 g → 1 kg.
  static (double, String?) normalize(double amount, String? unit) =>
      switch (unit) {
        'ml' when amount >= 1000 => (amount / 1000, 'l'),
        'g' when amount >= 1000 => (amount / 1000, 'kg'),
        _ => (amount, unit),
      };

  /// „2 l“, „3“, „½ TL“ oder leer.
  static String label(double? amount, String? unit, {String decimal = ','}) {
    if (amount == null && unit == null) return '';
    final a = amount == null ? '' : formatAmount(amount, decimal: decimal);
    if (unit == null) return a;
    return a.isEmpty ? unit : '$a $unit';
  }
}
