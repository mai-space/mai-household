import '../text/normalize.dart';

/// Tonnen/Abfallarten. Gespeichert wird der Index — nur am Ende erweitern.
enum WasteType {
  residual(0xFF616161),
  organic(0xFF795548),
  paper(0xFF1E63C6),
  packaging(0xFFF2C200),
  glass(0xFF2E7D32),
  other(0xFF8E24AA);

  const WasteType(this.color);

  final int color;

  /// Ordnet den Text eines Abfallkalender-Termins einer Tonne zu.
  static WasteType? fromText(String text) {
    final t = TextNorm.basic(text);
    bool has(List<String> words) => words.any(t.contains);
    if (has(['gelb', 'wertstoff', 'verpackung', 'leichtverp', 'lvp'])) {
      return WasteType.packaging;
    }
    if (has(['bio', 'grün', 'gruen', 'kompost', 'organic'])) {
      return WasteType.organic;
    }
    if (has(['papier', 'pappe', 'blau', 'paper', 'karton'])) {
      return WasteType.paper;
    }
    if (has(['glas', 'glass'])) return WasteType.glass;
    if (has(['rest', 'grau', 'schwarz', 'hausmüll', 'hausmuell', 'residual'])) {
      return WasteType.residual;
    }
    if (has(['müll', 'muell', 'abfall', 'tonne', 'sperr', 'schadstoff'])) {
      return WasteType.other;
    }
    return null;
  }
}

/// Ein Termin aus einer `.ics`-Datei des Abfallkalenders.
class WasteEvent {
  const WasteEvent(this.type, this.date, this.summary);

  final WasteType type;
  final DateTime date;
  final String summary;
}

abstract final class WasteIcs {
  /// Liest VEVENTs (DTSTART + SUMMARY). Unbekannte Termine werden
  /// übersprungen, damit fremde Kalenderdateien nichts kaputt machen.
  static List<WasteEvent> parse(String ics) {
    // Gefaltete Zeilen (RFC 5545: Fortsetzung beginnt mit Leerzeichen).
    final unfolded = ics.replaceAll(RegExp(r'\r?\n[ \t]'), '');
    final events = <WasteEvent>[];
    DateTime? start;
    String? summary;
    var inEvent = false;
    for (final raw in unfolded.split(RegExp(r'\r?\n'))) {
      final line = raw.trimRight();
      if (line == 'BEGIN:VEVENT') {
        inEvent = true;
        start = null;
        summary = null;
      } else if (line == 'END:VEVENT') {
        if (inEvent && start != null && summary != null) {
          final type = WasteType.fromText(summary);
          if (type != null) events.add(WasteEvent(type, start, summary));
        }
        inEvent = false;
      } else if (inEvent) {
        final colon = line.indexOf(':');
        if (colon < 0) continue;
        final name = line.substring(0, colon).split(';').first.toUpperCase();
        final value = line.substring(colon + 1);
        if (name == 'DTSTART') {
          start = _date(value);
        } else if (name == 'SUMMARY') {
          summary = value
              .replaceAll(r'\,', ',')
              .replaceAll(r'\;', ';')
              .replaceAll(r'\n', ' ');
        }
      }
    }
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  static DateTime? _date(String v) {
    final m = RegExp(r'^(\d{4})(\d{2})(\d{2})').firstMatch(v.trim());
    if (m == null) return null;
    return DateTime(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      int.parse(m.group(3)!),
    );
  }

  /// Termine im Abstand von [everyDays] ab [first] bis [until].
  static List<DateTime> repeat(DateTime first, int everyDays, DateTime until) {
    final out = <DateTime>[];
    var d = DateTime(first.year, first.month, first.day);
    while (!d.isAfter(until)) {
      out.add(d);
      if (everyDays <= 0) break;
      d = DateTime(d.year, d.month, d.day + everyDays);
    }
    return out;
  }
}
