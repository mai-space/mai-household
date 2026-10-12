// Erzeugt die Play-Store-Screenshots unter store/android/screenshots/.
//
// Nicht Teil von `flutter test` (liegt außerhalb von test/). Aufruf:
//   flutter test tool/store_screenshots/store_screenshots_test.dart
//
// Gerendert werden die echten Bildschirme der App mit frei erfundenen
// Beispieldaten (Haushalt „Lena“, „Tom“, „Mia“) in einer In-Memory-
// Datenbank — keine echten Nutzerdaten, kein Gerät nötig.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_household/app/services.dart';
import 'package:mai_household/data/app_database.dart';
import 'package:mai_household/data/data_context.dart';
import 'package:mai_household/data/seed.dart';
import 'package:mai_household/domain/chores/schedule.dart';
import 'package:mai_household/domain/chores/templates.dart';
import 'package:mai_household/domain/shopping/departments.dart';
import 'package:mai_household/domain/shopping/voice_parser.dart';
import 'package:mai_household/domain/waste/waste.dart';
import 'package:mai_household/l10n/l10n.dart';
import 'package:mai_household/main.dart';

/// Zielgröße der Bilder (Hochformat, 9:16 — erfüllt die Play-Vorgaben).
const _physical = Size(1080, 1920);
const _dpr = 2.625;

final _root = GlobalKey();

/// Roboto und Material Icons aus dem Flutter-SDK laden (Tests rendern
/// sonst nur Platzhalter-Kästchen).
Future<void> _loadFonts() async {
  var dir = File(Platform.resolvedExecutable).parent;
  while (!Directory('${dir.path}/bin/cache/artifacts/material_fonts')
          .existsSync() &&
      dir.parent.path != dir.path) {
    dir = dir.parent;
  }
  final fonts = Directory('${dir.path}/bin/cache/artifacts/material_fonts');
  final roboto = FontLoader('Roboto');
  for (final f in fonts.listSync().whereType<File>()) {
    final name = f.uri.pathSegments.last;
    if (name.startsWith('Roboto-') && name.endsWith('.ttf')) {
      roboto.addFont(_bytes(f));
    }
  }
  await roboto.load();
  await (FontLoader('MaterialIcons')
        ..addFont(_bytes(File('${fonts.path}/MaterialIcons-Regular.otf'))))
      .load();
}

Future<ByteData> _bytes(File f) async =>
    ByteData.sublistView(await f.readAsBytes());

class _Sample {
  const _Sample(this.de);
  final bool de;
  String t(String german, String english) => de ? german : english;
}

