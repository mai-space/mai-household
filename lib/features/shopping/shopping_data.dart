import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/app_database.dart';
import '../../data/data_context.dart';
import '../../data/repositories/shopping_repository.dart';
import '../../domain/shopping/store_order.dart';

/// Abteilung mit ihren Artikeln (in Laden- oder Standard-Reihenfolge).
class DepartmentGroup {
  const DepartmentGroup(this.department, this.items);

  final Department department;
  final List<ShoppingItem> items;
}

/// Alles, was die Einkaufsansichten brauchen — live aus der Datenbank.
class ShoppingData extends ChangeNotifier {
  ShoppingData(this.repo) {
    _subs = [
      repo.watchStores().listen((v) => _set(() => stores = v)),
      repo.watchDepartments().listen((v) => _set(() => departments = v)),
      repo.watchOrders().listen((v) => _set(() => orders = v)),
      repo.watchOpen().listen((v) => _set(() => open = v)),
      repo.watchDone().listen((v) => _set(() => done = v)),
    ];
  }

  final ShoppingRepository repo;
  late final List<StreamSubscription<Object?>> _subs;

  List<Store> stores = const [];
  List<Department> departments = const [];
  List<StoreDepartmentOrder> orders = const [];
  List<ShoppingItem> open = const [];
  List<ShoppingItem> done = const [];
  int _loaded = 0;

  bool get loaded => _loaded >= 5;

  void _set(VoidCallback f) {
    f();
    if (_loaded < 5) _loaded++;
    notifyListeners();
  }

  Store? store(String? id) {
    if (id == null) return null;
    for (final s in stores) {
      if (s.id == id) return s;
    }
    return null;
  }

  Department? department(String id) {
    for (final d in departments) {
      if (d.id == id) return d;
    }
    return null;
  }

  /// Artikel, die in [storeId] zu kaufen sind (ohne Laden = egal = überall).
  static bool availableIn(ShoppingItem item, String? storeId) {
    if (storeId == null) return true;
    final ids = IdList.parse(item.storeIds);
    return ids.isEmpty || ids.contains(storeId);
  }

  int openCount(String? storeId) =>
      open.where((i) => availableIn(i, storeId)).length;

  /// Positionen der Abteilungen für einen Laden (oder allgemein).
  Map<String, double> positions(String? storeId) {
    final base = {
      for (final d in departments) d.id: 100.0 + d.sortOrder,
    };
    if (storeId == null) {
      return {for (final d in departments) d.id: d.sortOrder.toDouble()};
    }
    for (final o in orders) {
      if (o.storeId == storeId && base.containsKey(o.departmentId)) {
        base[o.departmentId] = o.position;
      }
    }
    return base;
  }

  List<Department> orderedDepartments(String? storeId) {
    final pos = positions(storeId);
    return [...departments]
      ..sort((a, b) => (pos[a.id] ?? 999).compareTo(pos[b.id] ?? 999));
  }

  /// Gruppiert offene Artikel nach Abteilung in Gang-Reihenfolge.
  List<DepartmentGroup> groups(
    String? storeId, {
    Iterable<ShoppingItem>? items,
  }) {
    final source = (items ?? open).where((i) => availableIn(i, storeId));
    final byDep = <String, List<ShoppingItem>>{};
    for (final item in source) {
      (byDep[item.departmentId] ??= []).add(item);
    }
    final out = <DepartmentGroup>[];
    for (final d in orderedDepartments(storeId)) {
      final list = byDep.remove(d.id);
      if (list != null) out.add(DepartmentGroup(d, list));
    }
    // Artikel mit unbekannter (gelöschter) Abteilung ans Ende.
    for (final entry in byDep.entries) {
      out.add(
        DepartmentGroup(
          Department(
            id: entry.key,
            updatedAt: 0,
            seq: 0,
            deleted: false,
            sortOrder: 999,
          ),
          entry.value,
        ),
      );
    }
    return out;
  }

  bool isNotFound(ShoppingItem i) => i.status == ItemStatus.notFound.index;

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}
