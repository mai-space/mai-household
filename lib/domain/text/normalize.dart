/// Textnormalisierung für den Abgleich von Produktnamen.
///
/// „Äpfel“, „Apfel“ und „ÄPFEL “ sollen denselben Schlüssel ergeben, damit
/// Historie, Wörterbuch und Zusammenführen doppelter Einträge greifen.
abstract final class TextNorm {
  static final _punct = RegExp(r'''[.,;:!?"'()\[\]{}«»„“”‚‘’/\\*+#_]''');
  static final _space = RegExp(r'\s+');

  /// Kleinschreibung, Satzzeichen weg, Leerraum zusammengefasst, ß → ss.
  static String basic(String input) => input
      .toLowerCase()
      .replaceAll('ß', 'ss')
      .replaceAll(_punct, ' ')
      .replaceAll('-', ' ')
      .replaceAll(_space, ' ')
      .trim();

  /// Umlaute auf Grundvokal (für Plural „Äpfel“ → „apfel“).
  static String foldUmlauts(String s) => s
      .replaceAll('ä', 'a')
      .replaceAll('ö', 'o')
      .replaceAll('ü', 'u');

  /// Schlüssel zum Speichern/Vergleichen: einfach normalisiert, Umlaute
  /// gefaltet, letztes Wort auf eine Singularform reduziert.
  static String key(String input) {
    final words = foldUmlauts(basic(input)).split(' ');
    if (words.isEmpty || words.first.isEmpty) return '';
    words[words.length - 1] = singular(words.last);
    return words.join(' ');
  }

  /// Grobe deutsche/englische Singularbildung. Bewusst konservativ:
  /// lieber eine Variante zu viel im Wörterbuch als falsche Kürzungen.
  static String singular(String w) {
    if (w.length <= 3) return w;
    // Verkleinerungsformen sind im Plural gleich („Brötchen“).
    if (w.endsWith('chen') || w.endsWith('lein')) return w;
    for (final (suffix, replacement) in _pluralRules) {
      if (w.endsWith(suffix) && w.length - suffix.length >= 3) {
        return w.substring(0, w.length - suffix.length) + replacement;
      }
    }
    return w;
  }

  static const _pluralRules = <(String, String)>[
    ('ies', 'y'), // berries → berry
    ('nen', 'ne'), // bohnen → bohne, zitronen → zitrone
    ('ln', 'l'), // zwiebeln → zwiebel, kartoffeln → kartoffel
    ('en', 'e'), // tomaten → tomate, möhren? (möhre)
    ('es', 'e'), // tomatoes → tomatoe (Wörterbuch kennt beide)
    ('s', ''), // joghurts → joghurt, eggs → egg
  ];

  /// Erster Buchstabe groß (Anzeige; deutsche Substantive).
  static String capitalize(String s) {
    final t = s.trim();
    if (t.isEmpty) return t;
    return t[0].toUpperCase() + t.substring(1);
  }

  /// Levenshtein-Distanz mit Abbruch, sobald [max] überschritten ist.
  static int distance(String a, String b, {int max = 3}) {
    if ((a.length - b.length).abs() > max) return max + 1;
    var prev = List<int>.generate(b.length + 1, (i) => i);
    for (var i = 1; i <= a.length; i++) {
      final cur = List<int>.filled(b.length + 1, 0);
      cur[0] = i;
      var rowMin = cur[0];
      for (var j = 1; j <= b.length; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        cur[j] = [
          prev[j] + 1,
          cur[j - 1] + 1,
          prev[j - 1] + cost,
        ].reduce((x, y) => x < y ? x : y);
        if (cur[j] < rowMin) rowMin = cur[j];
      }
      if (rowMin > max) return max + 1;
      prev = cur;
    }
    return prev[b.length];
  }
}
