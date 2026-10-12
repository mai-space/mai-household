import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:sqlite3/sqlite3.dart';

import 'connection.dart';
import 'database_key.dart';

/// Öffnet die verschlüsselte App-Datenbank (SQLite3 Multiple Ciphers).
///
/// Gleicher Ansatz wie Mai Doctor Hub und Fitness; zusätzlich wird die
/// unverschlüsselte Bestandsdatenbank vor der einmaligen Umstellung
/// gesichert und bei einem Fehler zurückgespielt (siehe [prepareDatabase]).
DatabaseConnection openAppDatabase({
  DatabaseKeyStore keys = const PlatformDatabaseKeyStore(),
}) {
  return DatabaseConnection.delayed(
    Future(() async {
      // Gleicher Pfad wie bisher (`driftDatabase(name: 'mai_household')`).
      final path = p.join(
        (await getApplicationDocumentsDirectory()).path,
        'mai_household.sqlite',
      );
      final (key, status) = await prepareDatabase(path, keys);
      databaseOpenStatus.value = status;
      return driftDatabase(
        name: 'mai_household',
        native: DriftNativeOptions(
          databasePath: () async => path,
          setup: key == null ? null : (db) => applyKey(db, key),
        ),
      );
    }),
  );
}

/// Setzt den Schlüssel — muss die erste Anweisung auf der Verbindung sein.
void applyKey(CommonDatabase db, String key) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(key)) {
    throw ArgumentError('Ungültiger Datenbankschlüssel');
  }
  db.execute("PRAGMA key = '$key'");
}

/// Pfad der unverschlüsselten Sicherungskopie während der Umstellung.
@visibleForTesting
String migrationBackupPath(String path) => p.join(
  p.dirname(path),
  '${p.basenameWithoutExtension(path)}.vor-verschluesselung.sqlite',
);

/// Verschlüsselt die (unverschlüsselte) Datei unter `path` mit `key`.
typedef DatabaseEncryptor = void Function(String path, String key);

/// Bereitet die Datei unter [path] vor und liefert den Schlüssel:
///
/// - unverschlüsselte Bestandsdatenbank → einmalig nach dem Update
///   verschlüsselt: erst Sicherungskopie, dann an Ort und Stelle
///   verschlüsseln, danach prüfen (Integrität, Zeilen je Tabelle). Scheitert
///   ein Schritt, wird die Kopie zurückgespielt und die App startet dieses
///   Mal unverschlüsselt ([DatabaseOpenStatus.migrationFailed]); beim
///   nächsten Start wird es erneut versucht;
/// - Sicherungskopie liegt noch da (Absturz mitten in der Umstellung) →
///   ist die Datei fertig verschlüsselt, wird die Kopie gelöscht, sonst
///   zurückgespielt und die Umstellung wiederholt;
/// - nicht entschlüsselbar (Schlüssel verloren, fremde Datei) → wird
///   beiseitegelegt, die App startet leer;
/// - Schlüssel nur vorübergehend nicht lesbar → einige Wiederholungen, danach
///   [DatabaseKeyUnavailable] weiterwerfen. Lieber nicht starten als Daten
///   beiseitelegen, die nach einem Neustart wieder lesbar wären.
@visibleForTesting
Future<(String?, DatabaseOpenStatus)> prepareDatabase(
  String path,
  DatabaseKeyStore keys, {
  List<Duration> retryDelays = keyRetryDelays,
  DatabaseEncryptor encrypt = encryptInPlace,
}) async {
  // Abgebrochene Umstellung zuerst aufräumen — die Kopie ist unverschlüsselt
  // und damit unabhängig vom Schlüssel lesbar.
  final backup = File(migrationBackupPath(path));
  String? key;
  String? unreadable;
  try {
    key = await _getKey(keys, retryDelays);
  } on DatabaseKeyLost catch (e) {
    debugPrint('$e');
    if (!backup.existsSync()) unreadable = await _moveAside(path);
    await keys.reset();
    key = await _getKey(keys, retryDelays);
  }
  if (key == null) {
    // Plattform ohne Verschlüsselung: Kopie ggf. zurückspielen, sonst nichts.
    if (backup.existsSync()) _restore(backup.path, path);
    return (null, const DatabaseOpenStatus(encrypted: false));
  }

  if (backup.existsSync()) {
    final file = File(path);
    final done =
        file.existsSync() &&
        file.lengthSync() > 0 &&
        !_isPlaintext(file) &&
        _canOpen(path, key);
    if (done) {
      _deleteFile(backup.path);
    } else {
      _restore(backup.path, path);
    }
  }

  final file = File(path);
  if (file.existsSync() && file.lengthSync() > 0) {
    if (_isPlaintext(file)) {
      if (!_migrate(path, key, encrypt)) {
        return (
          null,
          DatabaseOpenStatus(
            encrypted: false,
            unreadableCopy: unreadable,
            migrationFailed: true,
          ),
        );
      }
    } else if (!_canOpen(path, key)) {
      unreadable = await _moveAside(path);
    }
  }
  return (key, DatabaseOpenStatus(encrypted: true, unreadableCopy: unreadable));
}

/// Wartezeiten zwischen den Versuchen bei [DatabaseKeyUnavailable].
@visibleForTesting
const keyRetryDelays = [
  Duration(milliseconds: 200),
  Duration(milliseconds: 500),
  Duration(seconds: 1),
];

