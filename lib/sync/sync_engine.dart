import 'dart:convert';

import 'package:drift/drift.dart';

import '../data/app_database.dart';
import '../data/data_context.dart';

/// Zeilen je Tabelle, wie sie zwischen Geräten wandern.
typedef RowBatch = Map<String, List<Map<String, Object?>>>;

/// Zusammenführen geteilter Daten — unabhängig vom Transportweg.
///
/// Jede Zeile trägt `updatedAt` (hybride Uhr). Beim Import gewinnt pro Zeile
/// der spätere Stand; bei Gleichstand entscheidet ein fester Vergleich,
/// damit alle Geräte zum selben Ergebnis kommen. Übernommene Zeilen
/// bekommen eine neue lokale `seq`, damit sie an weitere Geräte
/// weitergereicht werden. Unbekannte Spalten (neuere App-Version auf dem
/// anderen Gerät) werden ignoriert, fehlende bekommen ihre Standardwerte.
class SyncEngine {
  SyncEngine(this.ctx);

  final DataContext ctx;
  AppDatabase get db => ctx.db;

  late final Map<String, List<String>> _columns = {
    for (final t in db.allTables)
      if (AppDatabase.syncTableNames.contains(t.actualTableName))
        t.actualTableName: [for (final c in t.$columns) c.name],
  };

  /// Alle eigenen Zeilen mit `seq > since`.
  Future<RowBatch> exportSince(int since) async {
    final out = <String, List<Map<String, Object?>>>{};
    for (final table in AppDatabase.syncTableNames) {
      final rows = await db
          .customSelect(
            'SELECT * FROM $table WHERE seq > ? ORDER BY seq',
            variables: [Variable.withInt(since)],
          )
          .get();
      if (rows.isEmpty) continue;
      out[table] = [
        for (final r in rows)
          {
            for (final e in r.data.entries)
              if (e.key != 'seq') e.key: e.value,
          },
      ];
    }
    return out;
  }

  /// Übernimmt fremde Zeilen. Liefert die Zahl geänderter Zeilen.
  Future<int> import(RowBatch batch) async {
    var changed = 0;
    final touched = <TableInfo>{};
    await db.transaction(() async {
      for (final table in AppDatabase.syncTableNames) {
        final rows = batch[table];
        final columns = _columns[table];
        if (rows == null || columns == null) continue;
        for (final incoming in rows) {
          final id = incoming['id'];
          final updatedAt = incoming['updated_at'];
          if (id is! String || updatedAt is! int) continue;
          ctx.clock.observe(updatedAt);
          final local = await db
              .customSelect(
                'SELECT * FROM $table WHERE id = ?',
                variables: [Variable.withString(id)],
              )
              .getSingleOrNull();
          if (local != null && !_wins(incoming, local.data, columns)) continue;

          final names = <String>[];
          final values = <Variable>[];
          for (final c in columns) {
            if (c == 'seq') continue;
            if (!incoming.containsKey(c)) continue;
            names.add(c);
            values.add(_variable(incoming[c]));
          }
          names.add('seq');
          values.add(Variable.withInt(ctx.nextSeq()));
          await db.customStatement(
            'INSERT OR REPLACE INTO $table (${names.join(', ')}) '
            'VALUES (${List.filled(names.length, '?').join(', ')})',
            [for (final v in values) v.value],
          );
          changed++;
          touched.add(db.allTables.firstWhere((t) => t.actualTableName == table));
        }
      }
    });
    if (touched.isNotEmpty) {
      db.notifyUpdates({
        for (final t in touched) TableUpdate.onTable(t, kind: UpdateKind.update),
      });
    }
    return changed;
  }

  /// Gewinnt die eingehende Zeile gegen die lokale?
  static bool _wins(
    Map<String, Object?> incoming,
    Map<String, Object?> local,
    List<String> columns,
  ) {
    final a = incoming['updated_at'] as int;
    final b = (local['updated_at'] as int?) ?? 0;
    if (a != b) return a > b;
    // Gleichstand: deterministisch über den Inhalt entscheiden.
    String canon(Map<String, Object?> row) => jsonEncode([
      for (final c in columns)
        if (c != 'seq') _normalize(row[c]),
    ]);
    return canon(incoming).compareTo(canon(local)) > 0;
  }

  static Object? _normalize(Object? v) => v is bool ? (v ? 1 : 0) : v;

  static Variable _variable(Object? v) => switch (v) {
    null => const Variable(null),
    bool b => Variable.withInt(b ? 1 : 0),
    int i => Variable.withInt(i),
    double d => Variable.withReal(d),
    String s => Variable.withString(s),
    _ => Variable.withString(v.toString()),
  };

  /// Alle geteilten Daten dieses Geräts verwerfen (vor dem Beitritt zu
  /// einem anderen Haushalt, wenn die eigenen Einträge nicht mit sollen).
  Future<void> wipeShared() async {
    await db.transaction(() async {
      for (final table in AppDatabase.syncTableNames) {
        await db.customStatement('DELETE FROM $table');
      }
      await db.customStatement('DELETE FROM peers');
    });
    db.notifyUpdates({
      for (final t in db.allTables) TableUpdate.onTable(t, kind: UpdateKind.delete),
    });
  }
}
