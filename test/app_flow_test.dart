import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_household/app/services.dart';
import 'package:mai_household/data/app_database.dart';
import 'package:mai_household/data/data_context.dart';
import 'package:mai_household/domain/shopping/departments.dart';
import 'package:mai_household/l10n/l10n.dart';
import 'package:mai_household/main.dart';

Future<AppServices> _services() async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final ctx = DataContext(AppDatabase(NativeDatabase.memory()));
  await ctx.load();
  return AppServices(ctx);
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Tippt (nach Scrollen in Sicht) und lässt echte DB-Arbeit laufen.
Future<void> _tap(WidgetTester tester, Finder f) async {
  if (f.evaluate().isEmpty) {
    // Lazy gebaute Listen: erst dorthin scrollen.
    await tester.scrollUntilVisible(
      f,
      200,
      scrollable: find
          .byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
          )
          .hitTestable()
          .first,
    );
  }
  await tester.ensureVisible(f);
  await tester.pump();
  await tester.runAsync(() async {
    await tester.tap(f);
    await Future<void>.delayed(const Duration(milliseconds: 300));
  });
  await _settle(tester);
}

/// DB-Abfrage im Test: abwechselnd echte Zeit (I/O) und Frames, bis fertig
/// (drift-Streams der UI laufen in der Fake-Zeit und halten die Sperre).
Future<T> _query<T>(WidgetTester tester, Future<T> Function() fn) async {
  var done = false;
  late T result;
  fn().then((v) {
    result = v;
    done = true;
  });
  for (var i = 0; i < 100 && !done; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 10));
  }
  expect(done, isTrue, reason: 'Abfrage hängt');
  return result;
}

Future<void> _hideSnack(WidgetTester tester) async {
  tester
      .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
      .removeCurrentSnackBar();
  await _settle(tester);
}

Future<void> _back(WidgetTester tester) async {
  final nav = tester.state<NavigatorState>(find.byType(Navigator).first);
  nav.pop();
  await _settle(tester);
}

