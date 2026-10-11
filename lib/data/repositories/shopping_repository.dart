import 'dart:async';

import 'package:drift/drift.dart';

import '../../domain/shopping/classifier.dart';
import '../../domain/shopping/departments.dart';
import '../../domain/shopping/store_order.dart';
import '../../domain/shopping/voice_parser.dart';
import '../../domain/text/normalize.dart';
import '../../domain/text/quantity.dart';
import '../app_database.dart';
import '../data_context.dart';

/// Ergebnis von [ShoppingRepository.addItems] — zum Rückgängigmachen.
class AddResult {
  const AddResult(this.created, this.mergedBefore);

  /// Neu angelegte Artikel-IDs.
  final List<String> created;

  /// Vorheriger Stand von Artikeln, deren Menge erhöht wurde.
  final List<ShoppingItem> mergedBefore;

  int get count => created.length + mergedBefore.length;
}

/// Vorschlag beim Tippen.
class ItemSuggestion {
  const ItemSuggestion(this.name, this.departmentId, {this.fromHistory = true});

  final String name;
  final String? departmentId;
  final bool fromHistory;
}

class ShoppingRepository {
  ShoppingRepository(this.ctx);

  final DataContext ctx;
  AppDatabase get db => ctx.db;

  // ---------------------------------------------------------------------
  // Lesen
  // ---------------------------------------------------------------------

