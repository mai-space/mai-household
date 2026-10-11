import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Spalten jeder geteilten Tabelle.
///
/// * `id` — UUID oder feste ID eingebauter Einträge (`dep-dairy`).
/// * `updatedAt` — Zeitstempel (hybride Uhr, ms) der letzten Änderung;
///   beim Zusammenführen gewinnt der neuere Stand (pro Zeile).
/// * `seq` — lokale, streng steigende Änderungsnummer; Geräte fragen
///   „alles nach seq X“ ab. Auch übernommene Zeilen bekommen eine neue
///   lokale seq, damit sie an Dritte weitergereicht werden.
/// * `deleted` — Grabstein statt Löschen, damit Löschungen ankommen.
mixin SyncColumns on Table {
  TextColumn get id => text()();
  IntColumn get updatedAt => integer()();
  IntColumn get seq => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// Haushalt
// ---------------------------------------------------------------------------

class Members extends Table with SyncColumns {
  TextColumn get name => text()();
  IntColumn get color => integer()();

  /// Pausiert (Urlaub): wird bei „reihum“ übersprungen.
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

// ---------------------------------------------------------------------------
// Einkauf
// ---------------------------------------------------------------------------

class Stores extends Table with SyncColumns {
  TextColumn get name => text()();
  IntColumn get color => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Departments extends Table with SyncColumns {
  /// `null` bei eingebauten Abteilungen → Name aus der Übersetzung.
  TextColumn get name => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Gang-Reihenfolge je Laden. ID = `<storeId>|<departmentId>`.
class StoreDepartmentOrders extends Table with SyncColumns {
  TextColumn get storeId => text()();
  TextColumn get departmentId => text()();
  RealColumn get position => real()();
}

class ShoppingItems extends Table with SyncColumns {
  TextColumn get name => text()();

  /// `TextNorm.key(name)` — für Zusammenführen und Historie.
  TextColumn get normalized => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get departmentId => text()();

  /// Kommagetrennte Laden-IDs; leer = egal.
  TextColumn get storeIds => text().withDefault(const Constant(''))();

  /// `ItemStatus`-Index (offen, erledigt, gab's nicht).
  IntColumn get status => integer().withDefault(const Constant(0))();
  TextColumn get addedBy => text().nullable()();

  /// Herkunft, z. B. „Lasagne (Do)“, wenn aus einem Rezept.
  TextColumn get source => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get doneAt => integer().nullable()();
  TextColumn get doneStoreId => text().nullable()();
}

/// Was der Haushalt schon einmal gekauft hat. ID = normalisierter Name.
class ProductMemories extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get departmentId => text()();

  /// Laden-ID → Anzahl Käufe dort, als `id:n,id:n`.
  TextColumn get storeCounts => text().withDefault(const Constant(''))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  IntColumn get lastBoughtAt => integer().nullable()();

  /// Gleitender Mittelwert der Tage zwischen zwei Käufen.
  RealColumn get avgIntervalDays => real().nullable()();

  /// „Immer da haben“ (Vorrat) — Vorschlag, wenn lange nicht gekauft.
  BoolColumn get staple => boolean().withDefault(const Constant(false))();
}

// ---------------------------------------------------------------------------
// Aufgaben
// ---------------------------------------------------------------------------

class Areas extends Table with SyncColumns {
  TextColumn get name => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Chores extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get areaId => text()();
  IntColumn get effortMinutes => integer().withDefault(const Constant(15))();

  /// `Recurrence`-Index.
  IntColumn get recurrence => integer().withDefault(const Constant(0))();
  IntColumn get intervalDays => integer().withDefault(const Constant(7))();
  IntColumn get weekdays => integer().withDefault(const Constant(0))();
  IntColumn get dueDate => integer().nullable()();

  /// `Assignment`-Index: niemand, Person, reihum.
  IntColumn get assignment => integer().withDefault(const Constant(0))();
  TextColumn get assigneeId => text().nullable()();
  IntColumn get lastDoneAt => integer().nullable()();
  TextColumn get lastDoneBy => text().nullable()();
  IntColumn get snoozedUntil => integer().nullable()();
  BoolColumn get remind => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
}

class ChoreCompletions extends Table with SyncColumns {
  TextColumn get choreId => text()();
  TextColumn get memberId => text().nullable()();
  IntColumn get doneAt => integer()();
  IntColumn get effortMinutes => integer().withDefault(const Constant(0))();
}

class WastePickups extends Table with SyncColumns {
  /// `WasteType`-Index.
  IntColumn get type => integer()();

  /// Tag als `yyyy-MM-dd`.
  TextColumn get day => text()();
  TextColumn get assigneeId => text().nullable()();
}

// ---------------------------------------------------------------------------
// Küche
// ---------------------------------------------------------------------------

class Recipes extends Table with SyncColumns {
  TextColumn get title => text()();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  IntColumn get prepMinutes => integer().nullable()();
  IntColumn get cookMinutes => integer().nullable()();
  IntColumn get restMinutes => integer().nullable()();

  /// 0 = keine Angabe, 1 leicht, 2 mittel, 3 anspruchsvoll.
  IntColumn get difficulty => integer().withDefault(const Constant(0))();

  /// Eine Zutat pro Zeile („200 g Mehl“), Reihenfolge der Verwendung.
  TextColumn get ingredients => text().withDefault(const Constant(''))();

  /// Schritte, durch Leerzeile getrennt.
  TextColumn get steps => text().withDefault(const Constant(''))();
  TextColumn get tips => text().nullable()();

  /// Anekdote / Familiengeschichte (steht am Ende des Rezepts).
  TextColumn get story => text().nullable()();
  TextColumn get source => text().nullable()();

  /// Kommagetrennte Schlagworte.
  TextColumn get tags => text().withDefault(const Constant(''))();

  /// Kommagetrennte Sammlungs-IDs.
  TextColumn get collectionIds => text().withDefault(const Constant(''))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  TextColumn get createdBy => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get lastCookedAt => integer().nullable()();
}

class RecipeCollections extends Table with SyncColumns {
  TextColumn get name => text()();
  IntColumn get color => integer().withDefault(const Constant(0))();
}

class MealPlanEntries extends Table with SyncColumns {
  TextColumn get day => text()();
  TextColumn get recipeId => text().nullable()();
  TextColumn get title => text()();
  IntColumn get servings => integer().nullable()();
  TextColumn get cookId => text().nullable()();
}

// ---------------------------------------------------------------------------
// Nur lokal (nicht geteilt)
// ---------------------------------------------------------------------------

class LocalSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Bekannte Geräte im Haushalt und Sync-Stand.
class Peers extends Table {
  TextColumn get deviceId => text()();
  TextColumn get name => text()();
  TextColumn get lastAddress => text().nullable()();
  IntColumn get lastSyncAt => integer().nullable()();

  /// Höchste seq des Partners, die wir schon haben.
  IntColumn get theirSeq => integer().withDefault(const Constant(0))();

  /// Höchste eigene seq, die der Partner bestätigt hat.
  IntColumn get ourSeqAcked => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {deviceId};
}

@DriftDatabase(
  tables: [
    Members,
    Stores,
    Departments,
    StoreDepartmentOrders,
    ShoppingItems,
    ProductMemories,
    Areas,
    Chores,
    ChoreCompletions,
    WastePickups,
    Recipes,
    RecipeCollections,
    MealPlanEntries,
    LocalSettings,
    Peers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'mai_household'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
    // Ab Version 2: nur additive Schritte, je ein `if (from < n)`-Block.
    onUpgrade: (m, from, to) async {},
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = OFF');
    },
  );

  Future<void> _createIndexes() async {
    for (final table in syncTableNames) {
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_${table}_seq ON $table (seq)',
      );
    }
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_shopping_items_status '
      'ON shopping_items (deleted, status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_chore_completions_chore '
      'ON chore_completions (chore_id, done_at)',
    );
  }

  /// SQL-Namen aller geteilten Tabellen (Reihenfolge = Sync-Reihenfolge).
  static const syncTableNames = [
    'members',
    'stores',
    'departments',
    'store_department_orders',
    'areas',
    'product_memories',
    'shopping_items',
    'chores',
    'chore_completions',
    'waste_pickups',
    'recipe_collections',
    'recipes',
    'meal_plan_entries',
  ];
}
