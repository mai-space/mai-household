import '../text/normalize.dart';
import 'departments.dart';
import 'product_catalog.dart';

/// Ordnet einen Produktnamen einer Abteilung zu.
///
/// Kaskade (persönlich vor allgemein): eigene Historie → Wörterbuch →
/// Wortende bei zusammengesetzten Wörtern → Tippfehler-tolerant. Liefert
/// `null`, wenn nichts passt (UI fragt dann dezent nach).
class ProductClassifier {
  ProductClassifier({Map<String, String> memory = const {}})
    // ignore: prefer_initializing_formals
    : _memory = memory;

  /// Normalisierter Name → Abteilungs-ID (aus der Haushalts-Historie).
  final Map<String, String> _memory;

  static final Map<String, BuiltinDepartment> _index = _buildIndex();
  static final List<String> _suffixKeys =
      _index.keys.where((k) => k.length >= 4 && !k.contains(' ')).toList()
        ..sort((a, b) => b.length.compareTo(a.length));

  static Map<String, BuiltinDepartment> _buildIndex() {
    final map = <String, BuiltinDepartment>{};
    productCatalogSource.forEach((dep, source) {
      for (final term in source.split('|')) {
        final key = TextNorm.key(term);
        // Erster Eintrag gewinnt (Reihenfolge der Abteilungen im Katalog).
        if (key.isNotEmpty) map.putIfAbsent(key, () => dep);
      }
    });
    return map;
  }

  /// Abteilungs-ID oder `null`.
  String? classify(String name) {
    final key = TextNorm.key(name);
    if (key.isEmpty) return null;

    // Vorne stehende Zusätze schrittweise weglassen: „frische Bio Milch“
    // → „bio milch“ → „milch“.
    final words = key.split(' ');
    for (var i = 0; i < words.length; i++) {
      final candidate = words.sublist(i).join(' ');
      final remembered = _memory[candidate];
      if (remembered != null) return remembered;
      final known = _index[candidate];
      if (known != null) return known.id;
    }

    final last = words.last;
    for (final suffix in _suffixKeys) {
      if (last.length > suffix.length && last.endsWith(suffix)) {
        return _index[suffix]!.id;
      }
    }

    return _fuzzy(last)?.id;
  }

  /// Tippfehler-tolerant: bis 1 Fehler ab 5 Zeichen, 2 ab 8 Zeichen.
  static BuiltinDepartment? _fuzzy(String word) {
    if (word.length < 5) return null;
    final allowed = word.length >= 8 ? 2 : 1;
    BuiltinDepartment? best;
    var bestDistance = allowed + 1;
    for (final entry in _index.entries) {
      if (entry.key.contains(' ')) continue;
      final d = TextNorm.distance(word, entry.key, max: allowed);
      if (d < bestDistance) {
        bestDistance = d;
        best = entry.value;
        if (d == 0) break;
      }
    }
    return best;
  }

  /// Alle bekannten Begriffe (für Vorschläge, solange es noch keine
  /// eigene Historie gibt).
  static Iterable<String> get catalogKeys => _index.keys;
}
