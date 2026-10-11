import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/data_context.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../domain/text/quantity.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import 'cooking_mode_page.dart';
import 'meal_plan_view.dart';
import 'recipe_form_page.dart';

/// Rezept lesen: Portionen skalieren, Tipps eingeklappt über der
/// Anleitung, Anekdote am Ende (Erkenntnisse aus dem Rezept-Projekt).
class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key, required this.recipeId, this.servings});

  final String recipeId;
  final int? servings;

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  int? _servings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final services = context.services;
    return StreamBuilder<Recipe?>(
      stream: services.recipes.watchRecipe(widget.recipeId),
      builder: (context, snap) {
        final r = snap.data;
        if (r == null || r.deleted) {
          return Scaffold(
            appBar: AppBar(),
            body: snap.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : EmptyState(
                    icon: Icons.menu_book_outlined,
                    title: l10n.recipeGone,
                  ),
          );
        }
        final servings = _servings ?? widget.servings ?? r.servings;
        final factor = r.servings <= 0 ? 1.0 : servings / r.servings;
        final ingredients = IngredientLine.parseAll(r.ingredients);
        final steps = RecipeText.steps(r.steps);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                tooltip: l10n.recipeFavorite,
                icon: Icon(r.favorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () =>
                    services.recipes.setFavorite(r.id, !r.favorite),
              ),
              IconButton(
                tooltip: l10n.commonEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => RecipeFormPage(recipe: r),
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) async {
                  if (v == 'plan') {
                    await planRecipe(context, r, servings);
                  } else if (v == 'delete') {
                    final navigator = Navigator.of(context);
                    final messenger = ScaffoldMessenger.of(context);
                    await services.recipes.delete(r.id);
                    navigator.pop();
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(l10n.recipeDeleted(r.title)),
                        action: SnackBarAction(
                          label: l10n.commonUndo,
                          onPressed: () => services.recipes.restore(r.id),
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'plan', child: Text(l10n.recipePlan)),
                  PopupMenuItem(value: 'delete', child: Text(l10n.commonDelete)),
                ],
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(l10n.recipeToList),
                      onPressed: ingredients.isEmpty
                          ? null
                          : () => addIngredientsToList(
                              context,
                              ingredients,
                              factor,
                              source: r.title,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.soup_kitchen_outlined),
                      label: Text(l10n.recipeCookNow),
                      onPressed: steps.isEmpty
                          ? null
                          : () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => CookingModePage(
                                  recipe: r,
                                  factor: factor,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Text(r.title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              _facts(context, r),
              const SizedBox(height: 20),
              _servingsRow(context, servings),
              const SizedBox(height: 8),
              _ingredientsCard(context, ingredients, factor),
              if (r.tips != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: ExpansionTile(
                    leading: const Icon(Icons.tips_and_updates_outlined),
                    title: Text(l10n.recipeTips),
                    shape: const Border(),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [Text(r.tips!)],
                  ),
                ),
              ],
              if (steps.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(l10n.recipeSteps, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                for (final (i, s) in steps.indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          child: Text('${i + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            s,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              if (r.story != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_stories_outlined),
                            const SizedBox(width: 8),
                            Text(
                              l10n.recipeStory,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          r.story!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (r.source != null) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.recipeSourceLabel(r.source!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _facts(BuildContext context, Recipe r) {
    final l10n = context.l10n;
    final chips = <Widget>[
      if (r.prepMinutes != null)
        Chip(
          avatar: const Icon(Icons.content_cut, size: 16),
          label: Text('${l10n.recipePrep} ${l10n.recipeMinutes(r.prepMinutes!)}'),
        ),
      if (r.cookMinutes != null)
        Chip(
          avatar: const Icon(Icons.local_fire_department_outlined, size: 16),
          label: Text('${l10n.recipeCook} ${l10n.recipeMinutes(r.cookMinutes!)}'),
        ),
      if (r.restMinutes != null)
        Chip(
          avatar: const Icon(Icons.hourglass_empty, size: 16),
          label: Text('${l10n.recipeRest} ${l10n.recipeMinutes(r.restMinutes!)}'),
        ),
      if (r.difficulty > 0)
        Chip(
          label: Text(
            [l10n.recipeEasy, l10n.recipeMedium, l10n.recipeHard][r.difficulty - 1],
          ),
        ),
      for (final t in IdList.parse(r.tags)) Chip(label: Text(t)),
    ];
    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 6, runSpacing: 6, children: chips);
  }

  Widget _servingsRow(BuildContext context, int servings) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(l10n.recipeIngredients, style: theme.textTheme.titleLarge),
        const Spacer(),
        IconButton.filledTonal(
          onPressed: servings > 1
              ? () => setState(() => _servings = servings - 1)
              : null,
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: 88,
          child: Text(
            l10n.recipeServings(servings),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton.filledTonal(
          onPressed: () => setState(() => _servings = servings + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _ingredientsCard(
    BuildContext context,
    List<IngredientLine> lines,
    double factor,
  ) {
    final theme = Theme.of(context);
    final decimal = AppLocale.current.languageCode == 'de' ? ',' : '.';
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final l in lines)
              if (l.isHeading)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l.raw, style: theme.textTheme.titleSmall),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 96,
                        child: Text(
                          scaledAmount(l, factor, decimal),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l.parsed.name.isEmpty ? l.raw : l.parsed.name,
                          style: theme.textTheme.bodyLarge,
                        ),
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

/// „300 g“, „1–2“, „½ TL“.
String scaledAmount(IngredientLine l, double factor, String decimal) {
  final p = l.parsed;
  if (p.amount == null) return p.unit ?? '';
  final (amount, unit) = Quantity.normalize(p.amount! * factor, p.unit);
  final a = Quantity.formatScaled(amount, unit, 1, decimal: decimal);
  return unit == null ? a : '$a $unit';
}

/// Zutaten auswählen und auf die Einkaufsliste setzen. Grundzutaten (Salz,
/// Öl …) sind vorab abgewählt — „haben wir“.
Future<void> addIngredientsToList(
  BuildContext context,
  List<IngredientLine> lines,
  double factor, {
  String? source,
}) async {
  final services = context.services;
  final l10n = context.l10n;
  final candidates = lines.where((l) => !l.isHeading).toList();
  final selected = <int>{
    for (final (i, l) in candidates.indexed)
      if (!RecipeText.isPantry(l.parsed.name)) i,
  };
  final ok = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheet) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
                child: Text(
                  l10n.recipeToListTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(l10n.recipeToListHint),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final (i, l) in candidates.indexed)
                      CheckboxListTile(
                        value: selected.contains(i),
                        onChanged: (v) => setSheet(
                          () => v == true ? selected.add(i) : selected.remove(i),
                        ),
                        title: Text(l.parsed.name.isEmpty ? l.raw : l.parsed.name),
                        subtitle: Text(scaledAmount(l, factor, ',')),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: selected.isEmpty
                      ? null
                      : () => Navigator.pop(context, true),
                  label: Text(l10n.recipeToListConfirm(selected.length)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  if (ok != true) return;
  final items = RecipeRepository.toShoppingItems([
    for (final (i, l) in candidates.indexed)
      if (selected.contains(i)) l,
  ], factor);
  final result = await services.shopping.addItems(items, source: source);
  if (!context.mounted) return;
  showUndo(
    context,
    l10n.shopAdded(result.count),
    undoLabel: l10n.commonUndo,
    onUndo: () => services.shopping.undoAdd(result),
  );
}
