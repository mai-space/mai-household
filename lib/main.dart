import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/services.dart';
import 'data/app_database.dart';
import 'data/data_context.dart';
import 'features/onboarding/onboarding_page.dart';
import 'l10n/l10n.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLocale.update(AppLocale.current);
  await initializeDateFormatting();
  final ctx = DataContext(AppDatabase());
  await ctx.load();
  final onboarded = await ctx.setting(SettingKeys.onboarded) == '1';
  runApp(HouseholdApp(services: AppServices(ctx), onboarded: onboarded));
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
