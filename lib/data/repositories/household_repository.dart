import 'package:drift/drift.dart';

import '../app_database.dart';
import '../data_context.dart';
import '../seed.dart';

/// Personen im Haushalt (mit oder ohne eigenes Gerät).
class HouseholdRepository {
  HouseholdRepository(this.ctx);

  final DataContext ctx;
  AppDatabase get db => ctx.db;

  Stream<List<Member>> watchMembers() =>
      (db.select(db.members)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([
              (t) => OrderingTerm(expression: t.sortOrder),
              (t) => OrderingTerm(expression: t.name.lower()),
            ]))
          .watch();

  Future<List<Member>> members() =>
      (db.select(db.members)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([
              (t) => OrderingTerm(expression: t.sortOrder),
              (t) => OrderingTerm(expression: t.name.lower()),
            ]))
          .get();

  Stream<Member?> watchMe() => (db.select(
    db.members,
  )..where((t) => t.id.equals(ctx.memberId))).watchSingleOrNull();

  /// Legt die Person dieses Geräts an oder benennt sie um.
  Future<void> setMyName(String name) async {
    final existing = await (db.select(
      db.members,
    )..where((t) => t.id.equals(ctx.memberId))).getSingleOrNull();
    if (existing == null) {
      final count = (await members()).length;
      final s = ctx.stamp();
      await db
          .into(db.members)
          .insert(
            MembersCompanion.insert(
              id: ctx.memberId,
              updatedAt: s.updatedAt,
              seq: s.seq,
              name: name.trim(),
              color: memberColors[count % memberColors.length],
              sortOrder: Value(count),
            ),
          );
      ctx.notifyChanged();
    } else {
      await update(ctx.memberId, name: name);
    }
  }

  Future<String> add(String name) async {
    final id = DataContext.newId();
    final count = (await members()).length;
    final s = ctx.stamp();
    await db
        .into(db.members)
        .insert(
          MembersCompanion.insert(
            id: id,
            updatedAt: s.updatedAt,
            seq: s.seq,
            name: name.trim(),
            color: memberColors[count % memberColors.length],
            sortOrder: Value(count),
          ),
        );
    ctx.notifyChanged();
    return id;
  }

  Future<void> update(
    String id, {
    String? name,
    int? color,
    bool? paused,
    bool? deleted,
  }) async {
    final s = ctx.stamp();
    await (db.update(db.members)..where((t) => t.id.equals(id))).write(
      MembersCompanion(
        name: name == null ? const Value.absent() : Value(name.trim()),
        color: color == null ? const Value.absent() : Value(color),
        paused: paused == null ? const Value.absent() : Value(paused),
        deleted: deleted == null ? const Value.absent() : Value(deleted),
        updatedAt: Value(s.updatedAt),
        seq: Value(s.seq),
      ),
    );
    ctx.notifyChanged();
  }
}
