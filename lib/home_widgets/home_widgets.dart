import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/data_context.dart';
import '../l10n/l10n.dart';
import 'widget_actions.dart';
import 'widget_snapshot.dart';

/// Ziel eines Tipps auf ein Widget (`maihh-widget://open/<ziel>[/<aktion>]`).
class WidgetLink {
  const WidgetLink({required this.tab, this.action, this.recipeId, this.servings});

  /// Reiter der App: 0 Heute, 1 Einkauf, 2 Aufgaben, 3 Küche.
  final int tab;

  /// `add` (Eingabe öffnen) oder `voice` (Spracheingabe) im Einkauf.
  final String? action;
  final String? recipeId;
  final int? servings;

  static WidgetLink? parse(String? link) {
    if (link == null) return null;
    final uri = Uri.tryParse(link);
    if (uri == null || uri.scheme != 'maihh-widget') return null;
    final path = uri.pathSegments;
    if (path.isEmpty) return null;
    final action = path.length > 1 ? path[1] : null;
    return switch (path.first) {
      'today' => const WidgetLink(tab: 0),
      'shopping' => WidgetLink(tab: 1, action: action),
      'chores' => const WidgetLink(tab: 2),
      'kitchen' => const WidgetLink(tab: 3),
      'recipe' when action != null => WidgetLink(
        tab: 3,
        recipeId: action,
        servings: int.tryParse(uri.queryParameters['servings'] ?? ''),
      ),
      _ => null,
    };
  }
}

/// Brücke zu den Android-Homescreen-Widgets (Aufgaben, Einkauf, Essen).
///
/// * Nach jeder Änderung an der Datenbank (auch durch Sync) wird ein neuer
///   Stand an die native Seite übergeben.
/// * Auf dem Homescreen Abgehaktes wird beim Start/Fortsetzen der App
///   eingetragen.
/// * Tipps auf ein Widget öffnen die passende Stelle der App ([links]).
class HomeWidgets {
  HomeWidgets(this.ctx);

  final DataContext ctx;

  static const _channel = MethodChannel('mai/widgets');

  /// Geöffnete Widget-Links (Kaltstart und laufende App).
  final links = StreamController<WidgetLink>.broadcast();

  StreamSubscription<void>? _sub;
  Timer? _debounce;
  bool _started = false;

  static bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Startet die Brücke. Der Link, mit dem die App geöffnet wurde, kommt
  /// danach über [links].
  Future<void> start() async {
    if (!supported || _started) return;
    _started = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'open') {
        final link = WidgetLink.parse(call.arguments as String?);
        if (link != null) links.add(link);
      }
      return null;
    });
    _sub = ctx.db.tableUpdates().listen((_) => schedulePublish());
    // Texte im Widget folgen der Systemsprache.
    AppLocale.changes.addListener(schedulePublish);
    WidgetLink? initial;
    try {
      initial = WidgetLink.parse(
        await _channel.invokeMethod<String>('initialLink'),
      );
    } on PlatformException {
      initial = null;
    } on MissingPluginException {
      initial = null;
    }
    if (initial != null) links.add(initial);
    await sync();
  }

  /// Abgehaktes übernehmen und neuen Stand veröffentlichen (Start,
  /// Rückkehr in die App).
  Future<void> sync() async {
    if (!supported) return;
    try {
      // Erst eintragen, dann bestätigen: stürzt die App dazwischen ab,
      // bleibt die Markierung erhalten (doppelt zählt nichts, siehe
      // applyWidgetActions).
      final pending = await _channel.invokeMethod<String>('pending');
      final actions = WidgetAction.parseAll(pending);
      if (actions.isNotEmpty) {
        await applyWidgetActions(ctx, actions);
        await _channel.invokeMethod<void>('clearPending', pending);
      }
    } on PlatformException {
      // Widgets sind Beiwerk — die App muss trotzdem starten.
    } on MissingPluginException {
      return;
    }
    await publish();
  }

  void schedulePublish() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      publish().catchError((_) {});
    });
  }

  Future<void> publish() async {
    if (!supported) return;
    _debounce?.cancel();
    final snapshot = await WidgetSnapshot.build(ctx, AppLocale.strings);
    try {
      await _channel.invokeMethod<void>('update', jsonEncode(snapshot));
    } on PlatformException {
      // Ignorieren: nächster Versuch bei der nächsten Änderung.
    } on MissingPluginException {
      // Kein Android (Tests, iOS).
    }
  }

  Future<void> dispose() async {
    _debounce?.cancel();
    if (_started) AppLocale.changes.removeListener(schedulePublish);
    await _sub?.cancel();
    await links.close();
  }
}