/// [DatabaseKeyLost] geht sofort durch; [DatabaseKeyUnavailable] wird nach
/// jeder Wartezeit erneut versucht und zuletzt weitergeworfen.
Future<String?> _getKey(DatabaseKeyStore keys, List<Duration> delays) async {
  for (var attempt = 0; ; attempt++) {
    try {
      return await keys.getOrCreate();
    } on DatabaseKeyUnavailable catch (e) {
      if (attempt >= delays.length) rethrow;
      debugPrint('$e — neuer Versuch');
      await Future<void>.delayed(delays[attempt]);
    }
  }
}

bool _isPlaintext(File file) {
  final raf = file.openSync();
  try {
    final head = raf.readSync(16);
    return String.fromCharCodes(head) == 'SQLite format 3\u0000';
  } finally {
    raf.closeSync();
  }
}

/// Einmalige Umstellung mit Sicherungskopie; `false` = zurückgerollt.
bool _migrate(String path, String key, DatabaseEncryptor encrypt) {
  final backup = migrationBackupPath(path);
  final Map<String, int> before;
  try {
    // Offenes WAL zuerst in die Hauptdatei übernehmen, damit die Kopie
    // vollständig ist.
    before = _rowCounts(path, checkpoint: true);
    _copyDurably(path, backup);
  } catch (e) {
    // Noch nichts verändert: Original bleibt, halbe Kopie weg.
    debugPrint('Sicherungskopie vor der Verschlüsselung gescheitert: $e');
    _deleteFile(backup);
    _deleteFile('$backup.tmp');
    return false;
  }
  try {
    encrypt(path, key);
    if (_isPlaintext(File(path))) {
      throw StateError('Datei ist weiterhin unverschlüsselt');
    }
    final after = _rowCounts(path, key: key, integrity: true);
    if (!mapEquals(before, after)) {
      throw StateError('Inhalt weicht ab: $before ≠ $after');
    }
  } catch (e) {
    debugPrint('Verschlüsselung gescheitert, Kopie wird zurückgespielt: $e');
    _restore(backup, path);
    return false;
  }
  _deleteFile(backup);
  return true;
}

/// Verschlüsselt an Ort und Stelle (`PRAGMA rekey`).
@visibleForTesting
void encryptInPlace(String path, String key) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(key)) {
    throw ArgumentError('Ungültiger Datenbankschlüssel');
  }
  final db = sqlite3.open(path);
  try {
    db.execute('PRAGMA wal_checkpoint(TRUNCATE)');
    db.execute("PRAGMA rekey = '$key'");
  } finally {
    db.close();
  }
}

/// Zeilen je Tabelle; mit [integrity] zusätzlich `PRAGMA integrity_check`.
Map<String, int> _rowCounts(
  String path, {
  String? key,
  bool checkpoint = false,
  bool integrity = false,
}) {
  final db = sqlite3.open(path);
  try {
    if (key != null) applyKey(db, key);
    if (checkpoint) db.execute('PRAGMA wal_checkpoint(TRUNCATE)');
    if (integrity) {
      final result = db.select('PRAGMA integrity_check');
      if (result.length != 1 || result.first.values.first != 'ok') {
        throw StateError('integrity_check: ${result.rows}');
      }
    }
    final tables = db.select(
      "SELECT name FROM sqlite_master WHERE type = 'table' "
      "AND name NOT LIKE 'sqlite_%' ORDER BY name",
    );
    return {
      for (final row in tables)
        row['name'] as String:
            db
                    .select(
                      'SELECT count(*) AS n FROM '
                      '"${(row['name'] as String).replaceAll('"', '""')}"',
                    )
                    .first['n']
                as int,
    };
  } finally {
    db.close();
  }
}

/// Kopiert vollständig auf den Datenträger und benennt dann atomar um —
/// ein Absturz hinterlässt keine halbe Kopie unter dem endgültigen Namen.
void _copyDurably(String from, String to) {
  final tmp = '$to.tmp';
  File(from).copySync(tmp);
  final raf = File(tmp).openSync(mode: FileMode.append);
  try {
    raf.flushSync();
  } finally {
    raf.closeSync();
  }
  File(tmp).renameSync(to);
}

/// Spielt die Sicherungskopie zurück; die Kopie wird erst danach gelöscht.
void _restore(String backup, String path) {
  for (final suffix in ['-wal', '-shm', '-journal']) {
    _deleteFile('$path$suffix');
  }
  _copyDurably(backup, path);
  _deleteFile(backup);
}

void _deleteFile(String path) {
  final file = File(path);
  if (file.existsSync()) file.deleteSync();
}

bool _canOpen(String path, String key) {
  final db = sqlite3.open(path);
  try {
    applyKey(db, key);
    db.select('SELECT count(*) FROM sqlite_master');
    return true;
  } on SqliteException {
    return false;
  } finally {
    db.close();
  }
}

/// Benennt die Datei (samt -wal/-journal) um; liefert den neuen Pfad.
Future<String?> _moveAside(String path) async {
  final file = File(path);
  if (!await file.exists()) return null;
  final stamp = DateTime.now().millisecondsSinceEpoch;
  final target = p.join(
    p.dirname(path),
    '${p.basenameWithoutExtension(path)}.unlesbar-$stamp.sqlite',
  );
  await file.rename(target);
  for (final suffix in ['-wal', '-shm', '-journal']) {
    final extra = File('$path$suffix');
    if (await extra.exists()) await extra.delete();
  }
  return target;
}
