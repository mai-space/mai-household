import 'package:drift/drift.dart' show DriftWrappedException;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/services.dart';
import 'data/app_database.dart';
import 'data/connection/connection.dart';
import 'data/connection/database_key.dart';
import 'data/data_context.dart';
import 'features/onboarding/onboarding_page.dart';
import 'l10n/l10n.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLocale.update(AppLocale.current);
  await initializeDateFormatting();
  await _start();
}

Future<void> _start() async {
  final db = AppDatabase();
  final ctx = DataContext(db);
  // Schlüssel vorübergehend nicht lesbar (Keystore hakt): nichts verwerfen,
  // sondern erneut versuchen lassen.
  try {
    await ctx.load();
  } catch (e) {
    if (!_isKeyUnavailable(e)) rethrow;
    await db.close().catchError((Object _) {});
    runApp(_KeyUnavailableApp(onRetry: _start));
    return;
  }
  final onboarded = await ctx.setting(SettingKeys.onboarded) == '1';
  runApp(HouseholdApp(services: AppServices(ctx), onboarded: onboarded));
  if (databaseOpenStatus.value?.unreadableCopy != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showUnreadableData());
  }
}

bool _isKeyUnavailable(Object e) =>
    e is DatabaseKeyUnavailable ||
    (e is DriftWrappedException && e.cause is DatabaseKeyUnavailable);

class _KeyUnavailableApp extends StatelessWidget {
  const _KeyUnavailableApp({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: AppLocale.current,
      supportedLocales: AppLocale.supported,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_clock_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.keyUnavailableTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.keyUnavailableText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onRetry,
                    child: Text(context.l10n.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Die gespeicherte Datenbank ließ sich nicht entschlüsseln und wurde
/// beiseitegelegt — geteilte Listen kommen beim nächsten Abgleich zurück.
void _showUnreadableData() {
  final context = appNavigatorKey.currentContext;
  if (context == null) return;
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.lock_reset),
      title: Text(context.l10n.unreadableTitle),
      content: Text(context.l10n.unreadableText),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.commonUnderstood),
        ),
      ],
    ),
  );
}

class HouseholdApp extends StatefulWidget {
  const HouseholdApp({
    super.key,
    required this.services,
    required this.onboarded,
  });

  final AppServices services;
  final bool onboarded;

  @override
  State<HouseholdApp> createState() => _HouseholdAppState();
}

class _HouseholdAppState extends State<HouseholdApp>
    with WidgetsBindingObserver {
  late bool _onboarded = widget.onboarded;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales == null) return;
    if (AppLocale.update(AppLocale.resolve(locales))) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      services: widget.services,
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        locale: AppLocale.current,
        supportedLocales: AppLocale.supported,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: _onboarded
            ? const AppShell()
            : OnboardingPage(onDone: () => setState(() => _onboarded = true)),
      ),
    );
  }
}
