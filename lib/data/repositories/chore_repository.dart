import 'package:drift/drift.dart';

import '../../domain/chores/schedule.dart';
import '../../domain/waste/waste.dart';
import '../app_database.dart';
import '../data_context.dart';

/// Aufgabe mit berechnetem Zustand.
class ChoreState {
  const ChoreState(this.chore, this.timing);

  final Chore chore;
  final ChoreTiming timing;
}

/// Zum Rückgängigmachen von „erledigt“.
class CompletionUndo {
  const CompletionUndo(this.before, this.completionId);

  final Chore before;
  final String completionId;
}

class ChoreRepository {
  ChoreRepository(this.ctx);

  final DataContext ctx;
  AppDatabase get db => ctx.db;

  static DateTime? _date(int? ms) =>
      ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);

  static ChoreTiming timingOf(Chore c, DateTime today) => ChoreSchedule.compute(
    recurrence: Recurrence.values[c.recurrence.clamp(
      0,
      Recurrence.values.length - 1,
    )],
    createdAt: DateTime.fromMillisecondsSinceEpoch(c.createdAt),
    today: today,
    lastDoneAt: _date(c.lastDoneAt),
    intervalDays: c.intervalDays,
    weekdays: c.weekdays,
    dueDate: _date(c.dueDate),
    snoozedUntil: _date(c.snoozedUntil),
  );

  Stream<List<Area>> watchAreas() =>
      (db.select(db.areas)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .watch();

  Stream<List<Chore>> watchChores() =>
      (db.select(db.chores)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.name.lower())]))
          .watch();

  Future<List<Chore>> chores() =>
      (db.select(db.chores)..where((t) => t.deleted.equals(false))).get();

  /// Nach Dringlichkeit sortiert (dringendste zuerst), erledigte
  /// Einmal-Aufgaben ausgeblendet.
  static List<ChoreState> ranked(List<Chore> chores, DateTime today) {
    final states = [
      for (final c in chores) ChoreState(c, timingOf(c, today)),
    ].where((s) => !s.timing.completed).toList();
    states.sort((a, b) {
      final d = a.timing.daysUntilDue.compareTo(b.timing.daysUntilDue);
      if (d != 0) return d;
      return b.timing.progress.compareTo(a.timing.progress);
    });
    return states;
  }

  Future<String> addChore({
    required String name,
    required String areaId,
    int effortMinutes = 15,
    Recurrence recurrence = Recurrence.floating,
    int intervalDays = 7,
    int weekdays = 0,
    DateTime? dueDate,
    Assignment assignment = Assignment.none,
    String? assigneeId,
    DateTime? lastDoneAt,
    bool remind = true,
  }) async {
    final id = DataContext.newId();
    final s = ctx.stamp();
    await db
        .into(db.chores)
        .insert(
          ChoresCompanion.insert(
            id: id,
            updatedAt: s.updatedAt,
            seq: s.seq,
            name: name.trim(),
            areaId: areaId,
            effortMinutes: Value(effortMinutes),
            recurrence: Value(recurrence.index),
            intervalDays: Value(intervalDays),
            weekdays: Value(weekdays),
            dueDate: Value(dueDate?.millisecondsSinceEpoch),
            assignment: Value(assignment.index),
            assigneeId: Value(assigneeId),
            lastDoneAt: Value(lastDoneAt?.millisecondsSinceEpoch),
            remind: Value(remind),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
    ctx.notifyChanged();
    return id;
  }

  Future<void> updateChore(String id, ChoresCompanion changes) async {
    final s = ctx.stamp();
    await (db.update(db.chores)..where((t) => t.id.equals(id))).write(
      changes.copyWith(updatedAt: Value(s.updatedAt), seq: Value(s.seq)),
    );
    ctx.notifyChanged();
  }

  Future<void> deleteChore(String id) =>
      updateChore(id, const ChoresCompanion(deleted: Value(true)));

  /// Erledigt — von wem auch immer („ich hab’s gemacht“ zählt immer).
  Future<CompletionUndo> complete(
    Chore chore, {
    required String? memberId,
    DateTime? at,
  }) async {
    final when = (at ?? DateTime.now()).millisecondsSinceEpoch;
    final completionId = DataContext.newId();
    String? nextAssignee = chore.assigneeId;
    if (chore.assignment == Assignment.rotating.index) {
      final active =
          await (db.select(db.members)
                ..where((t) => t.deleted.equals(false) & t.paused.equals(false))
                ..orderBy([
                  (t) => OrderingTerm(expression: t.sortOrder),
                  (t) => OrderingTerm(expression: t.name.lower()),
                ]))
              .get();
      nextAssignee = ChoreSchedule.nextInRotation(
        active.map((m) => m.id).toList(),
        chore.assigneeId ?? memberId,
      );
    }
    await db.transaction(() async {
      final s = ctx.stamp();
      await db
          .into(db.choreCompletions)
          .insert(
            ChoreCompletionsCompanion.insert(
              id: completionId,
              updatedAt: s.updatedAt,
              seq: s.seq,
              choreId: chore.id,
              memberId: Value(memberId),
              doneAt: when,
              effortMinutes: Value(chore.effortMinutes),
            ),
          );
      final s2 = ctx.stamp();
      await (db.update(db.chores)..where((t) => t.id.equals(chore.id))).write(
        ChoresCompanion(
          lastDoneAt: Value(when),
          lastDoneBy: Value(memberId),
          snoozedUntil: const Value(null),
          assigneeId: Value(nextAssignee),
          updatedAt: Value(s2.updatedAt),
          seq: Value(s2.seq),
        ),
      );
    });
    ctx.notifyChanged();
    return CompletionUndo(chore, completionId);
  }

  Future<void> undoComplete(CompletionUndo undo) async {
    await db.transaction(() async {
      final s = ctx.stamp();
      await (db.update(
        db.choreCompletions,
      )..where((t) => t.id.equals(undo.completionId))).write(
        ChoreCompletionsCompanion(
          deleted: const Value(true),
          updatedAt: Value(s.updatedAt),
          seq: Value(s.seq),
        ),
      );
      final b = undo.before;
      final s2 = ctx.stamp();
      await (db.update(db.chores)..where((t) => t.id.equals(b.id))).write(
        ChoresCompanion(
          lastDoneAt: Value(b.lastDoneAt),
          lastDoneBy: Value(b.lastDoneBy),
          snoozedUntil: Value(b.snoozedUntil),
          assigneeId: Value(b.assigneeId),
          updatedAt: Value(s2.updatedAt),
          seq: Value(s2.seq),
        ),
      );
    });
    ctx.notifyChanged();
  }

  /// „Heute nicht“ — ohne schlechtes Gewissen um [days] Tage verschieben.
  Future<void> snooze(Chore chore, {int days = 1}) {
    final now = DateTime.now();
    final until = DateTime(now.year, now.month, now.day + days);
    return updateChore(
      chore.id,
      ChoresCompanion(snoozedUntil: Value(until.millisecondsSinceEpoch)),
    );
  }

  Stream<List<ChoreCompletion>> watchCompletionsSince(DateTime since) =>
      (db.select(db.choreCompletions)
            ..where(
              (t) =>
                  t.deleted.equals(false) &
                  t.doneAt.isBiggerOrEqualValue(since.millisecondsSinceEpoch),
            )
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.doneAt, mode: OrderingMode.desc),
            ]))
          .watch();

  Future<List<ChoreCompletion>> completionsOf(String choreId) =>
      (db.select(db.choreCompletions)
            ..where((t) => t.deleted.equals(false) & t.choreId.equals(choreId))
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.doneAt, mode: OrderingMode.desc),
            ])
            ..limit(20))
          .get();

  // ---------------------------------------------------------------------
  // Müllabfuhr
  // ---------------------------------------------------------------------

  static String dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static DateTime parseDay(String key) {
    final p = key.split('-').map(int.parse).toList();
    return DateTime(p[0], p[1], p[2]);
  }

  Stream<List<WastePickup>> watchPickupsFrom(DateTime from) =>
      (db.select(db.wastePickups)
            ..where(
              (t) =>
                  t.deleted.equals(false) &
                  t.day.isBiggerOrEqualValue(dayKey(from)),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.day)]))
          .watch();

  Future<List<WastePickup>> pickupsBetween(DateTime from, DateTime to) =>
      (db.select(db.wastePickups)
            ..where(
              (t) =>
                  t.deleted.equals(false) &
                  t.day.isBetweenValues(dayKey(from), dayKey(to)),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.day)]))
          .get();

  /// Legt Termine an; vorhandene gleiche Termine (Tonne + Tag) werden
  /// nicht doppelt angelegt. Liefert die Zahl neuer Termine.
  Future<int> addPickups(
    WasteType type,
    Iterable<DateTime> days, {
    String? assigneeId,
  }) async {
    var added = 0;
    await db.transaction(() async {
      for (final d in days) {
        final key = dayKey(d);
        // Feste ID je Tonne und Tag: zwei Geräte, die denselben Kalender
        // importieren, erzeugen keine Doppelten.
        final id = 'waste-${type.index}-$key';
        final existing = await (db.select(
          db.wastePickups,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (existing != null && !existing.deleted) continue;
        final s = ctx.stamp();
        await db
            .into(db.wastePickups)
            .insertOnConflictUpdate(
              WastePickupsCompanion.insert(
                id: id,
                updatedAt: s.updatedAt,
                seq: s.seq,
                type: type.index,
                day: key,
                assigneeId: Value(assigneeId),
              ),
            );
        added++;
      }
    });
    if (added > 0) ctx.notifyChanged();
    return added;
  }

  Future<void> updatePickup(String id, WastePickupsCompanion changes) async {
    final s = ctx.stamp();
    await (db.update(db.wastePickups)..where((t) => t.id.equals(id))).write(
      changes.copyWith(updatedAt: Value(s.updatedAt), seq: Value(s.seq)),
    );
    ctx.notifyChanged();
  }

  /// Alle künftigen Termine einer Tonne löschen.
  Future<void> deleteFutureOfType(WasteType type, DateTime from) async {
    final rows = await (db.select(db.wastePickups)..where(
          (t) =>
              t.deleted.equals(false) &
              t.type.equals(type.index) &
              t.day.isBiggerOrEqualValue(dayKey(from)),
        ))
        .get();
    await db.transaction(() async {
      for (final r in rows) {
        final s = ctx.stamp();
        await (db.update(db.wastePickups)..where((t) => t.id.equals(r.id)))
            .write(
              WastePickupsCompanion(
                deleted: const Value(true),
                updatedAt: Value(s.updatedAt),
                seq: Value(s.seq),
              ),
            );
      }
    });
    ctx.notifyChanged();
  }

  /// Zuständige Person für alle künftigen Termine einer Tonne.
  Future<void> assignType(WasteType type, String? memberId, DateTime from) async {
    final rows = await (db.select(db.wastePickups)..where(
          (t) =>
              t.deleted.equals(false) &
              t.type.equals(type.index) &
              t.day.isBiggerOrEqualValue(dayKey(from)),
        ))
        .get();
    await db.transaction(() async {
      for (final r in rows) {
        final s = ctx.stamp();
        await (db.update(db.wastePickups)..where((t) => t.id.equals(r.id)))
            .write(
              WastePickupsCompanion(
                assigneeId: Value(memberId),
                updatedAt: Value(s.updatedAt),
                seq: Value(s.seq),
              ),
            );
      }
    });
    ctx.notifyChanged();
  }
}
