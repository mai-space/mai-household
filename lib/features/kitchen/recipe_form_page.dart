import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/data_context.dart';
import '../../domain/recipes/recipe_import.dart';
import '../../l10n/l10n.dart';

/// Rezept erfassen — kurz zuerst (Titel, Zutaten, Zubereitung), Details
/// nur bei Bedarf (progressive Offenlegung statt 14-Schritte-Assistent).
class RecipeFormPage extends StatefulWidget {
  const RecipeFormPage({super.key, this.recipe});

  final Recipe? recipe;

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  late final Recipe? r = widget.recipe;
  late final _title = TextEditingController(text: r?.title ?? '');
  late final _ingredients = TextEditingController(text: r?.ingredients ?? '');
  late final _steps = TextEditingController(text: r?.steps ?? '');
  late final _tips = TextEditingController(text: r?.tips ?? '');
  late final _story = TextEditingController(text: r?.story ?? '');
  late final _source = TextEditingController(text: r?.source ?? '');
  late final _tags = TextEditingController(
    text: IdList.parse(r?.tags ?? '').join(', '),
  );
  late final _prep = TextEditingController(text: r?.prepMinutes?.toString());
  late final _cook = TextEditingController(text: r?.cookMinutes?.toString());
  late final _rest = TextEditingController(text: r?.restMinutes?.toString());
  late int _servings = r?.servings ?? 4;
  late int _difficulty = r?.difficulty ?? 0;
  late Set<String> _collections = IdList.parse(r?.collectionIds ?? '').toSet();
  late bool _details =
      r != null &&
      (r!.tips != null ||
          r!.story != null ||
          r!.prepMinutes != null ||
          r!.tags.isNotEmpty);
  List<RecipeCollection> _allCollections = const [];
  StreamSubscription<List<RecipeCollection>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = context.services.recipes.watchCollections().listen(
      (v) => setState(() => _allCollections = v),
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    for (final c in [
      _title,
      _ingredients,
      _steps,
      _tips,
      _story,
      _source,
      _tags,
      _prep,
      _cook,
      _rest,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (_title.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.recipeNeedsTitle)));
      return;
    }
    final repo = context.services.recipes;
    final navigator = Navigator.of(context);
    await repo.save(
      id: r?.id,
      title: _title.text,
      servings: _servings,
      prepMinutes: int.tryParse(_prep.text.trim()),
      cookMinutes: int.tryParse(_cook.text.trim()),
      restMinutes: int.tryParse(_rest.text.trim()),
      difficulty: _difficulty,
      ingredients: _ingredients.text,
      steps: _steps.text,
      tips: _tips.text,
      story: _story.text,
      source: _source.text,
      tags: _tags.text.split(','),
      collectionIds: _collections.toList(),
      favorite: r?.favorite ?? false,
    );
    navigator.pop();
  }

  /// Ganzes Rezept als Text einfügen (z. B. aus einer Nachricht) und
  /// automatisch in Zutaten und Schritte aufteilen.
  Future<void> _pasteWhole() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recipePasteTitle),
        content: SizedBox(
          width: 480,
          child: TextField(
            controller: controller,
            autofocus: true,
            minLines: 8,
            maxLines: 16,
            decoration: InputDecoration(hintText: l10n.recipePasteHint),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.recipePasteApply),
          ),
        ],
      ),
    );
    if (text == null || text.trim().isEmpty) return;
    final split = RecipeImport.fromPlainText(text);
    setState(() {
      if (_title.text.trim().isEmpty && split.title != null) {
        _title.text = split.title!;
      }
      if (split.servings != null) _servings = split.servings!;
      _ingredients.text = split.ingredients.join('\n');
      _steps.text = split.steps.join('\n\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(r == null ? l10n.recipeAdd : l10n.recipeEdit),
        actions: [
          IconButton(
            tooltip: l10n.recipePasteTitle,
            icon: const Icon(Icons.content_paste),
            onPressed: _pasteWhole,
          ),
          TextButton(onPressed: _save, child: Text(l10n.commonSave)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          TextField(
            controller: _title,
            autofocus: r == null,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.titleLarge,
            decoration: InputDecoration(labelText: l10n.recipeTitle),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(l10n.recipeServingsLabel, style: theme.textTheme.titleSmall),
              const Spacer(),
              IconButton.filledTonal(
                onPressed: _servings > 1
                    ? () => setState(() => _servings--)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_servings',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => setState(() => _servings++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ingredients,
            minLines: 4,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.recipeIngredients,
              hintText: l10n.recipeIngredientsHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _steps,
            minLines: 4,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.recipeSteps,
              hintText: l10n.recipeStepsHint,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 8),
          ExpansionTile(
            initiallyExpanded: _details,
            onExpansionChanged: (v) => _details = v,
            tilePadding: EdgeInsets.zero,
            title: Text(l10n.recipeMoreDetails),
            childrenPadding: const EdgeInsets.only(bottom: 12),
            children: [
              Row(
                children: [
                  for (final (c, label) in [
                    (_prep, l10n.recipePrep),
                    (_cook, l10n.recipeCook),
                    (_rest, l10n.recipeRest),
                  ]) ...[
                    Expanded(
                      child: TextField(
                        controller: c,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: label,
                          suffixText: 'min',
                        ),
                      ),
                    ),
                    if (c != _rest) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 6,
                  children: [
                    for (final (v, label) in [
                      (1, l10n.recipeEasy),
                      (2, l10n.recipeMedium),
                      (3, l10n.recipeHard),
                    ])
                      ChoiceChip(
                        label: Text(label),
                        selected: _difficulty == v,
                        onSelected: (s) =>
                            setState(() => _difficulty = s ? v : 0),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _tags,
                decoration: InputDecoration(
                  labelText: l10n.recipeTags,
                  hintText: l10n.recipeTagsHint,
                ),
              ),
              if (_allCollections.isNotEmpty) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final c in _allCollections)
                        FilterChip(
                          label: Text(c.name),
                          selected: _collections.contains(c.id),
                          onSelected: (v) => setState(() {
                            _collections = {..._collections};
                            v
                                ? _collections.add(c.id)
                                : _collections.remove(c.id);
                          }),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _tips,
                minLines: 2,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.recipeTips,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _story,
                minLines: 2,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.recipeStory,
                  hintText: l10n.recipeStoryHint,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _source,
                decoration: InputDecoration(labelText: l10n.recipeSource),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