/// Beispielhaushalt (frei erfunden).
Future<AppServices> _seed(Locale locale) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final x = _Sample(locale == AppLocale.german);
  final ctx = DataContext(AppDatabase(NativeDatabase.memory()));
  await ctx.load();
  final s = AppServices(ctx);
  await seedBuiltins(ctx);
  await ctx.setSetting(SettingKeys.myName, 'Lena');
  await s.household.setMyName('Lena');
  final tom = await s.household.add('Tom');
  await s.household.add('Mia');

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  DateTime ago(int days) => today.subtract(Duration(days: days));

  // Einkauf
  final aldi = BuiltinStore.aldi.id;
  final rewe = BuiltinStore.rewe.id;
  await s.shopping.addItems([
    ParsedItem(name: x.t('Milch', 'Milk'), amount: 2, unit: 'l'),
    ParsedItem(name: x.t('Bananen', 'Bananas')),
    ParsedItem(name: x.t('Tomaten', 'Tomatoes'), amount: 500, unit: 'g'),
    ParsedItem(name: x.t('Gurke', 'Cucumber')),
    ParsedItem(name: x.t('Vollkornbrot', 'Wholegrain bread')),
    ParsedItem(name: x.t('Eier', 'Eggs'), amount: 10),
    ParsedItem(name: x.t('Joghurt', 'Yoghurt'), storeId: aldi),
    ParsedItem(name: x.t('Spaghetti', 'Spaghetti'), amount: 2),
    ParsedItem(name: x.t('Kaffee', 'Coffee'), storeId: aldi),
    ParsedItem(name: x.t('Mineralwasser', 'Sparkling water'), amount: 6),
    ParsedItem(name: x.t('Spülmittel', 'Washing-up liquid'), storeId: rewe),
    ParsedItem(name: x.t('Hafermilch', 'Oat milk'), storeId: rewe),
    ParsedItem(name: x.t('Zahnpasta', 'Toothpaste')),
  ]);

  // Aufgaben
  Future<void> chore(
    String de,
    String en,
    BuiltinArea area,
    int interval,
    int doneDaysAgo, {
    Assignment assignment = Assignment.none,
    String? assignee,
    int effort = 15,
  }) => s.chores.addChore(
    name: x.t(de, en),
    areaId: area.id,
    intervalDays: interval,
    lastDoneAt: ago(doneDaysAgo),
    assignment: assignment,
    assigneeId: assignee,
    effortMinutes: effort,
  );
  await chore('Staubsaugen', 'Vacuum', BuiltinArea.general, 7, 7,
      assignment: Assignment.rotating, assignee: ctx.memberId, effort: 30);
  await chore('Pflanzen gießen', 'Water the plants', BuiltinArea.living, 3, 3,
      effort: 5);
  await chore('Bad putzen', 'Clean the bathroom', BuiltinArea.bath, 7, 6,
      assignment: Assignment.member, assignee: tom, effort: 45);
  await chore('Bettwäsche wechseln', 'Change the bedding',
      BuiltinArea.bedroom, 14, 10, effort: 20);
  await chore('Boden wischen', 'Mop the floor', BuiltinArea.general, 14, 9,
      effort: 30);
  await chore('Kühlschrank auswischen', 'Wipe out the fridge',
      BuiltinArea.kitchen, 30, 12, effort: 20);
  await chore('Fenster putzen', 'Clean the windows', BuiltinArea.living, 60,
      20, effort: 60);

  // Müllkalender
  await s.chores.addPickups(WasteType.residual, [
    today.add(const Duration(days: 1)),
    today.add(const Duration(days: 15)),
  ], assigneeId: tom);
  await s.chores.addPickups(WasteType.organic, [
    today.add(const Duration(days: 1)),
    today.add(const Duration(days: 8)),
  ]);
  await s.chores.addPickups(WasteType.packaging, [
    today.add(const Duration(days: 4)),
  ], assigneeId: ctx.memberId);
  await s.chores.addPickups(WasteType.paper, [
    today.add(const Duration(days: 11)),
  ]);

  // Küche
  final family = await s.recipes.addCollection(x.t('Familie', 'Family'));
  final lasagne = await s.recipes.save(
    title: x.t('Gemüselasagne', 'Vegetable lasagne'),
    servings: 4,
    prepMinutes: 30,
    cookMinutes: 45,
    ingredients: x.t(
      '12 Lasagneplatten\n2 Zucchini\n1 Paprika\n400 g passierte Tomaten\n'
          '250 g Ricotta\n150 g Mozzarella\n1 Zwiebel\nOlivenöl\nSalz',
      '12 lasagne sheets\n2 courgettes\n1 pepper\n400 g passata\n'
          '250 g ricotta\n150 g mozzarella\n1 onion\nOlive oil\nSalt',
    ),
    steps: x.t(
      'Zwiebel und Gemüse würfeln und in Olivenöl 10 Minuten anbraten.\n\n'
          'Passierte Tomaten dazugeben, salzen und kurz köcheln lassen.\n\n'
          'Abwechselnd Platten, Gemüse und Ricotta schichten, mit Mozzarella '
          'abschließen.\n\nBei 180 °C 45 Minuten backen.',
      'Dice the onion and vegetables and fry in olive oil for 10 minutes.\n\n'
          'Add the passata, season and simmer briefly.\n\n'
          'Layer sheets, vegetables and ricotta, finish with mozzarella.\n\n'
          'Bake at 180 °C for 45 minutes.',
    ),
    tips: x.t(
      'Am Vortag schichten — dann zieht alles schön durch.',
      'Layer it the day before so the flavours can soak in.',
    ),
    story: x.t(
      'Omas Sonntagsessen, seit 1987 unverändert.',
      'Grandma’s Sunday dinner, unchanged since 1987.',
    ),
    tags: [x.t('vegetarisch', 'vegetarian')],
    collectionIds: [family],
    favorite: true,
  );
  final pancakes = await s.recipes.save(
    title: x.t('Pfannkuchen', 'Pancakes'),
    servings: 4,
    prepMinutes: 10,
    cookMinutes: 20,
    restMinutes: 20,
    ingredients: x.t(
      '250 g Mehl\n3 Eier\n500 ml Milch\n1 Prise Salz',
      '250 g flour\n3 eggs\n500 ml milk\n1 pinch of salt',
    ),
    steps: x.t(
      'Alles verrühren.\n\n20 Minuten quellen lassen.\n\nIn der Pfanne ausbacken.',
      'Whisk everything together.\n\nLeave to rest for 20 minutes.\n\n'
          'Fry in a pan.',
    ),
    collectionIds: [family],
  );
  final curry = await s.recipes.save(
    title: x.t('Linsencurry', 'Lentil curry'),
    servings: 4,
    prepMinutes: 15,
    cookMinutes: 25,
    ingredients: x.t(
      '250 g rote Linsen\n400 ml Kokosmilch\n1 Zwiebel\n2 Karotten\n'
          '1 EL Currypulver',
      '250 g red lentils\n400 ml coconut milk\n1 onion\n2 carrots\n'
          '1 tbsp curry powder',
    ),
    steps: x.t(
      'Zwiebel und Karotten anbraten.\n\nLinsen, Kokosmilch und Curry dazu, '
          '20 Minuten köcheln.',
      'Fry the onion and carrots.\n\nAdd lentils, coconut milk and curry, '
          'simmer for 20 minutes.',
    ),
    tags: [x.t('vegan', 'vegan')],
  );
  final salad = await s.recipes.save(
    title: x.t('Griechischer Salat', 'Greek salad'),
    servings: 2,
    prepMinutes: 15,
    ingredients: x.t(
      '2 Tomaten\n1 Gurke\n200 g Feta\n1 rote Zwiebel\nOliven',
      '2 tomatoes\n1 cucumber\n200 g feta\n1 red onion\nOlives',
    ),
    steps: x.t('Alles schneiden und mischen.', 'Chop and mix everything.'),
  );
  await s.recipes.markCooked(pancakes);
  await s.recipes.planMeal(today, recipeId: lasagne,
      title: x.t('Gemüselasagne', 'Vegetable lasagne'), servings: 4);
  await s.recipes.planMeal(today.add(const Duration(days: 1)),
      recipeId: curry, title: x.t('Linsencurry', 'Lentil curry'),
      cookId: tom);
  await s.recipes.planMeal(today.add(const Duration(days: 2)),
      recipeId: salad, title: x.t('Griechischer Salat', 'Greek salad'));
  await s.recipes.planMeal(today.add(const Duration(days: 4)),
      recipeId: pancakes, title: x.t('Pfannkuchen', 'Pancakes'));

  await ctx.setSetting(SettingKeys.onboarded, '1');
  return s;
}

