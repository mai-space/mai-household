import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:mai_household/data/app_database.dart';
import 'package:mai_household/data/connection/connection_io.dart';
import 'package:mai_household/data/data_context.dart';
import 'package:mai_household/data/repositories/shopping_repository.dart';
import 'package:mai_household/data/seed.dart';
import 'package:mai_household/domain/shopping/voice_parser.dart';
import 'package:mai_household/services/backup_service.dart';
import 'package:mai_household/sync/sync_engine.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'helpers.dart';

const _keyA =
    '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';
const _keyB =
    'ffeeddccbbaa99887766554433221100ffeeddccbbaa99887766554433221100';

void main() {
  late Directory tmp;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('backup_');
  });
  tearDown(() async {
    await tmp.delete(recursive: true);
  });

  BackupService serviceFor(DataContext ctx) =>
      BackupService(ctx, tempDir: () async => tmp, iterations: 1000);

  Future<Set<String>> openNames(DataContext ctx) async =>
      (await ShoppingRepository(ctx).openItems()).map((i) => i.name).toSet();

  test('Sicherung → alles ändern → Wiederherstellen bringt Daten zurück', () async {
    final ctx = await testContext(name: 'Alex');
    final repo = ShoppingRepository(ctx);
    await repo.addItems([const ParsedItem(name: 'Haferflocken')]);
    await ctx.setSetting(SettingKeys.summaryMinutes, '450');
    final service = serviceFor(ctx);

    final file = await service.createBackupFile('geheim123');
    expect(file.path, endsWith('.maihh'));
    final bytes = await file.readAsBytes();
    expect(String.fromCharCodes(bytes), isNot(contains('Haferflocken')));
    expect(BackupCrypto.looksLikeBackup(bytes), isTrue);

    await repo.delete((await repo.openItems()).single);
    await repo.addItems([const ParsedItem(name: 'Kaffee')]);
    await ctx.setSetting(SettingKeys.summaryMinutes, '600');

    await service.restoreFile(file.path, 'geheim123');
    expect(await openNames(ctx), {'Haferflocken'});
    expect(await ctx.setting(SettingKeys.summaryMinutes), '450');
    expect(tmp.listSync().whereType<Directory>(), isEmpty);
    await ctx.db.close();
  });

  test('neues Gerät übernimmt Person und Haushalt, behält eigene Geräte-ID', () async {
    final old = await testContext(name: 'Alex');
    await ShoppingRepository(old).addItems([const ParsedItem(name: 'Reis')]);
    await old.setSetting(SettingKeys.householdKey, 'c2NobMO8c3NlbA==');
    await old.setSetting(SettingKeys.onboarded, '1');
    await old.db
        .into(old.db.peers)
        .insert(PeersCompanion.insert(deviceId: 'partner', name: 'Sam'));
    final file = await serviceFor(old).createBackupFile('geheim123');

    // Frisch installiert: noch nicht eingerichtet, eigene IDs.
    final fresh = DataContext(AppDatabase(NativeDatabase.memory()));
    await fresh.load();
    final newDevice = fresh.deviceId;
    await serviceFor(fresh).restoreFile(file.path, 'geheim123');

    expect(fresh.deviceId, newDevice);
    expect(await fresh.setting(SettingKeys.deviceId), newDevice);
    expect(fresh.memberId, old.memberId);
    expect(
      await fresh.setting(SettingKeys.householdId),
      await old.setting(SettingKeys.householdId),
    );
    expect(await fresh.setting(SettingKeys.householdKey), 'c2NobMO8c3NlbA==');
    expect(await fresh.setting(SettingKeys.onboarded), '1');
    // Sync-Stand beginnt neu → vollständiger Abgleich mit dem Partner.
    expect(await fresh.db.select(fresh.db.peers).get(), isEmpty);
    expect(await openNames(fresh), {'Reis'});
    await old.db.close();
    await fresh.db.close();
  });

  test('Partner bekommen nach dem Wiederherstellen alles mit', () async {
    final a = await testContext(name: 'Alex');
    final b = await testContext(name: 'Sam');
    await ShoppingRepository(a).addItems([const ParsedItem(name: 'Milch')]);
    final file = await serviceFor(a).createBackupFile('geheim123');
    for (var i = 0; i < 5; i++) {
      await ShoppingRepository(a).addItems([ParsedItem(name: 'Extra $i')]);
    }
    // B kennt A bis zum heutigen Stand.
    await SyncEngine(b).import(await SyncEngine(a).exportSince(0));
    final seenByB = a.currentSeq;

    await serviceFor(a).restoreFile(file.path, 'geheim123');
    expect(a.currentSeq, greaterThan(seenByB));
    await ShoppingRepository(a).addItems([const ParsedItem(name: 'Brot')]);

    final batch = await SyncEngine(a).exportSince(seenByB);
    final names = {for (final r in batch['shopping_items']!) r['name']};
    expect(names, containsAll(['Milch', 'Brot']));
    await SyncEngine(b).import(batch);
    expect(await openNames(b), containsAll(['Milch', 'Brot']));
    await a.db.close();
    await b.db.close();
  });

  test('verschlüsselte Datenbank: Sicherung ist geräteunabhängig', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    Future<DataContext> open(String name, String key) async {
      final db = AppDatabase(
        NativeDatabase(
          File('${tmp.path}/$name.sqlite'),
          setup: (db) => applyKey(db, key),
        ),
      );
      final ctx = DataContext(db);
      await ctx.load();
      return ctx;
    }

    final phone = await open('alt', _keyA);
    await seedBuiltins(phone);
    await ShoppingRepository(phone).addItems([const ParsedItem(name: 'Äpfel')]);
    final file = await serviceFor(phone).createBackupFile('geheim123');
    await phone.db.close();

    final other = await open('neu', _keyB);
    await serviceFor(other).restoreFile(file.path, 'geheim123');
    expect(await openNames(other), {'Äpfel'});
    await other.db.close();
    // Die Datenbank auf dem Gerät bleibt verschlüsselt.
    final head = File('${tmp.path}/neu.sqlite').readAsBytesSync().take(15);
    expect(String.fromCharCodes(head), isNot('SQLite format 3'));
    expect(
      tmp.listSync().where((e) => e.path.endsWith('.vor-verschluesselung.sqlite')),
      isEmpty,
    );
  });

  test('falsches Passwort lässt Daten unverändert', () async {
    final ctx = await testContext();
    final service = serviceFor(ctx);
    final file = await service.createBackupFile('geheim123');
    await ShoppingRepository(ctx).addItems([const ParsedItem(name: 'Tee')]);
    await expectLater(
      service.restoreFile(file.path, 'falsch!!!'),
      throwsA(isA<BackupException>()),
    );
    expect(await openNames(ctx), {'Tee'});
    await ctx.db.close();
  });

  test('zu kurze Passwörter werden abgelehnt', () async {
    final ctx = await testContext();
    await expectLater(
      serviceFor(ctx).createBackupFile('kurz'),
      throwsA(isA<BackupException>()),
    );
    await ctx.db.close();
  });

  test('Sicherungen anderer Mai-Apps werden abgelehnt', () async {
    final ctx = await testContext();
    final foreign = File('${tmp.path}/fitness.maifit');
    await foreign.writeAsBytes(
      await BackupCrypto.encrypt(
        BackupArchive.build(
          database: Uint8List(0),
          manifest: {'app': 'mai_fitness', 'schemaVersion': 1},
        ),
        'geheim123',
        iterations: 1000,
      ),
    );
    await expectLater(
      serviceFor(ctx).restoreFile(foreign.path, 'geheim123'),
      throwsA(isA<BackupException>()),
    );
    await ctx.db.close();
  });

  test('Sicherungen aus neuerem Schema werden abgelehnt', () async {
    final ctx = await testContext();
    final snapshot = '${tmp.path}/newer.sqlite';
    await ctx.db.customStatement('VACUUM INTO ?', [snapshot]);
    sqlite.sqlite3.open(snapshot)
      ..execute('PRAGMA user_version = 99')
      ..close();
    final file = File('${tmp.path}/newer.maihh');
    await file.writeAsBytes(
      await BackupCrypto.encrypt(
        BackupArchive.build(
          database: await File(snapshot).readAsBytes(),
          manifest: {'app': backupAppId, 'schemaVersion': 99},
        ),
        'geheim123',
        iterations: 1000,
      ),
    );
    await expectLater(
      serviceFor(ctx).restoreFile(file.path, 'geheim123'),
      throwsA(isA<BackupException>()),
    );
    await ctx.db.close();
  });
}
