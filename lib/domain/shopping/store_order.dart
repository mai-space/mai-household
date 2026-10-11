/// Lernt die Gang-Reihenfolge eines Ladens aus der Abhak-Reihenfolge.
///
/// Die beim Einkauf besuchten Abteilungen bekommen die Plätze, die sie
/// bisher zusammen belegt haben, neu verteilt — in der beobachteten
/// Reihenfolge. Das Ergebnis wird mit dem alten Stand gemischt, damit ein
/// einzelner Umweg die Liste nicht umwirft; nach zwei, drei Einkäufen
/// entspricht sie dem eigenen Laufweg.
abstract final class StoreOrderLearner {
  static const weight = 0.6;

  static Map<String, double> learn(
    Map<String, double> current,
    List<String> visited,
  ) {
    final seen = <String>[];
    for (final d in visited) {
      if (!seen.contains(d) && current.containsKey(d)) seen.add(d);
    }
    if (seen.length < 2) return Map.of(current);
    final slots = seen.map((d) => current[d]!).toList()..sort();
    final result = Map<String, double>.of(current);
    for (var i = 0; i < seen.length; i++) {
      final old = current[seen[i]]!;
      result[seen[i]] = old * (1 - weight) + slots[i] * weight;
    }
    return result;
  }
}

/// Status eines Einkaufsartikels. Gespeichert wird der Index.
enum ItemStatus { open, done, notFound }
