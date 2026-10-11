import 'package:drift/drift.dart';

import '../../domain/shopping/voice_parser.dart';
import '../../domain/text/normalize.dart';
import '../../domain/text/quantity.dart';
import '../app_database.dart';
import '../data_context.dart';
import 'chore_repository.dart';

/// Zutat eines Rezepts, für die Anzeige skaliert.
class IngredientLine {
  const IngredientLine(this.raw, this.parsed);

  final String raw;
  final ParsedQuantity parsed;

  /// Zwischenüberschrift („Für den Teig:“).
  bool get isHeading => raw.trim().endsWith(':');

  static List<IngredientLine> parseAll(String text) => [
    for (final line in text.split('\n'))
      if (line.trim().isNotEmpty)
        IngredientLine(line.trim(), Quantity.parse(line.trim())),
  ];
}

abstract final class RecipeText {
  /// Schritte: durch Leerzeilen getrennt; einzelne Zeilen mit „1.“ o. ä.
  /// werden ebenfalls getrennt.
  static List<String> steps(String text) {
    final blocks = text
        .split(RegExp(r'\n\s*\n'))
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty)
        .toList();
    if (blocks.length == 1) {
      final numbered = blocks.first.split(RegExp(r'\n(?=\s*\d+[.)]\s)'));
      if (numbered.length > 1) {
        return numbered
            .map((s) => s.replaceFirst(RegExp(r'^\s*\d+[.)]\s*'), '').trim())
            .toList();
      }
    }
    return blocks
        .map((s) => s.replaceFirst(RegExp(r'^\s*\d+[.)]\s*'), '').trim())
        .toList();
  }

  /// Zeitangaben im Schritt („20 Minuten“, „1 Std.“) → Sekunden für einen
  /// Timer.
  static List<int> timers(String step) {
    final out = <int>[];
    final re = RegExp(
      r'(\d+(?:[.,]\d+)?)\s*(?:-|–|bis)?\s*(\d+)?\s*(min(?:\.|uten?)?|minutes?|std\.?|stunden?|h\b|hours?|sek(?:\.|unden?)?|seconds?)',
      caseSensitive: false,
    );
    for (final m in re.allMatches(step)) {
      final value = double.parse(
        (m.group(2) ?? m.group(1)!).replaceAll(',', '.'),
      );
      final unit = m.group(3)!.toLowerCase();
      final factor = unit.startsWith('s') && !unit.startsWith('st')
          ? 1
          : (unit.startsWith('st') || unit.startsWith('h') ? 3600 : 60);
      out.add((value * factor).round());
    }
    return out;
  }

  /// Grundzutaten, die man meistens im Haus hat — beim Übernehmen auf die
  /// Einkaufsliste vorab abgewählt.
  static bool isPantry(String name) {
    final k = TextNorm.key(name);
    const pantry = {
      'salz',
      'pfeffer',
      'salz und pfeffer',
      'wasser',
      'öl',
      'ol',
      'olivenol',
      'zucker',
      'mehl',
      'essig',
      'salt',
      'pepper',
      'water',
      'oil',
      'sugar',
    };
    return pantry.contains(k) || pantry.contains(TextNorm.foldUmlauts(k));
  }
}

class RecipeRepository {
  RecipeRepository(this.ctx);

  final DataContext ctx;
  AppDatabase get db => ctx.db;