void main() {
  setUp(() => AppLocale.update(AppLocale.german));

  testWidgets('Einrichten, Einkauf, Aufgaben, Küche, Haushalt', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    final services = await tester.runAsync(_services);
    await tester.pumpWidget(
      HouseholdApp(services: services!, onboarded: false),
    );
    await _settle(tester);

    // Schritt 1: Name
    expect(find.text('Willkommen zu Hause').hitTestable(), findsWidgets);
    await tester.enterText(find.byType(TextField), 'Lena');
    await tester.pump();
    await tester.tap(find.text('Neuen Haushalt einrichten'));
    await _settle(tester);
    // Schritt 2: Läden
    expect(find.text('Wo kauft ihr ein?').hitTestable(), findsWidgets);
    await tester.tap(find.text('Weiter'));
    await _settle(tester);
    // Schritt 3: Aufgaben
    expect(find.text('Was fällt bei euch an?').hitTestable(), findsWidgets);
    await _tap(tester, find.text('Los geht’s'));

    // Heute
    expect(find.textContaining('Lena'), findsWidgets);

    // Einkauf: Text eingeben wie gesprochen
    await tester.tap(find.text('Einkauf').last);
    await _settle(tester);
    await tester.runAsync(() async {
      await tester.enterText(
        find.byType(TextField).first,
        '2 l Milch, Brot und Spülmittel bei Rewe',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await _settle(tester);
    expect(find.text('Milch').hitTestable(), findsWidgets);
    expect(find.text('Brot').hitTestable(), findsWidgets);
    expect(find.text('Spülmittel').hitTestable(), findsWidgets);
    expect(find.text('KÜHLREGAL').hitTestable(), findsWidgets);
    expect(find.text('HAUSHALT & PUTZMITTEL').hitTestable(), findsWidgets);

    final items = await _query(tester, services.shopping.openItems);
    final spuel = items.firstWhere((i) => i.name == 'Spülmittel');
    expect(spuel.storeIds, BuiltinStore.rewe.id);
    expect(spuel.departmentId, BuiltinDepartment.household.id);

    // Ladenmodus bei Aldi: Spülmittel (nur Rewe) fehlt dort.
    await _hideSnack(tester);
    await tester.tap(find.text('Einkaufen'));
    await _settle(tester);
    await tester.tap(find.text('Aldi').last);
    await _settle(tester);
    expect(find.text('Bei Aldi').hitTestable(), findsWidgets);
    expect(find.text('Spülmittel'), findsNothing);
    await _tap(tester, find.text('Milch'));
    await _tap(tester, find.text('Fertig'));
    // Offene Artikel: Sheet „für anderen Laden vormerken“
    if (find.text('Auf der Liste lassen').evaluate().isNotEmpty) {
      await tester.tap(find.text('Auf der Liste lassen'));
      await _settle(tester);
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await _settle(tester);

    // Artikel bearbeiten (⋯)
    await tester.tap(find.byTooltip('Bearbeiten').first);
    await _settle(tester);
    expect(find.text('Wo kaufen?').hitTestable(), findsWidgets);
    Navigator.of(tester.element(find.text('Wo kaufen?'))).pop();
    await _settle(tester);

    // Aufgaben
    await tester.tap(find.text('Aufgaben').last);
    await _settle(tester);
    expect(find.text('Staubsaugen'), findsWidgets);
    await _tap(tester, find.byTooltip('Erledigt').first);
    expect(find.textContaining('danke'), findsOneWidget);

    // Neue Aufgabe
    await _hideSnack(tester);
    await tester.tap(find.text('Aufgabe'));
    await _settle(tester);
    await tester.enterText(find.byType(TextField).first, 'Keller aufräumen');
    await _tap(tester, find.text('Speichern'));
    expect(find.text('Keller aufräumen').hitTestable(), findsWidgets);

    // Müllkalender + Ausgleich öffnen
    await tester.tap(find.byTooltip('Müllabfuhr'));
    await _settle(tester);
    expect(find.text('Noch keine Abfuhrtermine').hitTestable(), findsWidgets);
    await _back(tester);
    await _settle(tester);
    await tester.tap(find.byTooltip('Wer hat was gemacht'));
    await _settle(tester);
    expect(find.text('Lena'), findsWidgets);
    await _back(tester);
    await _settle(tester);

    // Küche: Rezept anlegen
    await tester.tap(find.text('Küche').last);
    await _settle(tester);
    await _hideSnack(tester);
    await tester.tap(find.text('Rezept'));
    await _settle(tester);
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Pfannkuchen');
    await tester.enterText(fields.at(1), '250 g Mehl\n3 Eier\n500 ml Milch\nSalz');
    await tester.enterText(
      fields.at(2),
      'Alles verrühren.\n\n20 Minuten quellen lassen.\n\nIn der Pfanne ausbacken.',
    );
    await _tap(tester, find.text('Speichern'));
    expect(find.text('Pfannkuchen').hitTestable(), findsWidgets);
    await tester.tap(find.text('Pfannkuchen'));
    await _settle(tester);
    expect(find.text('250'), findsNothing);
    expect(find.text('250 g').hitTestable(), findsWidgets);
    // Portionen verdoppeln
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byIcon(Icons.add).last);
      await tester.pump();
    }
    expect(find.text('500 g').hitTestable(), findsWidgets);
    // Kochmodus
    await tester.tap(find.text('Kochen').last);
    await _settle(tester);
    expect(find.text('Alles verrühren.').hitTestable(), findsWidgets);
    await tester.tap(find.text('Weiter'));
    await _settle(tester);
    expect(find.text('20 min').hitTestable(), findsWidgets);
    await _back(tester);
    await _settle(tester);
    // Auf die Einkaufsliste (Salz ist abgewählt)
    await tester.tap(find.text('Einkaufen').last);
    await _settle(tester);
    expect(find.text('2 Zutaten auf die Liste').hitTestable(), findsWidgets);
    await _tap(tester, find.text('2 Zutaten auf die Liste'));
    final after = await _query(tester, services.shopping.openItems);
    final milch = after.firstWhere((i) => i.normalized == 'milch');
    // Milch wurde bei Aldi schon gekauft → neu: 1 l (1000 ml, verdoppelt).
    expect(milch.amount, 1);
    expect(milch.unit, 'l');
    await _back(tester);
    await _settle(tester);

    // Wochenplan-Tab
    await tester.tap(find.text('Wochenplan'));
    await _settle(tester);
    expect(find.text('Zutaten der Woche einkaufen').hitTestable(), findsWidgets);

    // Haushalt
    await tester.tap(find.text('Heute').last);
    await _settle(tester);
    await tester.tap(find.byTooltip('Haushalt'));
    await _settle(tester);
    expect(find.text('Lena (ich)').hitTestable(), findsWidgets);
    expect(find.text('Noch nicht geteilt').hitTestable(), findsWidgets);
    await _back(tester);
    await _settle(tester);

    await tester.runAsync(() async {
      await tester.pumpWidget(const SizedBox());
      await services.dispose();
    });
    await tester.pump(const Duration(seconds: 5));
  });
}
