import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_household/data/app_database.dart';
import 'package:mai_household/data/connection/connection.dart';
import 'package:mai_household/data/connection/connection_io.dart';
import 'package:mai_household/data/connection/database_key.dart';
import 'package:mai_household/data/data_context.dart';
import 'package:mai_household/data/seed.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

const _keyA =
    '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';
const _keyB =
    'ffeeddccbbaa99887766554433221100ffeeddccbbaa99887766554433221100';

class FakeKeys implements DatabaseKeyStore {
  FakeKeys(this.key, {this.lost = false, this.unavailable = 0});

  String? key;
  bool lost;

  /// So viele Aufrufe scheitern vorübergehend, bevor es klappt.
  int unavailable;
  int resets = 0;
  int calls = 0;

  @override
  Future<String?> getOrCreate() async {
    calls++;
    if (unavailable > 0) {
      unavailable--;
      throw const DatabaseKeyUnavailable('Keystore belegt');
    }
    if (lost) throw const DatabaseKeyLost('weg');
    return key;
  }

  @override
  Future<void> reset() async {
    resets++;
    lost = false;
    key = _keyB;
  }
}

AppDatabase openPlain(String path) => AppDatabase(NativeDatabase(File(path)));

AppDatabase openEncrypted(String path, String key) =>
    AppDatabase(NativeDatabase(File(path), setup: (db) => applyKey(db, key)));

bool isPlaintext(String path) =>
    String.fromCharCodes(File(path).readAsBytesSync().take(15)) ==
    'SQLite format 3';

/// Datenbank wie aus einer früheren Version: eingebaute Einträge + Notiz.
Future<void> writeData(AppDatabase db, String note) async {
  final ctx = DataContext(db);
  await ctx.load();
  await seedBuiltins(ctx);
  await ctx.setSetting('note', note);
  await db.close();
}

Future<String?> readNote(AppDatabase db) async {
  final ctx = DataContext(db);
  await ctx.load();
  final note = await ctx.setting('note');
  await db.close();
  return note;
}

