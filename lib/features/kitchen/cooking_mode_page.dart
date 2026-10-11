import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../l10n/l10n.dart';
import 'recipe_detail_page.dart';

/// Kochmodus: ein Schritt pro Seite, große Schrift, Display bleibt an,
/// Timer aus den Zeitangaben im Schritt.
class CookingModePage extends StatefulWidget {
  const CookingModePage({super.key, required this.recipe, this.factor = 1});

  final Recipe recipe;
  final double factor;

  @override
  State<CookingModePage> createState() => _CookingModePageState();
}

class _CookingModePageState extends State<CookingModePage> {
  final _pages = PageController();
  late final List<String> _steps = RecipeText.steps(widget.recipe.steps);
  late final List<IngredientLine> _ingredients = IngredientLine.parseAll(
    widget.recipe.ingredients,
  );
  int _index = 0;
  final _timers = <_RunningTimer>[];
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable().catchError((_) {});
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timers.isNotEmpty && mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable().catchError((_) {});
    _tick?.cancel();
    _pages.dispose();
    super.dispose();
  }

  /// Zutaten, deren Name im Schritt vorkommt.
  List<IngredientLine> _ingredientsFor(String step) {
    final lower = step.toLowerCase();
    return _ingredients.where((l) {
      if (l.isHeading || l.parsed.name.isEmpty) return false;
      final word = l.parsed.name.toLowerCase().split(RegExp(r'[ ,(]')).first;
      return word.length >= 3 && lower.contains(word);
    }).toList();
  }

  void _startTimer(int seconds) {
    setState(() {
      _timers.add(
        _RunningTimer(
          '${_index + 1}',
          DateTime.now().add(Duration(seconds: seconds)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final last = _index == _steps.length - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(l10n.cookStepOf(_index + 1, _steps.length)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_index + 1) / _steps.length),
          if (_timers.isNotEmpty)
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  for (final t in _timers)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InputChip(
                        avatar: Icon(
                          t.remaining == Duration.zero
                              ? Icons.notifications_active
                              : Icons.timer_outlined,
                        ),
                        label: Text('${l10n.cookStep} ${t.label} · ${t.text}'),
                        backgroundColor: t.remaining == Duration.zero
                            ? theme.colorScheme.errorContainer
                            : null,
                        onDeleted: () => setState(() => _timers.remove(t)),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _steps.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final step = _steps[i];
                final used = _ingredientsFor(step);
                final timers = RecipeText.timers(step);
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      step,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    if (used.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final l in used)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    '${scaledAmount(l, widget.factor, ',')}  ${l.parsed.name}',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (timers.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final s in timers)
                            FilledButton.tonalIcon(
                              icon: const Icon(Icons.timer_outlined),
                              label: Text(_format(Duration(seconds: s))),
                              onPressed: () => _startTimer(s),
                            ),
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _index == 0
                          ? null
                          : () => _pages.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                            ),
                      child: Text(l10n.cookBack),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        if (!last) {
                          _pages.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOut,
                          );
                          return;
                        }
                        final navigator = Navigator.of(context);
                        await context.services.recipes.markCooked(
                          widget.recipe.id,
                        );
                        navigator.pop();
                      },
                      child: Text(last ? l10n.cookFinish : l10n.cookNext),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _format(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  final s = d.inSeconds % 60;
  if (h > 0) return '$h:${m.toString().padLeft(2, '0')} h';
  if (s == 0) return '$m min';
  return '$m:${s.toString().padLeft(2, '0')}';
}

class _RunningTimer {
  _RunningTimer(this.label, this.end);

  final String label;
  final DateTime end;

  Duration get remaining {
    final d = end.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }

  String get text {
    final r = remaining;
    final m = r.inMinutes;
    final s = r.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
