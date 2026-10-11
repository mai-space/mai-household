import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/repositories/chore_repository.dart';
import '../../domain/shopping/voice_parser.dart';
import '../../l10n/l10n.dart';
import '../../sync/sync_service.dart';
import '../../widgets/common.dart';
import '../chores/chores_page.dart';
import '../chores/waste_page.dart';
import '../household/household_page.dart';
import '../kitchen/recipe_detail_page.dart';
import '../shopping/add_bar.dart';
import '../shopping/shopping_data.dart';
import '../shopping/voice_sheet.dart';

/// „Heute“: was jetzt dran ist — Müll, Aufgaben (meine zuerst), Essen,
/// Einkauf. Alles mit einem Tipp erledigt.
class TodayPage extends StatefulWidget {
  const TodayPage({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  ChoreData? _chores;
  ShoppingData? _shopping;
  StreamSubscription<List<MealPlanEntry>>? _mealSub;
  List<MealPlanEntry> _meals = const [];
  Member? _me;
  StreamSubscription<Member?>? _meSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_chores != null) return;
    final s = context.services;
    _chores = ChoreData(s)..addListener(_changed);
    _shopping = ShoppingData(s.shopping)..addListener(_changed);
    final now = DateTime.now();
    _mealSub = s.recipes
        .watchPlan(now, now)
        .listen((v) => setState(() => _meals = v));
    _meSub = s.household.watchMe().listen((v) => setState(() => _me = v));
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _chores?.dispose();
    _shopping?.dispose();
    _mealSub?.cancel();
    _meSub?.cancel();
    super.dispose();
  }

  String _greeting(AppLocalizations l10n) {
    final h = DateTime.now().hour;
    final name = _me?.name ?? '';
    if (h < 11) return l10n.todayMorning(name);
    if (h < 17) return l10n.todayDay(name);
    return l10n.todayEvening(name);
  }

  Future<void> _voice() async {
    final services = context.services;
    final l10n = context.l10n;
    final shopping = _shopping!;
    final sentence = await listenForSentence(
      context,
      title: l10n.shopVoiceTitle,
      hint: l10n.shopVoiceHint,
      phrases: [for (final s in shopping.stores) s.name],
    );
    if (sentence == null || !mounted) return;
    final items = VoiceParser(storeAliases(shopping)).parse(sentence);
    if (items.isEmpty) return;
    final result = await services.shopping.addItems(items);
    if (!mounted) return;
    showUndo(
      context,
      l10n.shopAddedNames(items.map((i) => i.name).join(', ')),
      undoLabel: l10n.commonUndo,
      onUndo: () => services.shopping.undoAdd(result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final chores = _chores!;
    final shopping = _shopping!;
    final me = context.services.ctx.memberId;
    final states = ChoreRepository.ranked(chores.chores, DateTime.now())
        .where((s) => s.timing.isDue)
        .toList();
    // Meine zuerst, dann für alle, dann andere.
    int rank(ChoreState s) => s.chore.assigneeId == me
        ? 0
        : (s.chore.assigneeId == null ? 1 : 2);
    states.sort((a, b) => rank(a).compareTo(rank(b)));
    final storeCounts = [
      for (final s in shopping.stores)
        if (shopping.openCount(s.id) > 0) (s, shopping.openCount(s.id)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_greeting(l10n)),
        actions: [
          ValueListenableBuilder<SyncStatus>(
            valueListenable: context.services.sync.status,
            builder: (context, s, _) => s.nearby.isEmpty
                ? const SizedBox.shrink()
                : Tooltip(
                    message: l10n.syncNearby(s.nearby.length),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.devices, size: 20),
                    ),
                  ),
          ),
          IconButton(
            tooltip: l10n.householdTitle,
            icon: _me == null
                ? const Icon(Icons.settings_outlined)
                : MemberAvatar(_me, size: 30),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HouseholdPage()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'today-voice',
        tooltip: l10n.shopVoiceTooltip,
        onPressed: _voice,
        child: const Icon(Icons.mic),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          WasteSoonCard(data: chores),
          if (_meals.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Card(
                child: Column(
                  children: [
                    for (final m in _meals)
                      ListTile(
                        leading: const Icon(Icons.restaurant_menu),
                        title: Text(l10n.todayMeal),
                        subtitle: Text(
                          m.title,
                          style: theme.textTheme.titleMedium,
                        ),
                        trailing: m.recipeId == null
                            ? null
                            : const Icon(Icons.chevron_right),
                        onTap: m.recipeId == null
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => RecipeDetailPage(
                                    recipeId: m.recipeId!,
                                    servings: m.servings,
                                  ),
                                ),
                              ),
                      ),
                  ],
                ),
              ),
            ),
          SectionHeader(
            l10n.todayChores,
            icon: Icons.task_alt,
            trailing: TextButton(
              onPressed: () => widget.onOpenTab(2),
              child: Text(l10n.todayAll),
            ),
          ),
          if (states.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.todayNothingDue,
                style: theme.textTheme.bodyLarge,
              ),
            )
          else
            for (final s in states.take(6)) ChoreTile(state: s, data: chores),
          SectionHeader(
            l10n.tabShopping,
            icon: Icons.shopping_basket_outlined,
            trailing: TextButton(
              onPressed: () => widget.onOpenTab(1),
              child: Text(l10n.todayAll),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: ListTile(
                onTap: () => widget.onOpenTab(1),
                leading: const Icon(Icons.checklist),
                title: Text(
                  shopping.open.isEmpty
                      ? l10n.todayShoppingEmpty
                      : l10n.todayShoppingOpen(shopping.open.length),
                ),
                subtitle: storeCounts.isEmpty
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            for (final (s, n) in storeCounts)
                              Chip(
                                visualDensity: VisualDensity.compact,
                                avatar: CircleAvatar(
                                  backgroundColor: Color(s.color),
                                ),
                                label: Text('${s.name} $n'),
                              ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