Future<int> departmentCount(AppDatabase db) async {
  final n = await db.departments.count().getSingle();
  await db.close();
  return n;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory dir;
  late String path;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('db_crypt');
    path = '${dir.path}/mai_household.sqlite';
  });
  tearDown(() => dir.deleteSync(recursive: true));

  List<String> leftovers() => dir
      .listSync()
      .map((f) => f.path.split('/').last)
      .where((n) => n.contains('vor-verschluesselung') || n.endsWith('.tmp'))
      .toList();

  test('fresh install: new database is encrypted', () async {
    final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
    expect(key, _keyA);
    expect(status.encrypted, isTrue);
    expect(status.migrationFailed, isFalse);
    expect(status.unreadableCopy, isNull);

    await writeData(openEncrypted(path, key!), 'Geheime Milch');

    expect(isPlaintext(path), isFalse);
    expect(
      File(path).readAsStringSync(encoding: latin1),
      isNot(contains('Geheime')),
    );
    final raw = sqlite.sqlite3.open(path);
    expect(() => raw.select('SELECT * FROM local_settings'), throwsA(anything));
    raw.close();

    expect(await readNote(openEncrypted(path, _keyA)), 'Geheime Milch');
  });

  test('existing plaintext database is migrated, backup removed', () async {
    await writeData(openPlain(path), 'aus Version 1');
    final departments = await departmentCount(openPlain(path));
    expect(isPlaintext(path), isTrue);

    final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
    expect(status.encrypted, isTrue);
    expect(status.migrationFailed, isFalse);
    expect(status.unreadableCopy, isNull);
    expect(isPlaintext(path), isFalse);
    expect(
      File(path).readAsStringSync(encoding: latin1),
      isNot(contains('Version 1')),
    );
    // Unverschlüsselte Kopie bleibt nicht liegen.
    expect(leftovers(), isEmpty);

    expect(await readNote(openEncrypted(path, key!)), 'aus Version 1');
    expect(await departmentCount(openEncrypted(path, key)), departments);

    // Zweiter Start: nichts mehr zu tun.
    final before = File(path).readAsBytesSync();
    final (again, _) = await prepareDatabase(path, FakeKeys(_keyA));
    expect(again, _keyA);
    expect(File(path).readAsBytesSync(), before);
  });

  group('failed migration rolls back', () {
    Future<List<int>> seedPlain() async {
      await writeData(openPlain(path), 'bleibt lesbar');
      return File(path).readAsBytesSync();
    }

    Future<void> expectRolledBack(
      List<int> before,
      (String?, DatabaseOpenStatus) result,
    ) async {
      final (key, status) = result;
      expect(key, isNull);
      expect(status.encrypted, isFalse);
      expect(status.migrationFailed, isTrue);
      expect(isPlaintext(path), isTrue);
      expect(File(path).readAsBytesSync(), before);
      expect(leftovers(), isEmpty);
      // Die App öffnet die Daten dieses Mal unverschlüsselt.
      expect(await readNote(openPlain(path)), 'bleibt lesbar');
    }

    test('encryption throws', () async {
      final before = await seedPlain();
      final result = await prepareDatabase(
        path,
        FakeKeys(_keyA),
        encrypt: (_, _) => throw StateError('Datenträger voll'),
      );
      await expectRolledBack(before, result);
    });

    test('encrypted file is damaged', () async {
      final before = await seedPlain();
      final result = await prepareDatabase(
        path,
        FakeKeys(_keyA),
        encrypt: (p, k) {
          encryptInPlace(p, k);
          final bytes = File(p).readAsBytesSync();
          File(p).writeAsBytesSync(bytes.sublist(0, bytes.length ~/ 2));
        },
      );
      await expectRolledBack(before, result);
    });

    test('encryption silently does nothing', () async {
      final before = await seedPlain();
      final result = await prepareDatabase(
        path,
        FakeKeys(_keyA),
        encrypt: (_, _) {},
      );
      await expectRolledBack(before, result);
    });

    test('next start retries and succeeds', () async {
      await seedPlain();
      await prepareDatabase(
        path,
        FakeKeys(_keyA),
        encrypt: (_, _) => throw StateError('einmalig'),
      );
      final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
      expect(key, _keyA);
      expect(status.migrationFailed, isFalse);
      expect(isPlaintext(path), isFalse);
      expect(await readNote(openEncrypted(path, key!)), 'bleibt lesbar');
    });
  });

  group('interrupted migration (crash)', () {
    test('half-encrypted file: backup is restored and migrated', () async {
      await writeData(openPlain(path), 'vor dem Absturz');
      File(path).copySync(migrationBackupPath(path));
      // Absturz mitten im Verschlüsseln: Datei unbrauchbar.
      final bytes = File(path).readAsBytesSync();
      File(path).writeAsBytesSync(bytes.sublist(0, 100));

      final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
      expect(key, _keyA);
      expect(status.unreadableCopy, isNull);
      expect(isPlaintext(path), isFalse);
      expect(leftovers(), isEmpty);
      expect(await readNote(openEncrypted(path, key!)), 'vor dem Absturz');
    });

    test('finished but backup left over: backup is deleted', () async {
      await writeData(openPlain(path), 'fertig');
      File(path).copySync(migrationBackupPath(path));
      encryptInPlace(path, _keyA);

      final (key, _) = await prepareDatabase(path, FakeKeys(_keyA));
      expect(leftovers(), isEmpty);
      expect(await readNote(openEncrypted(path, key!)), 'fertig');
    });
  });

  test('database with a foreign key is moved aside', () async {
    await writeData(openEncrypted(path, _keyB), 'fremd');

    final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
    expect(key, _keyA);
    expect(File(path).existsSync(), isFalse);
    expect(File(status.unreadableCopy!).existsSync(), isTrue);
  });

  test('lost keystore key: data moved aside, new key issued', () async {
    await writeData(openEncrypted(path, _keyA), 'alt');

    final keys = FakeKeys(_keyA, lost: true);
    final (key, status) = await prepareDatabase(path, keys);
    expect(keys.resets, 1);
    expect(key, _keyB);
    expect(status.unreadableCopy, isNotNull);
    expect(File(path).existsSync(), isFalse);
  });

  test('platform without encryption leaves the database alone', () async {
    await writeData(openPlain(path), 'iOS');
    final before = File(path).readAsBytesSync();
    final (key, status) = await prepareDatabase(path, FakeKeys(null));
    expect(key, isNull);
    expect(status.encrypted, isFalse);
    expect(File(path).readAsBytesSync(), before);
  });

  group('transient key errors', () {
    const noDelay = [Duration.zero, Duration.zero, Duration.zero];

    test('retry succeeds: nothing moved aside, no reset', () async {
      await writeData(openEncrypted(path, _keyA), 'bleibt');
      final before = File(path).readAsBytesSync();
      final keys = FakeKeys(_keyA, unavailable: 2);

      final (key, status) = await prepareDatabase(
        path,
        keys,
        retryDelays: noDelay,
      );
      expect(keys.calls, 3);
      expect(keys.resets, 0);
      expect(key, _keyA);
      expect(status.unreadableCopy, isNull);
      expect(File(path).readAsBytesSync(), before);
    });

    test('persistent error: throws, plaintext database untouched', () async {
      await writeData(openPlain(path), 'bleibt');
      final before = File(path).readAsBytesSync();
      final keys = FakeKeys(_keyA, unavailable: 99);

      await expectLater(
        prepareDatabase(path, keys, retryDelays: noDelay),
        throwsA(isA<DatabaseKeyUnavailable>()),
      );
      expect(keys.resets, 0);
      expect(File(path).readAsBytesSync(), before);
      expect(dir.listSync(), hasLength(1));
    });
  });
}
