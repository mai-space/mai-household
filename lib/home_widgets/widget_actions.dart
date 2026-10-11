import 'dart:convert';

import '../data/app_database.dart';
import '../data/data_context.dart';
import '../data/repositories/chore_repository.dart';
import '../data/repositories/shopping_repository.dart';
import '../domain/chores/schedule.dart';
import '../domain/shopping/store_order.dart';

/// Was auf dem Homescreen abgehakt wurde, solange die App nicht lief.
///
/// Die native Seite merkt sich nur „erledigt“-Markierungen (erneutes Tippen
/// nimmt sie zurück); eingetragen werden sie beim nächsten App-Start über
/// die Repositories — mit `ctx.stamp()` und `notifyChanged()`, also genau
/// wie ein Tippen in der App und damit auch für andere Geräte sichtbar.
class WidgetAction {
  const WidgetAction(this.kind, this.id, this.at);

  /// `shop` (Artikel gekauft) oder `chore` (Aufgabe erledigt).
  final String kind;
  final String id;
  final DateTime at;

  static const shop = 'shop';
  static const chore = 'chore';

  /// Liest die Liste der nativen Seite; Unbekanntes wird übersprungen.
  static List<WidgetAction> parseAll(String? json) {
    if (json == null || json.isEmpty) return const [];
    final Object? raw;
    try {
      raw = jsonDecode(json);
    } on FormatException {
      return const [];
    }
    if (raw is! List) return const [];
    final out = <WidgetAction>[];
    for (final e in raw) {
      if (e is! Map) continue;
      final kind = e['kind'];
      final id = e['id'];
      final at = e['at'];
      if (kind is! String || id is! String || at is! int) continue;
      out.add(WidgetAction(kind, id, DateTime.fromMillisecondsSinceEpoch(at)));
    }
    return out;
  }
}

/// Trägt Widget-Aktionen ein; liefert die Zahl wirksamer Änderungen.
///
/// Bereits Erledigtes (z. B. inzwischen in der App abgehakt) bleibt
/// unverändert, damit nichts doppelt zählt.
Future<int> applyWidgetActions(
  DataContext ctx,
  List<WidgetAction> actions,
) async {
  var applied = 0;
  final shopping = ShoppingRepository(ctx);
  final chores = ChoreRepository(ctx);
  for (final a in actions) {
    switch (a.kind) {
      case WidgetAction.shop:
        final item = await (ctx.db.select(
          ctx.db.shoppingItems,
        )..where((t) => t.id.equals(a.id))).getSingleOrNull();
        if (item == null ||
            item.deleted ||
            item.status == ItemStatus.done.index) {
          continue;
        }
        await shopping.setStatus(item, ItemStatus.done, at: a.at);
        applied++;
      case WidgetAction.chore:
        final chore = await (ctx.db.select(
          ctx.db.chores,
        )..where((t) => t.id.equals(a.id))).getSingleOrNull();
        if (chore == null || chore.deleted || _doneSameDay(chore, a.at)) {
          continue;
        }
        await chores.complete(chore, memberId: ctx.memberId, at: a.at);
        applied++;
    }
  }
  return applied;
}

bool _doneSameDay(Chore c, DateTime at) {
  final last = c.lastDoneAt;
  if (last == null) return false;
  return ChoreSchedule.dateOnly(DateTime.fromMillisecondsSinceEpoch(last)) ==
      ChoreSchedule.dateOnly(at);
}
