import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_household/data/repositories/chore_repository.dart';
import 'package:mai_household/data/repositories/recipe_repository.dart';
import 'package:mai_household/data/repositories/shopping_repository.dart';
import 'package:mai_household/domain/shopping/store_order.dart';
import 'package:mai_household/domain/shopping/voice_parser.dart';
import 'package:mai_household/domain/waste/waste.dart';
import 'package:mai_household/home_widgets/home_widgets.dart';
import 'package:mai_household/home_widgets/widget_actions.dart';
import 'package:mai_household/home_widgets/widget_snapshot.dart';
import 'package:mai_household/l10n/l10n.dart';

import 'helpers.dart';

void main() {
  setUpAll(() => initializeDateFormatting());
  final de = lookupAppLocalizations(AppLocale.german);

  test('Stand enthält Aufgaben, Einkauf, Essen und Müll als JSON', () async {
    final ctx = await testContext();
    final now = DateTime(2026, 10, 12, 9); // Montag
    await ChoreRepository(ctx).addChore(
      name: 'Staubsaugen',
      areaId: 'area-living',
      intervalDays: 7,
      lastDoneAt: DateTime(2026, 10, 1),
    );
    await ShoppingRepository(ctx).addItems([
      const ParsedItem(name: 'Milch', amount: 2, unit: 'l'),
      const ParsedItem(name: 'Brot'),
    ]);
    await RecipeRepository(ctx).planMeal(
      DateTime(2026, 10, 13),
      title: 'Lasagne',
    );
    await ChoreRepository(ctx).addPickups(WasteType.paper, [
      DateTime(2026, 10, 13),
    ]);

    final snapshot = await WidgetSnapshot.build(ctx, de, now: now);
    // Muss sich als JSON übergeben lassen.
    final json = jsonDecode(jsonEncode(snapshot)) as Map<String, dynamic>;

    expect(json['v'], 1);
    final labels = json['labels'] as Map<String, dynamic>;
    expect(labels['tomorrow'], 'Morgen');
    expect(labels['weekdays'], hasLength(7));
    expect((labels['weekdays'] as List).first, startsWith('Mo'));

    final chores = json['chores'] as List;
    expect(chores.single['name'], 'Staubsaugen');
    expect(chores.single['due'], '2026-10-08');
    expect(chores.single['area'], isNotEmpty);

    final shopping = json['shopping'] as List;
    expect(shopping.map((i) => i['name']), containsAll(['Milch', 'Brot']));
    final milk = shopping.firstWhere((i) => i['name'] == 'Milch');
    expect(milk['detail'], '2 l');
    expect(json['shoppingCount'], 2);

    expect((json['meals'] as List).single['day'], '2026-10-13');
    final waste = (json['waste'] as List).single;
    expect(waste['day'], '2026-10-13');
    expect(waste['name'], de.wastePaper);
  });

  test('Aufgaben weit in der Zukunft fehlen im Stand', () async {
    final ctx = await testContext();
    final now = DateTime(2026, 10, 12, 9);
    await ChoreRepository(ctx).addChore(
      name: 'Fenster putzen',
      areaId: 'area-living',
      intervalDays: 60,
      lastDoneAt: DateTime(2026, 10, 10),
    );
    final snapshot = await WidgetSnapshot.build(ctx, de, now: now);
    expect(snapshot['chores'], isEmpty);
  });

  test('auf dem Homescreen Abgehaktes wird eingetragen', () async {
    final ctx = await testContext();
    final shopping = ShoppingRepository(ctx);
    final chores = ChoreRepository(ctx);
    await shopping.addItems([const ParsedItem(name: 'Eier')]);
    final item = (await shopping.openItems()).single;
    final choreId = await chores.addChore(name: 'Bad', areaId: 'area-bath');
    final at = DateTime(2026, 10, 12, 8, 30);
    final seqBefore = ctx.currentSeq;

    final raw = jsonEncode([
      {'kind': 'shop', 'id': item.id, 'at': at.millisecondsSinceEpoch},
      {'kind': 'chore', 'id': choreId, 'at': at.millisecondsSinceEpoch},
      {'kind': 'unbekannt', 'id': 'x', 'at': 1},
      {'kind': 'shop', 'id': 'gibt-es-nicht', 'at': 1},
      'Unsinn',
    ]);
    final applied = await applyWidgetActions(ctx, WidgetAction.parseAll(raw));
    expect(applied, 2);
    // Wie eine Änderung in der App: neue seq, damit es geteilt wird.
    expect(ctx.currentSeq, greaterThan(seqBefore));

    expect(await shopping.openItems(), isEmpty);
    final done = await (ctx.db.select(ctx.db.shoppingItems)).getSingle();
    expect(done.status, ItemStatus.done.index);
    expect(done.doneAt, at.millisecondsSinceEpoch);

    final chore = (await chores.chores()).single;
    expect(chore.lastDoneAt, at.millisecondsSinceEpoch);
    expect(chore.lastDoneBy, ctx.memberId);

    // Zweimal übernehmen (z. B. Absturz vor dem Bestätigen) zählt nicht
    // doppelt.
    expect(await applyWidgetActions(ctx, WidgetAction.parseAll(raw)), 0);
    final completions = await ctx.db.select(ctx.db.choreCompletions).get();
    expect(completions, hasLength(1));
  });

  test('kaputte Daten der nativen Seite werden ignoriert', () {
    expect(WidgetAction.parseAll(null), isEmpty);
    expect(WidgetAction.parseAll(''), isEmpty);
    expect(WidgetAction.parseAll('{'), isEmpty);
    expect(WidgetAction.parseAll('{"kind":"shop"}'), isEmpty);
  });

  test('Widget-Links öffnen den passenden Bereich', () {
    expect(WidgetLink.parse('maihh-widget://open/chores')?.tab, 2);
    final add = WidgetLink.parse('maihh-widget://open/shopping/add')!;
    expect((add.tab, add.action), (1, 'add'));
    final recipe = WidgetLink.parse(
      'maihh-widget://open/recipe/abc-1?servings=2',
    )!;
    expect((recipe.tab, recipe.recipeId, recipe.servings), (3, 'abc-1', 2));
    expect(WidgetLink.parse('https://example.org/open/chores'), isNull);
    expect(WidgetLink.parse('maihh-widget://open/unbekannt'), isNull);
    expect(WidgetLink.parse(null), isNull);
  });
}
