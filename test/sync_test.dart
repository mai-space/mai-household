import 'package:flutter_test/flutter_test.dart';
import 'package:mai_household/data/data_context.dart';
import 'package:mai_household/data/repositories/shopping_repository.dart';
import 'package:mai_household/domain/shopping/departments.dart';
import 'package:mai_household/domain/shopping/store_order.dart';
import 'package:mai_household/domain/shopping/voice_parser.dart';
import 'package:mai_household/sync/invite.dart';
import 'package:mai_household/sync/sync_crypto.dart';
import 'package:mai_household/sync/sync_engine.dart';
import 'package:mai_household/sync/sync_service.dart';

import 'helpers.dart';

Future<void> exchange(DataContext a, DataContext b) async {
  await SyncEngine(b).import(await SyncEngine(a).exportSince(0));
  await SyncEngine(a).import(await SyncEngine(b).exportSince(0));
}

void main() {
  test('zwei Geräte laufen zusammen, ohne Doppelte', () async {
    final a = await testContext(name: 'Lena');
    final b = await testContext(name: 'Tom');
    await ShoppingRepository(a).addItems([const ParsedItem(name: 'Milch')]);
    await ShoppingRepository(b).addItems([const ParsedItem(name: 'Brot')]);

    await exchange(a, b);

    for (final ctx in [a, b]) {
      final items = await ShoppingRepository(ctx).openItems();
      expect(items.map((i) => i.name).toSet(), {'Milch', 'Brot'});
      final deps = await ctx.db.select(ctx.db.departments).get();
      expect(deps, hasLength(BuiltinDepartment.values.length));
      final members = await ctx.db.select(ctx.db.members).get();
      expect(members.map((m) => m.name).toSet(), {'Lena', 'Tom'});
    }
  });

  test('spätere Änderung gewinnt, Löschungen kommen an', () async {
    final a = await testContext();
    final b = await testContext();
    final repoA = ShoppingRepository(a);
    final repoB = ShoppingRepository(b);
    await repoA.addItems([const ParsedItem(name: 'Eier')]);
    await exchange(a, b);

    final onB = (await repoB.openItems()).single;
    await repoB.setStatus(onB, ItemStatus.done, storeId: 'store-aldi');
    await exchange(a, b);
    expect(await repoA.openItems(), isEmpty);

    // Erneut aufmachen auf A (später) gewinnt gegen den Stand von B.
    final doneOnA = (await (a.db.select(a.db.shoppingItems)).get()).single;
    await repoA.setStatus(doneOnA, ItemStatus.open);
    await exchange(a, b);
    expect((await repoB.openItems()).single.name, 'Eier');

    await repoB.delete((await repoB.openItems()).single);
    await exchange(a, b);
    expect(await repoA.openItems(), isEmpty);
  });

  test('übernommene Zeilen werden an Dritte weitergereicht', () async {
    final a = await testContext();
    final b = await testContext();
    final c = await testContext();
    await ShoppingRepository(a).addItems([const ParsedItem(name: 'Käse')]);
    await exchange(a, b);
    // C kennt nur B; fragt ab B's Stand vor A's Zeilen.
    await SyncEngine(c).import(await SyncEngine(b).exportSince(0));
    expect((await ShoppingRepository(c).openItems()).single.name, 'Käse');
  });

  test('Import ist idempotent (keine Endlosschleife)', () async {
    final a = await testContext();
    final b = await testContext();
    await ShoppingRepository(a).addItems([const ParsedItem(name: 'Salz')]);
    await exchange(a, b);
    final seq = b.currentSeq;
    final again = await SyncEngine(b).import(await SyncEngine(a).exportSince(0));
    expect(again, 0);
    expect(b.currentSeq, seq);
  });

  test('Abteilung umsortieren wird gelernt und geteilt', () async {
    final a = await testContext();
    final b = await testContext();
    final repoA = ShoppingRepository(a);
    await repoA.addItems([const ParsedItem(name: 'Hafermilch')]);
    final item = (await repoA.openItems()).single;
    expect(item.departmentId, BuiltinDepartment.dairy.id);
    await repoA.moveToDepartment(item, BuiltinDepartment.drinks.id);
    await exchange(a, b);
    await ShoppingRepository(
      b,
    ).addItems([const ParsedItem(name: 'hafermilch')]);
    // Steht schon offen → zusammengeführt statt doppelt.
    final onB = await ShoppingRepository(b).openItems();
    expect(onB, hasLength(1));
    expect(await ShoppingRepository(b).classify('Hafermilch'),
        BuiltinDepartment.drinks.id);
  });

  test('Gleiche Artikel werden zusammengeführt, Undo stellt her', () async {
    final ctx = await testContext();
    final repo = ShoppingRepository(ctx);
    await repo.addItems([const ParsedItem(name: 'Milch', amount: 1, unit: 'l')]);
    final r = await repo.addItems([
      const ParsedItem(name: 'milch', amount: 2, unit: 'l'),
      const ParsedItem(name: 'Butter'),
    ]);
    var items = await repo.openItems();
    expect(items, hasLength(2));
    expect(items.firstWhere((i) => i.name == 'Milch').amount, 3);
    await repo.undoAdd(r);
    items = await repo.openItems();
    expect(items.single.amount, 1);
  });

  test('Gang-Reihenfolge lernt über zwei, drei Einkäufe', () {
    List<String> order(Map<String, double> m) =>
        m.keys.toList()..sort((x, y) => m[x]!.compareTo(m[y]!));
    var positions = {'a': 0.0, 'b': 1.0, 'c': 2.0, 'd': 3.0};
    positions = StoreOrderLearner.learn(positions, ['c', 'a', 'b']);
    // Nach einem Einkauf: c schon vor b, aber noch nicht ganz vorn.
    expect(order(positions), ['a', 'c', 'b', 'd']);
    positions = StoreOrderLearner.learn(positions, ['c', 'a', 'b']);
    expect(order(positions), ['c', 'a', 'b', 'd']);
  });

  test('Verschlüsselung: falscher Schlüssel wird abgewiesen', () async {
    final k1 = SyncCrypto(SyncCrypto.newKey());
    final k2 = SyncCrypto(SyncCrypto.newKey());
    final sealed = await k1.seal({'x': 1});
    expect((await k1.open(sealed))['x'], 1);
    expect(() => k2.open(sealed), throwsA(isA<SyncAuthException>()));
  });

  test('Einladung: kodieren und lesen', () {
    final key = SyncCrypto.encodeKey(SyncCrypto.newKey());
    final invite = Invite(
      householdId: 'h1',
      key: key,
      deviceId: 'd1',
      name: 'Lena & Tom',
      addresses: const ['192.168.0.5:47232'],
    );
    final parsed = Invite.tryParse(invite.encode())!;
    expect(parsed.key, key);
    expect(parsed.name, 'Lena & Tom');
    expect(parsed.addresses, ['192.168.0.5:47232']);
    expect(Invite.tryParse('https://example.com'), isNull);
  });

  test('Abgleich über HTTP (localhost) mit Einladung', () async {
    final a = await testContext(name: 'Lena');
    final b = await testContext(name: 'Tom');
    await ShoppingRepository(a).addItems([const ParsedItem(name: 'Honig')]);
    await ShoppingRepository(b).addItems([const ParsedItem(name: 'Senf')]);
    final serviceA = SyncService(a);
    final serviceB = SyncService(b);
    addTearDown(serviceA.dispose);
    addTearDown(serviceB.dispose);

    final invite = await serviceA.createInvite();
    final local = Invite(
      householdId: invite.householdId,
      key: invite.key,
      deviceId: invite.deviceId,
      name: invite.name,
      addresses: ['127.0.0.1:${serviceA.port}'],
    );
    final reached = await serviceB.join(local, keepMine: true);
    expect(reached, isTrue);
    for (final ctx in [a, b]) {
      final names = (await ShoppingRepository(ctx).openItems())
          .map((i) => i.name)
          .toSet();
      expect(names, {'Honig', 'Senf'});
    }

    // Folgeabgleich überträgt nur Neues.
    await ShoppingRepository(a).addItems([const ParsedItem(name: 'Tee')]);
    final changed = await serviceB.syncWith(
      '127.0.0.1',
      serviceA.port!,
      deviceId: a.deviceId,
    );
    expect(changed, 1);
    final peers = await b.db.select(b.db.peers).get();
    expect(peers.single.name, 'Lena');
    expect(peers.single.theirSeq, greaterThan(0));
  });

  test('Beitritt ohne eigene Daten verwirft lokale Einträge', () async {
    final a = await testContext();
    final b = await testContext();
    await ShoppingRepository(b).addItems([const ParsedItem(name: 'Alt')]);
    final serviceA = SyncService(a);
    final serviceB = SyncService(b);
    addTearDown(serviceA.dispose);
    addTearDown(serviceB.dispose);
    final invite = await serviceA.createInvite();
    await serviceB.join(
      Invite(
        householdId: invite.householdId,
        key: invite.key,
        deviceId: invite.deviceId,
        name: invite.name,
        addresses: ['127.0.0.1:${serviceA.port}'],
      ),
      keepMine: false,
    );
    expect(await ShoppingRepository(b).openItems(), isEmpty);
    final deps = await (b.db.select(b.db.departments)
          ..where((t) => t.deleted.equals(false)))
        .get();
    expect(deps, isNotEmpty);
  });
}
