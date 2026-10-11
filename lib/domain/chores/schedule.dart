/// Wie eine Aufgabe wiederkehrt. Gespeichert wird der Index — nur am Ende
/// erweitern.
enum Recurrence {
  /// „Alle N Tage nach letzter Erledigung“ (Saugen, Bettwäsche …).
  floating,

  /// Feste Wochentage (Bitmaske Mo = Bit 0 … So = Bit 6).
  weekly,

  /// Einmalig, optional mit Termin.
  once,
}

/// Zustand einer Aufgabe zum Zeitpunkt `today`.
class ChoreTiming {
  const ChoreTiming({
    required this.due,
    required this.progress,
    required this.daysUntilDue,
    this.completed = false,
  });

  /// Fälliger Tag (ohne Uhrzeit).
  final DateTime due;

  /// 0 = gerade erledigt, 1 = jetzt dran; > 1 = länger dran.
  final double progress;

  /// Negativ = seit so vielen Tagen dran.
  final int daysUntilDue;

  /// Einmalige Aufgabe ist erledigt.
  final bool completed;

  bool get isDue => !completed && daysUntilDue <= 0;
  bool get isSoon => !completed && daysUntilDue <= 2;
}

abstract final class ChoreSchedule {
  static DateTime dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

  static int daysBetween(DateTime a, DateTime b) =>
      // Mittag statt Mitternacht: Sommerzeitwechsel verschiebt keine Tage.
      DateTime(b.year, b.month, b.day, 12)
          .difference(DateTime(a.year, a.month, a.day, 12))
          .inHours ~/
      24;

  static bool weekdayInMask(int mask, DateTime day) =>
      mask & (1 << (day.weekday - 1)) != 0;

  static int maskCount(int mask) {
    var n = 0;
    for (var i = 0; i < 7; i++) {
      if (mask & (1 << i) != 0) n++;
    }
    return n;
  }

  static ChoreTiming compute({
    required Recurrence recurrence,
    required DateTime createdAt,
    required DateTime today,
    DateTime? lastDoneAt,
    int intervalDays = 7,
    int weekdays = 0,
    DateTime? dueDate,
    DateTime? snoozedUntil,
  }) {
    final day = dateOnly(today);
    DateTime due;
    double progress;
    switch (recurrence) {
      case Recurrence.floating:
        final interval = intervalDays < 1 ? 1 : intervalDays;
        // Ohne bekannte letzte Erledigung: als „halb fällig“ starten, damit
        // nach dem Einrichten nicht alles auf einmal dran ist.
        final base = lastDoneAt != null
            ? dateOnly(lastDoneAt)
            : dateOnly(createdAt).subtract(Duration(days: interval ~/ 2));
        due = DateTime(base.year, base.month, base.day + interval);
        progress = daysBetween(base, day) / interval;
      case Recurrence.weekly:
        final mask = weekdays == 0 ? 1 << (createdAt.weekday - 1) : weekdays;
        final start = lastDoneAt != null
            ? dateOnly(lastDoneAt).add(const Duration(days: 1))
            : dateOnly(createdAt);
        due = start;
        for (var i = 0; i < 7; i++) {
          final candidate = DateTime(start.year, start.month, start.day + i);
          if (weekdayInMask(mask, candidate)) {
            due = candidate;
            break;
          }
        }
        final gap = 7 / maskCount(mask);
        final since = lastDoneAt != null
            ? daysBetween(dateOnly(lastDoneAt), day)
            : gap - daysBetween(day, due);
        progress = since / gap;
      case Recurrence.once:
        if (lastDoneAt != null) {
          return ChoreTiming(
            due: dateOnly(lastDoneAt),
            progress: 0,
            daysUntilDue: 0,
            completed: true,
          );
        }
        due = dateOnly(dueDate ?? createdAt);
        final total = daysBetween(dateOnly(createdAt), due);
        progress = total <= 0
            ? 1
            : daysBetween(dateOnly(createdAt), day) / total;
    }
    if (snoozedUntil != null && dateOnly(snoozedUntil).isAfter(due)) {
      due = dateOnly(snoozedUntil);
      progress = progress.clamp(0, 0.9);
    }
    return ChoreTiming(
      due: due,
      progress: progress < 0 ? 0 : progress,
      daysUntilDue: daysBetween(day, due),
    );
  }

  /// Nächste Person bei „reihum“ (nach [current] in [members]).
  static String? nextInRotation(List<String> members, String? current) {
    if (members.isEmpty) return null;
    final i = current == null ? -1 : members.indexOf(current);
    return members[(i + 1) % members.length];
  }
}

/// Wer ist zuständig? Gespeichert wird der Index — nur am Ende erweitern.
enum Assignment { none, member, rotating }
