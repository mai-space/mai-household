import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../data/data_context.dart';
import '../data/repositories/chore_repository.dart';
import '../domain/shopping/store_order.dart';
import '../domain/waste/waste.dart';
import '../features/shopping/item_sheet.dart' show itemSubtitle;
import '../l10n/l10n.dart';
import '../services/reminders.dart' show WasteNames;
import '../widgets/labels.dart';

/// Stand für die Homescreen-Widgets — ein JSON-Dokument, das die native
/// Seite ohne Flutter anzeigt.
///
/// Datumsabhängiges (was ist „heute“?) entscheidet die native Seite anhand
/// von `due`/`day` selbst, damit die Widgets auch nach Mitternacht stimmen,
/// ohne dass die App läuft. Darum enthält der Stand ein paar Tage im Voraus.
///
/// Format nur erweitern (`v` bleibt 1); die native Seite ignoriert
/// unbekannte Felder.
abstract final class WidgetSnapshot {
  static const version = 1;

  /// Tage im Voraus (Aufgaben, Essensplan, Müll).
  static const daysAhead = 7;

  static const maxShopping = 100;
  static const maxChores = 50;

  static WasteType _waste(int i) =>
      WasteType.values[i.clamp(0, WasteType.values.length - 1)];

  static Future<Map<String, Object?>> build(
    DataContext ctx,
    AppLocalizations l10n, {
    DateTime? now,
  }) async {
    final t = now ?? DateTime.now();
    final today = DateTime(t.year, t.month, t.day);
    final until = DateTime(today.year, today.month, today.day + daysAhead);
    final db = ctx.db;

    final members = {
      for (final m in await (db.select(
        db.members,
      )..where((m) => m.deleted.equals(false))).get())
        m.id: m,
    };
    final areas = {
      for (final a in await (db.select(
        db.areas,
      )..where((a) => a.deleted.equals(false))).get())
        a.id: a,
    };
    final departments = await (db.select(
      db.departments,
    )..where((d) => d.deleted.equals(false))).get();
    final depById = {for (final d in departments) d.id: d};

    // Aufgaben: fällig bis in [daysAhead] Tagen; meine zuerst, dann für
    // alle, dann andere — wie auf „Heute“.
    final chores = await (db.select(
      db.chores,
    )..where((c) => c.deleted.equals(false))).get();
    final me = ctx.memberId;
    int rank(ChoreState s) => s.chore.assigneeId == me
        ? 0
        : (s.chore.assigneeId == null ? 1 : 2);
    final states = ChoreRepository.ranked(chores, today)
        .where((s) => s.timing.daysUntilDue <= daysAhead)
        .toList();
    // Stabil: innerhalb gleicher Zuständigkeit bleibt die Dringlichkeit.
    final order = {for (var i = 0; i < states.length; i++) states[i]: i};
    states.sort((a, b) {
      final r = rank(a).compareTo(rank(b));
      return r != 0 ? r : order[a]!.compareTo(order[b]!);
    });

    // Einkauf: offene Artikel in Standard-Abteilungsreihenfolge.
    final open = await (db.select(db.shoppingItems)..where(
          (i) =>
              i.deleted.equals(false) &
              i.status.isNotValue(ItemStatus.done.index),
        ))
        .get();
    int depPos(String id) => depById[id]?.sortOrder ?? 999;
    open.sort((a, b) {
      final d = depPos(a.departmentId).compareTo(depPos(b.departmentId));
      return d != 0 ? d : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final meals = await (db.select(db.mealPlanEntries)
          ..where(
            (m) =>
                m.deleted.equals(false) &
                m.day.isBetweenValues(
                  ChoreRepository.dayKey(today),
                  ChoreRepository.dayKey(until),
                ),
          )
          ..orderBy([(m) => OrderingTerm(expression: m.day)]))
        .get();

    final pickups = await (db.select(db.wastePickups)
          ..where(
            (p) =>
                p.deleted.equals(false) &
                p.day.isBetweenValues(
                  ChoreRepository.dayKey(today),
                  ChoreRepository.dayKey(until),
                ),
          )
          ..orderBy([(p) => OrderingTerm(expression: p.day)]))
        .get();

    // Wochentage Mo … So in der App-Sprache (für den Essensplan).
    final weekday = DateFormat.E(l10n.localeName);
    final monday = today.subtract(Duration(days: today.weekday - 1));

    return {
      'v': version,
      'generatedAt': t.millisecondsSinceEpoch,
      'labels': {
        'chores': l10n.todayChores,
        'choresEmpty': l10n.todayNothingDue,
        'overdue': l10n.widgetOverdue,
        'shopping': l10n.tabShopping,
        'shoppingEmpty': l10n.todayShoppingEmpty,
        'notFound': l10n.storeModeNotFound,
        'meals': l10n.widgetMealsTitle,
        'mealsEmpty': l10n.widgetMealsEmpty,
        'today': l10n.tabToday,
        'tomorrow': l10n.widgetTomorrow,
        'wasteToday': l10n.wasteToday,
        'wasteTomorrow': l10n.wasteTomorrow,
        'weekdays': [
          for (var i = 0; i < 7; i++)
            weekday.format(monday.add(Duration(days: i))),
        ],
      },
      'chores': [
        for (final s in states.take(maxChores))
          {
            'id': s.chore.id,
            'name': s.chore.name,
            'due': ChoreRepository.dayKey(s.timing.due),
            'area': areas[s.chore.areaId] == null
                ? null
                : l10n.areaName(areas[s.chore.areaId]!),
            'assignee': members[s.chore.assigneeId]?.name,
            'mine': s.chore.assigneeId == me,
            'minutes': s.chore.effortMinutes,
          },
      ],
      'shopping': [
        for (final i in open.take(maxShopping))
          {
            'id': i.id,
            'name': i.name,
            'detail': itemSubtitle(i, l10n),
            'department': depById[i.departmentId] == null
                ? null
                : l10n.departmentName(depById[i.departmentId]!),
            'notFound': i.status == ItemStatus.notFound.index,
          },
      ],
      'shoppingCount': open.length,
      'meals': [
        for (final m in meals)
          {
            'day': m.day,
            'title': m.title,
            'recipeId': m.recipeId,
            'servings': m.servings,
          },
      ],
      'waste': [
        for (final p in pickups)
          {
            'day': p.day,
            'name': l10n.wasteTypeName(_waste(p.type)),
            'color': _waste(p.type).color,
          },
      ],
    };
  }
}
