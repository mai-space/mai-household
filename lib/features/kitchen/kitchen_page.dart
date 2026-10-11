import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/data_context.dart';
import '../../domain/text/normalize.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import 'meal_plan_view.dart';
import 'recipe_detail_page.dart';
import 'recipe_form_page.dart';

/// Küche: Rezeptbuch und Wochenplan.
class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage>
    with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabKitchen),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.kitchenRecipes),
            Tab(text: l10n.kitchenPlan),
          ],
        ),
      ),
      floatingActionButton: _tabs.index == 0
          ? FloatingActionButton.extended(
              heroTag: 'recipe',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const RecipeFormPage()),
              ),
              icon: const Icon(Icons.add),
              label: Text(l10n.recipeAdd),
            )
          : null,
      body: TabBarView(
        controller: _tabs,
        children: const [RecipeList(), MealPlanView()],
      ),
    );
  }
}

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList>
    with AutomaticKeepAliveClientMixin {
  final _search = TextEditingController();
  String _query = '';

  /// `null` = alle, `*` = Favoriten, sonst Sammlungs-ID.
  String? _filter;
  List<Recipe> _recipes = const [];
  List<RecipeCollection> _collections = const [];
  late final List<StreamSubscription<Object?>> _subs;
  bool _loaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final repo = context.services.recipes;
    _subs = [
      repo.watchRecipes().listen(
        (v) => setState(() {
          _recipes = v;
          _loaded = true;
        }),
      ),
      repo.watchCollections().listen((v) => setState(() => _collections = v)),
    ];
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _search.dispose();
    super.dispose();
  }

  bool _matches(Recipe r) {
    if (_filter == '*' && !r.favorite) return false;
    if (_filter != null &&
        _filter != '*' &&
        !IdList.parse(r.collectionIds).contains(_filter)) {
      return false;
    }
    if (_query.isEmpty) return true;
    final q = TextNorm.foldUmlauts(TextNorm.basic(_query));
    final hay = TextNorm.foldUmlauts(
      TextNorm.basic('${r.title} ${r.tags} ${r.ingredients}'),
    );
    return q.split(' ').every(hay.contains);
  }

  Future<void> _addCollection() async {
    final l10n = context.l10n;
    final repo = context.services.recipes;
    final name = await askText(
      context,
      title: l10n.recipeNewCollection,
      confirm: l10n.commonAdd,
      cancel: l10n.commonCancel,
    );
    if (name != null && name.isNotEmpty) {
      final id = await repo.addCollection(name);
      if (mounted) setState(() => _filter = id);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    final list = _recipes.where(_matches).toList();
    if (!_loaded) return const Center(child: CircularProgressIndicator());
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            controller: _search,
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              hintText: l10n.recipeSearch,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            scrollDirection: Axis.horizontal,
            children: [
              ChoiceChip(
                label: Text(l10n.recipeAll),
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                avatar: const Icon(Icons.favorite_border, size: 18),
                label: Text(l10n.recipeFavorites),
                selected: _filter == '*',
                onSelected: (_) => setState(() => _filter = '*'),
              ),
              for (final c in _collections) ...[
                const SizedBox(width: 8),
                ChoiceChip(
                  avatar: const Icon(Icons.collections_bookmark_outlined,
                      size: 18),
                  label: Text(c.name),
                  selected: _filter == c.id,
                  onSelected: (_) => setState(() => _filter = c.id),
                ),
              ],
              const SizedBox(width: 8),
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: Text(l10n.recipeNewCollection),
                onPressed: _addCollection,
              ),
            ],
          ),
        ),
        if (list.isEmpty)
          EmptyState(
            icon: Icons.menu_book_outlined,
            title: _recipes.isEmpty ? l10n.recipeEmptyTitle : l10n.recipeNoMatch,
            message: _recipes.isEmpty ? l10n.recipeEmptyMessage : null,
          ),
        for (final r in list) RecipeCard(recipe: r),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final minutes = (recipe.prepMinutes ?? 0) + (recipe.cookMinutes ?? 0);
    final tags = IdList.parse(recipe.tags);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => RecipeDetailPage(recipeId: recipe.id),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    recipe.title.isEmpty
                        ? '?'
                        : recipe.title.characters.first.toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        [
                          l10n.recipeServings(recipe.servings),
                          if (minutes > 0) l10n.recipeMinutes(minutes),
                          ...tags.take(2),
                        ].join(' · '),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (recipe.favorite)
                  Icon(Icons.favorite, color: theme.colorScheme.tertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
