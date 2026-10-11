import '../text/quantity.dart';

/// Ergebnis der Aufteilung eines frei eingefügten Rezepttexts.
class SplitRecipe {
  const SplitRecipe({
    this.title,
    this.servings,
    required this.ingredients,
    required this.steps,
  });

  final String? title;
  final int? servings;
  final List<String> ingredients;
  final List<String> steps;
}

/// Teilt einen eingefügten Rezepttext (Nachricht, abgetippter Zettel) in
/// Zutaten und Schritte auf.
///
/// Erkennt Überschriften („Zutaten“, „Zubereitung“, „Ingredients“, …).
/// Ohne Überschriften gilt: kurze Zeilen mit Menge vorne sind Zutaten,
/// der Rest sind Schritte.
abstract final class RecipeImport {
  static final _ingredientHeading = RegExp(
    r'^\s*(zutaten|ingredients|einkaufsliste|für\s+\d+\s+(personen|portionen))\b.*:?\s*$',
    caseSensitive: false,
  );
  static final _stepHeading = RegExp(
    r'^\s*(zubereitung|anleitung|so geht.?s|method|instructions|directions|preparation)\b.*:?\s*$',
    caseSensitive: false,
  );
  static final _servings = RegExp(
    r'(\d+)\s*(personen|portionen|servings|people|stück)',
    caseSensitive: false,
  );
  static final _bullet = RegExp(r'^\s*([-*•·▪︎]|\d+[.)])\s+');

  static SplitRecipe fromPlainText(String text) {
    final lines = text
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trimRight())
        .toList();
    String? title;
    int? servings;
    final ingredients = <String>[];
    final stepLines = <String>[];
    var mode = 0; // 0 = unbekannt, 1 = Zutaten, 2 = Schritte
    var sawHeading = false;

    for (final raw in lines) {
      final line = raw.trim();
      final s = _servings.firstMatch(line);
      if (s != null && servings == null) servings = int.tryParse(s.group(1)!);
      if (_ingredientHeading.hasMatch(line)) {
        mode = 1;
        sawHeading = true;
        continue;
      }
      if (_stepHeading.hasMatch(line)) {
        mode = 2;
        sawHeading = true;
        continue;
      }
      if (line.isEmpty) {
        if (mode == 2) stepLines.add('');
        continue;
      }
      if (title == null && mode == 0 && ingredients.isEmpty) {
        // Erste Zeile ohne Menge ist der Titel.
        if (Quantity.parse(line).amount == null && line.length < 80) {
          title = line;
          continue;
        }
      }
      final cleaned = line.replaceFirst(_bullet, '');
      final effective = mode != 0 || sawHeading
          ? mode
          : (_looksLikeIngredient(cleaned) ? 1 : 2);
      if (effective == 1) {
        ingredients.add(cleaned);
      } else {
        stepLines.add(line.replaceFirst(RegExp(r'^\s*\d+[.)]\s+'), ''));
        // Ohne Überschriften: nach dem ersten Schritt ist alles Zubereitung.
        if (!sawHeading) mode = 2;
      }
    }

    // Schritte: Absätze oder einzelne Zeilen.
    final steps = <String>[];
    final buffer = StringBuffer();
    final hasBlankLines = stepLines.contains('');
    for (final l in stepLines) {
      if (l.isEmpty) {
        if (buffer.isNotEmpty) steps.add(buffer.toString().trim());
        buffer.clear();
      } else if (hasBlankLines) {
        buffer.write(buffer.isEmpty ? l : ' $l');
      } else {
        steps.add(l.trim());
      }
    }
    if (buffer.isNotEmpty) steps.add(buffer.toString().trim());

    return SplitRecipe(
      title: title,
      servings: servings,
      ingredients: ingredients,
      steps: steps,
    );
  }

  static bool _looksLikeIngredient(String line) {
    if (line.length > 60) return false;
    final q = Quantity.parse(line);
    return q.amount != null || q.unit != null || !line.contains(' ');
  }
}
