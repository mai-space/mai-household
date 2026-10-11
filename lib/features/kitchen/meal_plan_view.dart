import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/repositories/chore_repository.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import 'recipe_detail_page.dart';

/// Wochenplan: was gibt’s wann — und alle Zutaten der Woche auf einmal
/// auf die Einkaufsliste.
class MealPlanView extends StatefulWidget {
  const MealPlanView({super.key});

  @override
  State<MealPlanView> createState() => _MealPlanViewState();
}

class _MealPlanViewState extends State<MealPlanView>
    with AutomaticKeepAliveClientMixin {
  late DateTime _start = _monday(DateTime.now());
  StreamSubscription<List<MealPlanEntry>>? _sub;
  List<MealPlanEntry> _entries = const [];
  List<Recipe> _recipes = const [];
  StreamSubscription<List<Recipe>>? _recipeSub;

  @override
  bool get wantKeepAlive => true;

  static DateTime _monday(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - 1));

  @override
  void initState() {
    super.initState();
    _listen();
    _recipeSub = context.services.recipes.watchRecipes().listen(
      (v) => setState(() => _recipes = v),
    );
  }

  void _listen() {
    _sub?.cancel();
    _sub = context.services.recipes
        .watchPlan(_start, _start.add(const Duration(days: 6)))
        .listen((v) => setState(() => _entries = v));
  }

  @override
  void dispose() {
    _sub?.cancel();
    _recipeSub?.cancel();
    super.dispose();
  }

  Recipe? _recipe(String? id) {
    if (id == null) return null;
    for (final r in _recipes) {
      if (r.id == id) return r;
    }
    return null;
  }

  Future<void> _add(DateTime day) async {
    final l10n = context.l10n;
    final services = context.services;
    final choice = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _PickMealSheet(recipes: _recipes),
    );
    if (choice == null) return;
    if (choice is Recipe) {
      await services.recipes.planMeal(
        day,
        recipeId: choice.id,
        title: choice.title,
        servings: choice.servings,
      );
    } else if (choice is String && choice.trim().isNotEmpty) {
      await services.recipes.planMeal(day, title: choice);
    }
    if (mounted && choice is Recipe) {
      showMessage(context, l10n.planAdded(choice.title));
    }
  }

  Future<void> _weekToList() async {
    final services = context.services;
    final l10n = context.l10n;
    final lines = <IngredientLine>[];
    final factors = <double>[];
    for (final e in _entries) {
      final r = _recipe(e.recipeId);
      if (r == null) continue;
      final f = r.servings <= 0 ? 1.0 : (e.servings ?? r.servings) / r.servings;
      for (final l in IngredientLine.parseAll(r.ingredients)) {
        if (l.isHeading || RecipeText.isPantry(l.parsed.name)) continue;
        lines.add(l);
        factors.add(f);
      }
    }
    if (lines.isEmpty) {
      showMessage(context, l10n.planNothingToBuy);
      return;
    }
    final items = [
      for (var i = 0; i < lines.length; i++)
        ...RecipeRepository.toShoppingItems([lines[i]], factors[i]),
    ];
    final result = await services.shopping.addItems(
      items,
      source: l10n.planWeekSource,
    );
    if (!mounted) return;
    showUndo(
      context,
      l10n.shopAdded(result.count),
      undoLabel: l10n.commonUndo,
      onUndo: () => services.shopping.undoAdd(result),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final fmt = MaterialLocalizations.of(context);
    final today = ChoreRepository.dayKey(DateTime.now());
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(
                    () => _start = _start.subtract(const Duration(days: 7)),
                  );
                  _listen();
                },
              ),
              Expanded(
                child: Text(
                  '${fmt.formatShortMonthDay(_start)} – '
                  '${fmt.formatShortMonthDay(_start.add(const Duration(days: 6)))}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() => _start = _start.add(const Duration(days: 7)));
                  _listen();
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FilledButton.tonalIcon(
            onPressed: _entries.any((e) => e.recipeId != null)
                ? _weekToList
                : null,
            icon: const Icon(Icons.add_shopping_cart),
            label: Text(l10n.planWeekToList),
          ),
        ),
        for (var i = 0; i < 7; i++)
          Builder(
            builder: (context) {
              final day = _start.add(Duration(days: i));
              final key = ChoreRepository.dayKey(day);
              final meals = _entries.where((e) => e.day == key).toList();
              final isToday = key == today;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Card(
                  color: isToday ? theme.colorScheme.primaryContainer : null,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                isToday
                                    ? '${l10n.planToday} · ${fmt.formatShortMonthDay(day)}'
                                    : fmt.formatMediumDate(day),
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                            IconButton(
                              tooltip: l10n.planAdd,
                              icon: const Icon(Icons.add),
                              onPressed: () => _add(day),
                            ),
                          ],
                        ),
                        for (final m in meals)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              m.recipeId == null
                                  ? Icons.restaurant_outlined
                                  : Icons.menu_book_outlined,
                            ),
                            title: Text(
                              m.title,
                              style: theme.textTheme.titleMedium,
                            ),
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
                            trailing: IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: l10n.commonDelete,
                              onPressed: () =>
                                  context.services.recipes.removeMeal(m.id),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _PickMealSheet extends StatefulWidget {
  const _PickMealSheet({required this.recipes});

  final List<Recipe> recipes;

  @override
  State<_PickMealSheet> createState() => _PickMealSheetState();
}

class _PickMealSheetState extends State<_PickMealSheet> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final q = _text.text.toLowerCase();
    final matches = widget.recipes
        .where((r) => q.isEmpty || r.title.toLowerCase().contains(q))
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _text,
                autofocus: widget.recipes.isEmpty,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setState(() {}),
                onSubmitted: (v) => Navigator.pop(context, v),
                decoration: InputDecoration(
                  hintText: l10n.planPickHint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            if (_text.text.trim().isNotEmpty)
              ListTile(
                leading: const Icon(Icons.restaurant_outlined),
                title: Text(l10n.planFreeText(_text.text.trim())),
                onTap: () => Navigator.pop(context, _text.text.trim()),
              ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final r in matches)
                    ListTile(
                      leading: const Icon(Icons.menu_book_outlined),
                      title: Text(r.title),
                      onTap: () => Navigator.pop(context, r),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rezept für einen Tag einplanen (aus der Rezeptansicht).
Future<void> planRecipe(BuildContext context, Recipe r, int servings) async {
  final services = context.services;
  final l10n = context.l10n;
  final now = DateTime.now();
  final day = await showDatePicker(
    context: context,
    firstDate: DateTime(now.year, now.month, now.day - 7),
    lastDate: DateTime(now.year + 1),
    initialDate: now,
  );
  if (day == null) return;
  await services.recipes.planMeal(
    day,
    recipeId: r.id,
    title: r.title,
    servings: servings,
  );
  if (context.mounted) showMessage(context, l10n.planAdded(r.title));
}
