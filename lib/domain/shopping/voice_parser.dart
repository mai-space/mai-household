import '../text/normalize.dart';
import '../text/quantity.dart';

/// Ein erkannter Einkaufsartikel aus Sprache oder Freitext.
class ParsedItem {
  const ParsedItem({
    required this.name,
    this.amount,
    this.unit,
    this.storeId,
  });

  final String name;
  final double? amount;
  final String? unit;

  /// Genannter Laden („bei Rewe“) oder `null` = egal.
  final String? storeId;

  @override
  String toString() => 'ParsedItem($name, $amount, $unit, $storeId)';
}

/// Laden, wie er im Satz genannt werden kann.
class StoreAlias {
  const StoreAlias(this.storeId, this.names);

  final String storeId;

  /// Kleingeschriebene Namen, z. B. `['rewe']`, `['hit', 'hit markt']`.
  final List<String> names;
}

/// Zerlegt „Zwei Liter Milch, Eier und drei Paprika, und Spülmittel bei
/// Rewe“ in einzelne Artikel.
///
/// Regeln:
/// * Trennung an Komma, Semikolon, Zeilenumbruch, „und“, „sowie“,
///   „außerdem“, „plus“, „and“.
/// * Füllwörter („wir brauchen noch“, „kauf mal“, „auf die Liste“) fallen weg.
/// * „bei X“ am Satzanfang (oder „alles bei X“) gilt für alle Artikel,
///   sonst nur für den Artikel, an dem es steht.
class VoiceParser {
  VoiceParser(this.stores);

  final List<StoreAlias> stores;

  static final _separators = RegExp(
    r'\s*(?:[,;\n]|\s(?:und|sowie|außerdem|ausserdem|plus|and|dazu|noch dazu)\s)\s*',
    caseSensitive: false,
  );

  static final _fillerStart = RegExp(
    r'^(?:(?:ok(?:ay)?|hallo|bitte|also|äh|ähm|und|dann|noch|auch|mal|'
    r'wir brauchen|ich brauche|brauchen|brauche|wir müssen|ich muss|'
    r'kaufen|kauf|kaufe|besorgen|besorg|besorge|hol|hole|holen|'
    r'schreib|schreibe|setz|setze|füge|füg|add|we need|i need|buy|get|'
    r'please|some|etwas|ein bisschen|ein paar)\s+)+',
    caseSensitive: false,
  );

  static final _fillerEnd = RegExp(
    r'(?:\s+(?:auf die (?:einkaufs)?liste|zur (?:einkaufs)?liste|'
    r'hinzu|dazu|kaufen|besorgen|holen|mitbringen|bitte|noch|'
    r'to the (?:shopping )?list|please))+$',
    caseSensitive: false,
  );

  List<ParsedItem> parse(String utterance) {
    var text = utterance.trim();
    if (text.isEmpty) return const [];

    // Laden für alle: „Bei Rewe: …“ oder „… alles bei Aldi“.
    String? globalStore;
    final leading = _matchStore(text, atStart: true);
    if (leading != null) {
      globalStore = leading.$1;
      text = leading.$2;
    }
    final allAtEnd = RegExp(
      r'[,\s]+(?:alles|everything|all)\s+(?:bei|von|im|vom|at|from)\s+(.+)$',
      caseSensitive: false,
    ).firstMatch(text);
    if (allAtEnd != null) {
      final id = _storeByName(allAtEnd.group(1)!);
      if (id != null) {
        globalStore = id;
        text = text.substring(0, allAtEnd.start);
      }
    }

    final items = <ParsedItem>[];
    for (var segment in text.split(_separators)) {
      segment = segment.trim();
      if (segment.isEmpty) continue;
      String? store = globalStore;
      final trailing = _matchStore(segment, atStart: false);
      if (trailing != null) {
        store = trailing.$1;
        segment = trailing.$2;
      }
      segment = segment
          .replaceFirst(_fillerStart, '')
          .replaceFirst(_fillerEnd, '')
          .trim();
      if (segment.isEmpty) continue;
      final q = Quantity.parse(segment);
      final name = q.name
          .replaceFirst(_fillerStart, '')
          .replaceFirst(_fillerEnd, '')
          .trim();
      if (name.isEmpty || _isNoise(name)) continue;
      items.add(
        ParsedItem(
          name: TextNorm.capitalize(name),
          amount: q.amount,
          unit: q.unit,
          storeId: store,
        ),
      );
    }
    return items;
  }

  static bool _isNoise(String s) {
    final n = TextNorm.basic(s);
    return const {
      'und',
      'noch',
      'bitte',
      'danke',
      'das wars',
      'das war s',
      'fertig',
      'ende',
      'alles',
    }.contains(n);
  }

  /// (Laden-ID, Rest ohne Ladenangabe).
  (String, String)? _matchStore(String text, {required bool atStart}) {
    final lower = text.toLowerCase();
    for (final store in stores) {
      for (final name in store.names) {
        final escaped = RegExp.escape(name);
        final pattern = atStart
            ? RegExp(
                '^(?:(?:alles|einkauf|einkaufen)\\s+)?(?:bei|von|im|vom|für|at|from|for)\\s+(?:dem\\s+|der\\s+)?$escaped\\b\\s*:?\\s*',
              )
            : RegExp(
                '\\s+(?:bei|von|im|vom|aus dem|vom|at|from)\\s+(?:dem\\s+|der\\s+)?$escaped\\b\\.?\$',
              );
        final match = pattern.firstMatch(lower);
        if (match == null) continue;
        final rest = atStart
            ? text.substring(match.end)
            : text.substring(0, match.start);
        return (store.storeId, rest.trim());
      }
    }
    return null;
  }

  String? _storeByName(String spoken) {
    final s = spoken.toLowerCase().replaceAll(RegExp(r'[.!]$'), '').trim();
    for (final store in stores) {
      for (final name in store.names) {
        if (s == name || s == 'dem $name' || s == 'der $name') {
          return store.storeId;
        }
      }
    }
    return null;
  }
}