  Stream<List<Store>> watchStores() =>
      (db.select(db.stores)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .watch();

  Stream<List<Department>> watchDepartments() =>
      (db.select(db.departments)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .watch();

  Stream<List<StoreDepartmentOrder>> watchOrders() =>
      (db.select(db.storeDepartmentOrders)
            ..where((t) => t.deleted.equals(false)))
          .watch();

  /// Offene und „gab’s nicht“-Artikel.
  Stream<List<ShoppingItem>> watchOpen() =>
      (db.select(db.shoppingItems)
            ..where(
              (t) =>
                  t.deleted.equals(false) &
                  t.status.isNotValue(ItemStatus.done.index),
            )
            ..orderBy([(t) => OrderingTerm(expression: t.name.lower())]))
          .watch();

  Stream<List<ShoppingItem>> watchDone() =>
      (db.select(db.shoppingItems)
            ..where(
              (t) =>
                  t.deleted.equals(false) &
                  t.status.equals(ItemStatus.done.index),
            )
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.doneAt, mode: OrderingMode.desc),
            ]))
          .watch();

  Future<List<ShoppingItem>> openItems() =>
      (db.select(db.shoppingItems)..where(
            (t) =>
                t.deleted.equals(false) &
                t.status.isNotValue(ItemStatus.done.index),
          ))
          .get();

  Future<List<Store>> stores() =>
      (db.select(db.stores)
            ..where((t) => t.deleted.equals(false))
            ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
          .get();

  Future<Map<String, String>> _memoryMap() async {
    final rows = await (db.select(
      db.productMemories,
    )..where((t) => t.deleted.equals(false))).get();
    return {for (final r in rows) r.id: r.departmentId};
  }

  Future<ProductMemory?> memoryFor(String name) =>
      (db.select(db.productMemories)
            ..where((t) => t.id.equals(TextNorm.key(name))))
          .getSingleOrNull();

  /// Abteilung für einen Namen (Historie → Wörterbuch → Sonstiges).
  Future<String> classify(String name) async {
    final classifier = ProductClassifier(memory: await _memoryMap());
    return classifier.classify(name) ?? BuiltinDepartment.other.id;
  }

  /// Vorschläge beim Tippen: eigene Historie zuerst (häufig vor selten),
  /// danach Begriffe aus dem Wörterbuch.
  Future<List<ItemSuggestion>> suggestions(String query, {int limit = 8}) async {
    final q = TextNorm.foldUmlauts(TextNorm.basic(query));
    final open = (await openItems()).map((i) => i.normalized).toSet();
    final memories =
        await (db.select(db.productMemories)
              ..where((t) => t.deleted.equals(false))
              ..orderBy([
                (t) => OrderingTerm(
                  expression: t.usageCount,
                  mode: OrderingMode.desc,
                ),
                (t) => OrderingTerm(
                  expression: t.lastBoughtAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    final out = <ItemSuggestion>[];
    final seen = <String>{};
    int rank(String key) {
      if (key.startsWith(q)) return 0;
      if (key.split(' ').any((w) => w.startsWith(q))) return 1;
      return key.contains(q) ? 2 : 3;
    }

    final matching =
        memories
            .where((m) => !open.contains(m.id) && (q.isEmpty || rank(m.id) < 3))
            .toList()
          ..sort((a, b) => q.isEmpty ? 0 : rank(a.id).compareTo(rank(b.id)));
    for (final m in matching) {
      if (seen.add(m.id)) out.add(ItemSuggestion(m.name, m.departmentId));
      if (out.length >= limit) return out;
    }
    if (q.length < 2) return out;
    final catalog =
        ProductClassifier.catalogKeys
            .where((k) => !open.contains(k) && rank(k) < 2)
            .toList()
          ..sort((a, b) {
            final r = rank(a).compareTo(rank(b));
            return r != 0 ? r : a.length.compareTo(b.length);
          });
    for (final k in catalog) {
      if (seen.add(k)) {
        out.add(
          ItemSuggestion(
            TextNorm.capitalize(k),
            ProductClassifier().classify(k),
            fromHistory: false,
          ),
        );
      }
      if (out.length >= limit) break;
    }
    return out;
  }

  /// „Bald wieder nötig“: Vorrat und regelmäßig Gekauftes, das gerade
  /// nicht auf der Liste steht — überfälligstes zuerst.
  Future<List<ProductMemory>> restockSuggestions({
    DateTime? now,
    int limit = 6,
  }) async {
    final today = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final open = (await openItems()).map((i) => i.normalized).toSet();
    final rows = await (db.select(
      db.productMemories,
    )..where((t) => t.deleted.equals(false))).get();
    double due(ProductMemory m) {
      final last = m.lastBoughtAt;
      final interval = m.avgIntervalDays;
      if (last == null || interval == null || interval <= 0) {
        return m.staple ? 1 : 0;
      }
      return (today - last) / Duration.millisecondsPerDay / interval;
    }

    final candidates =
        rows
            .where(
              (m) =>
                  !open.contains(m.id) &&
                  (m.staple || m.usageCount >= 3) &&
                  due(m) >= 0.8,
            )
            .toList()
          ..sort((a, b) => due(b).compareTo(due(a)));
    return candidates.take(limit).toList();
  }

  // ---------------------------------------------------------------------
  // Artikel
  // ---------------------------------------------------------------------

  /// Legt Artikel an; steht derselbe Artikel schon offen auf der Liste,
  /// wird die Menge erhöht (gleiche Einheit) statt doppelt eingetragen.
  Future<AddResult> addItems(
    List<ParsedItem> items, {
    String? source,
    String? defaultStoreId,
  }) async {
    final classifier = ProductClassifier(memory: await _memoryMap());
    final created = <String>[];
    final merged = <ShoppingItem>[];
    await db.transaction(() async {
      for (final item in items) {
        final key = TextNorm.key(item.name);
        if (key.isEmpty) continue;
        final existing =
            await (db.select(db.shoppingItems)
                  ..where(
                    (t) =>
                        t.deleted.equals(false) &
                        t.status.isNotValue(ItemStatus.done.index) &
                        t.normalized.equals(key),
                  )
                  ..limit(1))
                .getSingleOrNull();
        final storeId = item.storeId ?? defaultStoreId;
        if (existing != null) {
          merged.add(existing);
          final s = ctx.stamp();
          double? amount = existing.amount;
          String? note = existing.note;
          if (item.amount != null) {
            if (existing.unit == item.unit) {
              amount = (existing.amount ?? (item.unit == null ? 1 : 0)) +
                  item.amount!;
            } else {
              final extra = Quantity.label(item.amount, item.unit);
              note = [?note, '+ $extra'].join(' ');
            }
          }
          final stores = IdList.parse(existing.storeIds);
          if (storeId != null && !stores.contains(storeId) && stores.isNotEmpty) {
            stores.add(storeId);
          }
          await (db.update(
            db.shoppingItems,
          )..where((t) => t.id.equals(existing.id))).write(
            ShoppingItemsCompanion(
              amount: Value(amount),
              note: Value(note),
              storeIds: Value(IdList.join(stores)),
              status: Value(ItemStatus.open.index),
              source: source == null ? const Value.absent() : Value(source),
              updatedAt: Value(s.updatedAt),
              seq: Value(s.seq),
            ),
          );
          continue;
        }
        final s = ctx.stamp();
        final id = DataContext.newId();
        await db
            .into(db.shoppingItems)
            .insert(
              ShoppingItemsCompanion.insert(
                id: id,
                updatedAt: s.updatedAt,
                seq: s.seq,
                name: item.name.trim(),
                normalized: key,
                amount: Value(item.amount),
                unit: Value(item.unit),
                departmentId:
                    classifier.classify(item.name) ??
                    BuiltinDepartment.other.id,
                storeIds: Value(storeId ?? ''),
                addedBy: Value(ctx.memberId),
                source: Value(source),
                createdAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
        created.add(id);
      }
    });
    if (created.isNotEmpty || merged.isNotEmpty) ctx.notifyChanged();
    return AddResult(created, merged);
  }

  /// Macht [addItems] rückgängig.
  Future<void> undoAdd(AddResult result) async {
    await db.transaction(() async {
      for (final id in result.created) {
        await _write(id, const ShoppingItemsCompanion(deleted: Value(true)));
      }
      for (final before in result.mergedBefore) {
        await _write(
          before.id,
          ShoppingItemsCompanion(
            amount: Value(before.amount),
            note: Value(before.note),
            storeIds: Value(before.storeIds),
            status: Value(before.status),
          ),
        );
      }
    });
    ctx.notifyChanged();
  }

  Future<void> _write(String id, ShoppingItemsCompanion changes) {
    final s = ctx.stamp();
    return (db.update(db.shoppingItems)..where((t) => t.id.equals(id))).write(
      changes.copyWith(updatedAt: Value(s.updatedAt), seq: Value(s.seq)),
    );
  }

  Future<void> update(
    ShoppingItem item, {
    String? name,
    Value<double?> amount = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> note = const Value.absent(),
    List<String>? storeIds,
  }) async {
    final newName = name?.trim();
    await _write(
      item.id,
      ShoppingItemsCompanion(
        name: newName == null || newName.isEmpty
            ? const Value.absent()
            : Value(newName),
        normalized: newName == null || newName.isEmpty
            ? const Value.absent()
            : Value(TextNorm.key(newName)),
        amount: amount,
        unit: unit,
        note: note,
        storeIds: storeIds == null
            ? const Value.absent()
            : Value(IdList.join(storeIds)),
      ),
    );
    ctx.notifyChanged();
  }

  /// Abteilung ändern — und für dieses Produkt dauerhaft merken.
  Future<void> moveToDepartment(ShoppingItem item, String departmentId) async {
    await db.transaction(() async {
      await _write(
        item.id,
        ShoppingItemsCompanion(departmentId: Value(departmentId)),
      );
      await _remember(item.name, departmentId: departmentId);
    });
    ctx.notifyChanged();
  }

  Future<void> setStatus(
    ShoppingItem item,
    ItemStatus status, {
    String? storeId,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.transaction(() async {
      await _write(
        item.id,
        ShoppingItemsCompanion(
          status: Value(status.index),
          doneAt: Value(status == ItemStatus.done ? now : null),
          // Bei „gab’s nicht“: in welchem Laden (Hinweis für später).
          doneStoreId: Value(status == ItemStatus.open ? null : storeId),
        ),
      );
      if (status == ItemStatus.done) {
        await _remember(
          item.name,
          departmentId: item.departmentId,
          boughtAt: now,
          storeId: storeId,
        );
      }
    });
    ctx.notifyChanged();
  }

  Future<void> delete(ShoppingItem item) async {
    await _write(item.id, const ShoppingItemsCompanion(deleted: Value(true)));
    ctx.notifyChanged();
  }

  Future<void> restore(ShoppingItem item) async {
    await _write(
      item.id,
      ShoppingItemsCompanion(
        deleted: const Value(false),
        status: Value(item.status),
      ),
    );
    ctx.notifyChanged();
  }

  /// Erledigte Artikel endgültig entfernen.
  Future<int> clearDone() async {
    final done = await (db.select(db.shoppingItems)..where(
          (t) =>
              t.deleted.equals(false) & t.status.equals(ItemStatus.done.index),
        ))
        .get();
    await db.transaction(() async {
      for (final item in done) {
        await _write(
          item.id,
          const ShoppingItemsCompanion(deleted: Value(true)),
        );
      }
    });
    if (done.isNotEmpty) ctx.notifyChanged();
    return done.length;
  }

  /// Historie pflegen: Abteilung, Laden-Häufigkeit, Kaufabstand.
  Future<void> _remember(
    String name, {
    required String departmentId,
    int? boughtAt,
    String? storeId,
  }) async {
    final key = TextNorm.key(name);
    if (key.isEmpty) return;
    final existing = await (db.select(
      db.productMemories,
    )..where((t) => t.id.equals(key))).getSingleOrNull();
    final s = ctx.stamp();
    if (existing == null) {
      await db
          .into(db.productMemories)
          .insert(
            ProductMemoriesCompanion.insert(
              id: key,
              updatedAt: s.updatedAt,
              seq: s.seq,
              name: TextNorm.capitalize(name),
              departmentId: departmentId,
              usageCount: Value(boughtAt == null ? 0 : 1),
              lastBoughtAt: Value(boughtAt),
              storeCounts: Value(storeId == null ? '' : '$storeId:1'),
            ),
          );
      return;
    }
    double? avg = existing.avgIntervalDays;
    if (boughtAt != null && existing.lastBoughtAt != null) {
      final days =
          (boughtAt - existing.lastBoughtAt!) / Duration.millisecondsPerDay;
      // Mehrfach am selben Tag abgehakt zählt nicht als neuer Abstand.
      if (days >= 0.5) avg = avg == null ? days : avg * 0.7 + days * 0.3;
    }
    final counts = StoreCounts.parse(existing.storeCounts);
    if (storeId != null) counts[storeId] = (counts[storeId] ?? 0) + 1;
    await (db.update(
      db.productMemories,
    )..where((t) => t.id.equals(key))).write(
      ProductMemoriesCompanion(
        departmentId: Value(departmentId),
        deleted: const Value(false),
        usageCount: boughtAt == null
            ? const Value.absent()
            : Value(existing.usageCount + 1),
        lastBoughtAt: boughtAt == null
            ? const Value.absent()
            : Value(boughtAt),
        avgIntervalDays: Value(avg),
        storeCounts: Value(StoreCounts.format(counts)),
        updatedAt: Value(s.updatedAt),
        seq: Value(s.seq),
      ),
    );
  }

  Future<void> setStaple(String name, bool staple) async {
    final key = TextNorm.key(name);
    final existing = await (db.select(
      db.productMemories,
    )..where((t) => t.id.equals(key))).getSingleOrNull();
    if (existing == null) {
      await _remember(name, departmentId: await classify(name));
    }
    final s = ctx.stamp();
    await (db.update(db.productMemories)..where((t) => t.id.equals(key))).write(
      ProductMemoriesCompanion(
        staple: Value(staple),
        updatedAt: Value(s.updatedAt),
        seq: Value(s.seq),
      ),
    );
    ctx.notifyChanged();
  }

  /// Eintrag aus der Historie löschen (falsch geschriebene Vorschläge).
  Future<void> forget(String memoryId) async {
    final s = ctx.stamp();
    await (db.update(
      db.productMemories,
    )..where((t) => t.id.equals(memoryId))).write(
      ProductMemoriesCompanion(
        deleted: const Value(true),
        updatedAt: Value(s.updatedAt),
        seq: Value(s.seq),
      ),
    );
    ctx.notifyChanged();
  }

  // ---------------------------------------------------------------------
  // Läden & Abteilungen
  // ---------------------------------------------------------------------

  Future<String> addStore(String name, int color) async {
    final id = DataContext.newId();
    final existing = await stores();
    final s = ctx.stamp();
    await db.transaction(() async {
      await db
          .into(db.stores)
          .insert(
            StoresCompanion.insert(
              id: id,
              updatedAt: s.updatedAt,
              seq: s.seq,
              name: name.trim(),
              color: color,
              sortOrder: Value(existing.length),
            ),
          );
    });
    ctx.notifyChanged();
    return id;
  }

  Future<void> updateStore(
    String id, {
    String? name,
    int? color,
    int? sortOrder,
    bool? deleted,
  }) async {
    final s = ctx.stamp();
    await (db.update(db.stores)..where((t) => t.id.equals(id))).write(
      StoresCompanion(
        name: name == null ? const Value.absent() : Value(name.trim()),
        color: color == null ? const Value.absent() : Value(color),
        sortOrder: sortOrder == null ? const Value.absent() : Value(sortOrder),
        deleted: deleted == null ? const Value.absent() : Value(deleted),
        updatedAt: Value(s.updatedAt),
        seq: Value(s.seq),
      ),
    );
    ctx.notifyChanged();
  }

  Future<void> reorderStores(List<String> ids) async {
    await db.transaction(() async {
      for (var i = 0; i < ids.length; i++) {
        final s = ctx.stamp();
        await (db.update(db.stores)..where((t) => t.id.equals(ids[i]))).write(
          StoresCompanion(
            sortOrder: Value(i),
            updatedAt: Value(s.updatedAt),
            seq: Value(s.seq),
          ),
        );
      }
    });
    ctx.notifyChanged();
  }

  Future<String> addDepartment(String name) async {
    final id = DataContext.newId();
    final count = await db.departments.count().getSingle();
    final s = ctx.stamp();
    await db
        .into(db.departments)
        .insert(
          DepartmentsCompanion.insert(
            id: id,
            updatedAt: s.updatedAt,
            seq: s.seq,
            name: Value(name.trim()),
            sortOrder: Value(count),
          ),
        );
    ctx.notifyChanged();
    return id;
  }

  Future<void> renameDepartment(String id, String name) async {
    final s = ctx.stamp();
    await (db.update(db.departments)..where((t) => t.id.equals(id))).write(
      DepartmentsCompanion(
        name: Value(name.trim()),
        updatedAt: Value(s.updatedAt),
        seq: Value(s.seq),
      ),
    );
    ctx.notifyChanged();
  }

  /// Reihenfolge der Abteilungen: allgemein (`storeId == null`) oder für
  /// einen Laden.
  Future<void> reorderDepartments(String? storeId, List<String> ids) async {
    await db.transaction(() async {
      for (var i = 0; i < ids.length; i++) {
        final s = ctx.stamp();
        if (storeId == null) {
          await (db.update(
            db.departments,
          )..where((t) => t.id.equals(ids[i]))).write(
            DepartmentsCompanion(
              sortOrder: Value(i),
              updatedAt: Value(s.updatedAt),
              seq: Value(s.seq),
            ),
          );
        } else {
          await _setOrder(storeId, ids[i], i.toDouble(), s);
        }
      }
    });
    ctx.notifyChanged();
  }

  Future<void> _setOrder(
    String storeId,
    String departmentId,
    double position,
    ({int updatedAt, int seq}) s,
  ) => db
      .into(db.storeDepartmentOrders)
      .insertOnConflictUpdate(
        StoreDepartmentOrdersCompanion.insert(
          id: '$storeId|$departmentId',
          updatedAt: s.updatedAt,
          seq: s.seq,
          storeId: storeId,
          departmentId: departmentId,
          position: position,
        ),
      );

  /// Positionen der Abteilungen in einem Laden (fehlende: allgemeine
  /// Reihenfolge, hinten angestellt).
  Future<Map<String, double>> storePositions(String storeId) async {
    final deps = await (db.select(
      db.departments,
    )..where((t) => t.deleted.equals(false))).get();
    final orders = await (db.select(db.storeDepartmentOrders)..where(
          (t) => t.storeId.equals(storeId) & t.deleted.equals(false),
        ))
        .get();
    final byDep = {for (final o in orders) o.departmentId: o.position};
    return {
      for (final d in deps) d.id: byDep[d.id] ?? 100.0 + d.sortOrder,
    };
  }

  /// Nach dem Einkauf: Abhak-Reihenfolge in die Gang-Reihenfolge lernen.
  Future<void> learnStoreOrder(String storeId, List<String> visited) async {
    if (visited.length < 2) return;
    final current = await storePositions(storeId);
    final learned = StoreOrderLearner.learn(current, visited);
    await db.transaction(() async {
      for (final entry in learned.entries) {
        if (current[entry.key] == entry.value) continue;
        await _setOrder(storeId, entry.key, entry.value, ctx.stamp());
      }
    });
    ctx.notifyChanged();
  }
}

/// `id:n,id:n` ↔ Map.
abstract final class StoreCounts {
  static Map<String, int> parse(String s) {
    final out = <String, int>{};
    for (final part in IdList.parse(s)) {
      final i = part.lastIndexOf(':');
      if (i <= 0) continue;
      out[part.substring(0, i)] = int.tryParse(part.substring(i + 1)) ?? 0;
    }
    return out;
  }

  static String format(Map<String, int> counts) =>
      counts.entries.map((e) => '${e.key}:${e.value}').join(',');

  /// Laden, in dem meistens gekauft wird (≥ 3 Käufe, ≥ 70 %).
  static String? preferred(String s) {
    final counts = parse(s);
    final total = counts.values.fold(0, (a, b) => a + b);
    for (final e in counts.entries) {
      if (e.value >= 3 && e.value / total >= 0.7) return e.key;
    }
    return null;
  }
}
