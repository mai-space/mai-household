import 'schedule.dart';

/// Eingebaute Bereiche (`area-<key>`), auf allen Geräten gleiche ID.
enum BuiltinArea {
  general,
  kitchen,
  bath,
  living,
  bedroom,
  laundry,
  outside;

  String get id => 'area-$name';

  static BuiltinArea? fromId(String id) {
    for (final a in values) {
      if (a.id == id) return a;
    }
    return null;
  }
}

/// Aufwand in Minuten (S/M/L) — für die Ausgleichs-Ansicht.
enum Effort {
  small(5),
  medium(15),
  large(45);

  const Effort(this.minutes);

  final int minutes;
}

/// Vorlage zum Antippen beim Einrichten. `key` → Text aus l10n
/// (`choreTemplate_<key>`); angelegt wird der Text in der aktuellen Sprache.
class ChoreTemplate {
  const ChoreTemplate(
    this.key,
    this.area,
    this.intervalDays,
    this.effort, {
    this.recurrence = Recurrence.floating,
    this.preselected = false,
  });

  final String key;
  final BuiltinArea area;
  final int intervalDays;
  final Effort effort;
  final Recurrence recurrence;
  final bool preselected;

  static const all = <ChoreTemplate>[
    ChoreTemplate('vacuum', BuiltinArea.general, 7, Effort.medium,
        preselected: true),
    ChoreTemplate('mop', BuiltinArea.general, 14, Effort.medium,
        preselected: true),
    ChoreTemplate('dust', BuiltinArea.general, 14, Effort.small),
    ChoreTemplate('trash', BuiltinArea.kitchen, 2, Effort.small,
        preselected: true),
    ChoreTemplate('dishwasher', BuiltinArea.kitchen, 1, Effort.small),
    ChoreTemplate('fridge', BuiltinArea.kitchen, 30, Effort.medium),
    ChoreTemplate('stove', BuiltinArea.kitchen, 14, Effort.medium),
    ChoreTemplate('bathroom', BuiltinArea.bath, 7, Effort.large,
        preselected: true),
    ChoreTemplate('towels', BuiltinArea.bath, 7, Effort.small),
    ChoreTemplate('drain', BuiltinArea.bath, 30, Effort.small),
    ChoreTemplate('bedding', BuiltinArea.bedroom, 14, Effort.medium,
        preselected: true),
    ChoreTemplate('laundry', BuiltinArea.laundry, 3, Effort.medium),
    ChoreTemplate('plants', BuiltinArea.living, 3, Effort.small),
    ChoreTemplate('glass', BuiltinArea.outside, 14, Effort.small),
    ChoreTemplate('windows', BuiltinArea.living, 60, Effort.large),
  ];
}