  Stream<List<Recipe>> watchRecipes() =>
      (db.select(db.recipes)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.title.lower())]))
          .watch();

  Stream<Recipe?> watchRecipe(String id) =>
      (db.select(db.recipes)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

  Future<Recipe?> recipe(String id) =>
      (db.select(db.recipes)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<List<RecipeCollection>> watchCollections() =>
      (db.select(db.recipeCollections)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.name.lower())]))
          .watch();

  Future<String> save({
    String? id,
    required String title,
    required int servings,
    int? prepMinutes,
    int? cookMinutes,
    int? restMinutes,
    int difficulty = 0,
    required String ingredients,
    required String steps,
    String? tips,
    String? story,
    String? source,
    List<String> tags = const [],
    List<String> collectionIds = const [],
    bool favorite = false,
  }) async {
    final s = ctx.stamp();
    final recipeId = id ?? DataContext.newId();
    String? clean(String? v) => v == null || v.trim().isEmpty ? null : v.trim();
    final existing = id == null ? null : await recipe(id);
    await db
        .into(db.recipes)
        .insertOnConflictUpdate(
          RecipesCompanion.insert(
            id: recipeId,
            updatedAt: s.updatedAt,
            seq: s.seq,
            title: title.trim(),
            servings: Value(servings),
            prepMinutes: Value(prepMinutes),
            cookMinutes: Value(cookMinutes),
            restMinutes: Value(restMinutes),
            difficulty: Value(difficulty),
            ingredients: Value(ingredients.trim()),
            steps: Value(steps.trim()),
            tips: Value(clean(tips)),
            story: Value(clean(story)),
            source: Value(clean(source)),
            tags: Value(
              IdList.join(tags.map((t) => t.trim()).where((t) => t.isNotEmpty)),
            ),
            collectionIds: Value(IdList.join(collectionIds)),
            favorite: Value(favorite),
            createdBy: Value(existing?.createdBy ?? ctx.memberId),
            createdAt:
                existing?.createdAt ?? DateTime.now().millisecondsSinceEpoch,
            lastCookedAt: Value(existing?.lastCookedAt),
          ),
        );
    ctx.notifyChanged();
    return recipeId;
  }

  Future<void> _update(String id, RecipesCompanion changes) async {
    final s = ctx.stamp();
    await (db.update(db.recipes)..where((t) => t.id.equals(id))).write(
      changes.copyWith(updatedAt: Value(s.updatedAt), seq: Value(s.seq)),
    );
    ctx.notifyChanged();
  }

  Future<void> setFavorite(String id, bool favorite) =>
      _update(id, RecipesCompanion(favorite: Value(favorite)));

  Future<void> markCooked(String id) => _update(
    id,
    RecipesCompanion(lastCookedAt: Value(DateTime.now().millisecondsSinceEpoch)),
  );

  Future<void> delete(String id) =>
      _update(id, const RecipesCompanion(deleted: Value(true)));

  Future<void> restore(String id) =>
      _update(id, const RecipesCompanion(deleted: Value(false)));

  Future<void> setCollections(String id, List<String> collectionIds) =>
      _update(
        id,
        RecipesCompanion(collectionIds: Value(IdList.join(collectionIds))),
      );

  Future<String> addCollection(String name) async {
    final id = DataContext.newId();
    final s = ctx.stamp();
    await db
        .into(db.recipeCollections)
        .insert(
          RecipeCollectionsCompanion.insert(
            id: id,
            updatedAt: s.updatedAt,
            seq: s.seq,
            name: name.trim(),
          ),
        );
    ctx.notifyChanged();
    return id;
  }

  Future<void> updateCollection(String id, {String? name, bool? deleted}) async {
    final s = ctx.stamp();
    await (db.update(
      db.recipeCollections,
    )..where((t) => t.id.equals(id))).write(
      RecipeCollectionsCompanion(
        name: name == null ? const Value.absent() : Value(name.trim()),
        deleted: deleted == null ? const Value.absent() : Value(deleted),
        updatedAt: Value(s.updatedAt),
        seq: Value(s.seq),
      ),
    );
    ctx.notifyChanged();
  }

  /// Zutaten (skaliert) als Einkaufsartikel.
  static List<ParsedItem> toShoppingItems(
    Iterable<IngredientLine> lines,
    double factor,
  ) => [
    for (final l in lines)
      if (!l.isHeading && l.parsed.name.isNotEmpty)
        ParsedItem(
          name: TextNorm.capitalize(_stripPreparation(l.parsed.name)),
          amount: l.parsed.amount == null ? null : l.parsed.amount! * factor,
          unit: _shoppingUnit(l.parsed.unit),
        ),
  ];

  /// Küchenmaße (EL, TL, Prise) sind keine Einkaufsmengen.
  static String? _shoppingUnit(String? unit) =>
      const {'EL', 'TL', 'Prise', 'Msp.', 'Tasse', 'Handvoll'}.contains(unit)
      ? null
      : unit;

  /// „Zwiebel, fein gewürfelt“ → „Zwiebel“; „Mehl (Type 405)“ → „Mehl“.
  static String _stripPreparation(String name) => name
      .replaceAll(RegExp(r'\s*\(.*?\)'), '')
      .split(',')
      .first
      .trim();

  // ---------------------------------------------------------------------
  // Wochenplan
  // ---------------------------------------------------------------------

  Stream<List<MealPlanEntry>> watchPlan(DateTime from, DateTime to) =>
      (db.select(db.mealPlanEntries)
            ..where(
              (t) =>
                  t.deleted.equals(false) &
                  t.day.isBetweenValues(
                    ChoreRepository.dayKey(from),
                    ChoreRepository.dayKey(to),
                  ),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.day)]))
          .watch();

  Future<void> planMeal(
    DateTime day, {
    String? recipeId,
    required String title,
    int? servings,
    String? cookId,
  }) async {
    final s = ctx.stamp();
    await db
        .into(db.mealPlanEntries)
        .insert(
          MealPlanEntriesCompanion.insert(
            id: DataContext.newId(),
            updatedAt: s.updatedAt,
            seq: s.seq,
            day: ChoreRepository.dayKey(day),
            recipeId: Value(recipeId),
            title: title.trim(),
            servings: Value(servings),
            cookId: Value(cookId),
          ),
        );
    ctx.notifyChanged();
  }

  Future<void> updateMeal(String id, MealPlanEntriesCompanion changes) async {
    final s = ctx.stamp();
    await (db.update(db.mealPlanEntries)..where((t) => t.id.equals(id))).write(
      changes.copyWith(updatedAt: Value(s.updatedAt), seq: Value(s.seq)),
    );
    ctx.notifyChanged();
  }

  Future<void> removeMeal(String id) =>
      updateMeal(id, const MealPlanEntriesCompanion(deleted: Value(true)));
}
