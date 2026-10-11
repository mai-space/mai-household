import 'package:drift/drift.dart';

import '../domain/chores/templates.dart';
import '../domain/shopping/departments.dart';
import 'app_database.dart';
import 'data_context.dart';

/// Farben für Personen (Reihenfolge der Vergabe).
const memberColors = <int>[
  0xFF2A9D8F,
  0xFFE76F51,
  0xFF6D597A,
  0xFFF4A261,
  0xFF457B9D,
  0xFFB5838D,
  0xFF588157,
  0xFFBC6C25,
];

/// Legt eingebaute Abteilungen, Läden und Bereiche an.
///
/// Zeitstempel 1 (uralt): Jede echte Änderung auf irgendeinem Gerät gewinnt
/// beim Zusammenführen gegen diese Vorbelegung. Feste IDs verhindern
/// Doppelte, wenn zwei Geräte unabhängig eingerichtet wurden.
Future<void> seedBuiltins(DataContext ctx, {Set<BuiltinStore>? stores}) async {
  final db = ctx.db;
  const seedTime = 1;
  await db.transaction(() async {
    for (final d in BuiltinDepartment.values) {
      await db
          .into(db.departments)
          .insert(
            DepartmentsCompanion.insert(
              id: d.id,
              updatedAt: seedTime,
              seq: ctx.nextSeq(),
              sortOrder: Value(d.index),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
    final chosen = stores ?? BuiltinStore.values.toSet();
    for (final s in BuiltinStore.values) {
      await db
          .into(db.stores)
          .insert(
            StoresCompanion.insert(
              id: s.id,
              updatedAt: seedTime,
              seq: ctx.nextSeq(),
              name: s.label,
              color: s.color,
              sortOrder: Value(s.index),
              deleted: Value(!chosen.contains(s)),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      for (final (i, d) in s.template.indexed) {
        await db
            .into(db.storeDepartmentOrders)
            .insert(
              StoreDepartmentOrdersCompanion.insert(
                id: '${s.id}|${d.id}',
                updatedAt: seedTime,
                seq: ctx.nextSeq(),
                storeId: s.id,
                departmentId: d.id,
                position: i.toDouble(),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
    }
    for (final a in BuiltinArea.values) {
      await db
          .into(db.areas)
          .insert(
            AreasCompanion.insert(
              id: a.id,
              updatedAt: seedTime,
              seq: ctx.nextSeq(),
              sortOrder: Value(a.index),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  });
}