Future<void> _settle(WidgetTester tester, [int frames = 12]) async {
  for (var i = 0; i < frames; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.tap(f);
  await _settle(tester);
}

Future<void> _back(WidgetTester tester) async {
  tester.state<NavigatorState>(find.byType(Navigator).first).pop();
  await _settle(tester);
}

Future<void> _shot(WidgetTester tester, String path) async {
  await _settle(tester, 6);
  final boundary =
      _root.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: _dpr);
    final png = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(path)..createSync(recursive: true);
    file.writeAsBytesSync(png!.buffer.asUint8List());
  });
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await _loadFonts();
  });

  for (final locale in AppLocale.supported) {
    final lang = locale.languageCode;
    testWidgets('Store-Screenshots $lang', (tester) async {
      debugDisableShadows = false;
      AppLocale.update(locale);
      tester.view.physicalSize = _physical;
      tester.view.devicePixelRatio = _dpr;
      addTearDown(tester.view.reset);
      tester.binding.platformDispatcher.localesTestValue = [locale];
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
      final l10n = lookupAppLocalizations(locale);
      final dir = 'store/android/screenshots/$lang';

      final services = (await tester.runAsync(() => _seed(locale)))!;
      await tester.pumpWidget(
        RepaintBoundary(
          key: _root,
          child: HouseholdApp(services: services, onboarded: true),
        ),
      );
      await _settle(tester, 20);
      await _shot(tester, '$dir/01_today.png');

      await _tap(tester, find.text(l10n.tabShopping).last);
      await _shot(tester, '$dir/02_shopping.png');

      await _tap(tester, find.text(l10n.shopGoShopping).first);
      await _tap(tester, find.text(BuiltinStore.aldi.label).last);
      await _shot(tester, '$dir/03_store_mode.png');
      await _back(tester);

      await _tap(tester, find.text(l10n.tabChores).last);
      await _shot(tester, '$dir/04_chores.png');

      await _tap(tester, find.byTooltip(l10n.wasteTitle));
      await _shot(tester, '$dir/05_waste.png');
      await _back(tester);

      await _tap(tester, find.text(l10n.tabKitchen).last);
      await _tap(tester, find.text(lang == 'de' ? 'Gemüselasagne' : 'Vegetable lasagne').first);
      await _shot(tester, '$dir/06_recipe.png');
      await _back(tester);

      await _tap(tester, find.text(l10n.kitchenPlan));
      await _shot(tester, '$dir/07_meal_plan.png');

      await _tap(tester, find.text(l10n.tabToday).last);
      await _tap(tester, find.byTooltip(l10n.householdTitle));
      await _shot(tester, '$dir/08_household.png');
      await _back(tester);

      await tester.runAsync(() async {
        await tester.pumpWidget(const SizedBox());
        await services.dispose();
      });
      await tester.pump(const Duration(seconds: 5));
      debugDisableShadows = true;
    });
  }
}
