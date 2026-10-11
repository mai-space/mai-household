import 'dart:async';

import 'package:flutter/material.dart';

import '../app/services.dart';
import '../features/chores/chores_page.dart';
import '../features/kitchen/kitchen_page.dart';
import '../features/kitchen/recipe_detail_page.dart';
import '../features/shopping/shopping_page.dart';
import '../features/today/today_page.dart';
import '../home_widgets/home_widgets.dart';
import '../l10n/l10n.dart';

/// Vier Bereiche: Heute · Einkauf · Aufgaben · Küche.
///
/// Teilen im WLAN läuft nur, solange die App im Vordergrund ist.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  int _index = 0;
  StreamSubscription<WidgetLink>? _links;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final s = context.services;
      _links = s.widgets.links.stream.listen(_openLink);
      // Erst auf dem Homescreen Abgehaktes eintragen, dann teilen.
      await s.widgets.start().catchError((_) {});
      s.sync.start().catchError((_) {});
      s.watchForReminders();
      s.scheduleReminders();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _links?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final s = context.services;
    if (state == AppLifecycleState.resumed) {
      s.widgets
          .sync()
          .catchError((_) {})
          .whenComplete(() => s.sync.start().catchError((_) {}));
    } else if (state == AppLifecycleState.paused) {
      s.sync.stop().catchError((_) {});
      s.widgets.publish().catchError((_) {});
    }
  }

  /// Tipp auf ein Homescreen-Widget: passenden Bereich öffnen. Aktionen im
  /// Einkauf (Eingabe, Sprache) übernimmt die Einkaufsseite selbst.
  void _openLink(WidgetLink link) {
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
    _open(link.tab);
    final recipeId = link.recipeId;
    if (recipeId != null) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              RecipeDetailPage(recipeId: recipeId, servings: link.servings),
        ),
      );
    }
  }

  void _open(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          TodayPage(onOpenTab: _open),
          const ShoppingPage(),
          const ChoresPage(),
          const KitchenPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _open,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.wb_sunny),
            label: l10n.tabToday,
          ),
          NavigationDestination(
            icon: const Icon(Icons.shopping_basket_outlined),
            selectedIcon: const Icon(Icons.shopping_basket),
            label: l10n.tabShopping,
          ),
          NavigationDestination(
            icon: const Icon(Icons.task_alt_outlined),
            selectedIcon: const Icon(Icons.task_alt),
            label: l10n.tabChores,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.tabKitchen,
          ),
        ],
      ),
    );
  }
}
