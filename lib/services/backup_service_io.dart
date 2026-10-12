import 'dart:io';
import 'dart:isolate';

import 'package:drift/native.dart';
import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../data/app_database.dart';
import '../data/data_context.dart';
import '../l10n/l10n.dart';

export 'package:mai_backup_format/mai_backup_format.dart'
    show BackupException, BackupCrypto;

const backupSupported = true;

/// Kennung im Manifest — Sicherungen anderer Mai-Apps werden abgelehnt.
const backupAppId = 'mai_household';

/// Verschlüsselte Komplettsicherung des Haushalts (`.maihh`).
///
/// Format wie Mai Doctor Hub und Fitness: AES-256-GCM, Schlüssel per PBKDF2
/// aus dem Sicherungspasswort, Inhalt = ZIP mit unverschlüsseltem
/// SQLite-Snapshot und Manifest. Die Datenbank auf dem Gerät bleibt
/// verschlüsselt; der Snapshot entsteht nur im Temp-Ordner und wird sofort
/// wieder gelöscht. Ältere Schemaversionen werden beim Restore migriert.
///
/// Beim Wiederherstellen bleibt die Geräte-ID dieses Geräts erhalten; alle
/// geteilten Zeilen bekommen neue lokale `seq`-Nummern und der Sync-Stand
/// (`peers`) beginnt neu. So gleicht sich das Gerät danach vollständig mit
/// dem Haushalt ab — die jeweils neuere Änderung gewinnt wie gewohnt.
class BackupService {
  BackupService(
    this._ctx, {
    Future<Directory> Function()? tempDir,
    this.iterations = BackupCrypto.defaultIterations,
  }) : _tempDir = tempDir ?? getTemporaryDirectory;

  final DataContext _ctx;
  final Future<Directory> Function() _tempDir;

  /// PBKDF2-Runden; in Tests reduziert.
  final int iterations;

  AppDatabase get _db => _ctx.db;

  static String suggestedFileName(DateTime now) =>
      'mai-household-${now.year}-${_two(now.month)}-${_two(now.day)}.maihh';

  /// Schreibt die verschlüsselte Sicherung in den Temp-Ordner. Aufrufer
  /// teilt die Datei und löscht sie danach.
  Future<File> createBackupFile(String passphrase) async {
    if (passphrase.length < BackupCrypto.minPassphraseLength) {
      throw BackupException(AppLocale.strings.backupPassphraseTooShort);
    }
    final work = await _workDir();
    try {
      final snapshot = p.join(work.path, 'db.sqlite');
      // Konsistente Kopie, auch während die App die DB offen hat.
      await _db.customStatement('VACUUM INTO ?', [snapshot]);
      // Die Kopie trägt den Geräteschlüssel → entschlüsseln; geschützt wird
      // sie danach durch das Sicherungspasswort (geräteunabhängig).
      await _db.customStatement('ATTACH DATABASE ? AS snap', [snapshot]);
      try {
        await _db.customStatement("PRAGMA snap.rekey = ''");
      } finally {
        await _db.customStatement('DETACH DATABASE snap');
      }
      final database = await File(snapshot).readAsBytes();
      final manifest = <String, Object?>{
        'app': backupAppId,
        'format': 1,
        'schemaVersion': _db.schemaVersion,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      };
      final rounds = iterations;
      final sealed = await Isolate.run(
        () => BackupCrypto.encrypt(
          BackupArchive.build(database: database, manifest: manifest),
          passphrase,
          iterations: rounds,
        ),
      );
      final out = File(
        p.join(
          (await _tempDir()).path,
          'export_${DateTime.now().microsecondsSinceEpoch}.maihh',
        ),
      );
      await out.writeAsBytes(sealed, flush: true);
      return out;
    } finally {
      await work.delete(recursive: true);
    }
  }

  /// Ersetzt **alle** Daten durch den Inhalt der Sicherung unter [path];
  /// liefert den Zeitpunkt der Sicherung.
  Future<DateTime> restoreFile(String path, String passphrase) async {
    final sealed = await File(path).readAsBytes();
    final contents = await Isolate.run(
      () => BackupArchive.open(sealed, passphrase),
    );
    final strings = AppLocale.strings;
    if (contents.app != backupAppId) {
      throw BackupException(strings.backupWrongApp);
    }
    final work = await _workDir();
    try {
      final restorePath = p.join(work.path, 'restore.sqlite');
      await File(restorePath).writeAsBytes(contents.database, flush: true);
      await _migrateSnapshot(restorePath);
      await _replaceData(restorePath);
      // Personen-ID, Zähler und Uhr aus den neuen Daten übernehmen.
      await _ctx.load();
      return contents.createdAt ?? DateTime.now();
    } finally {
      await work.delete(recursive: true);
    }
  }

  /// Bringt eine ältere Sicherung auf das aktuelle Schema; lehnt neuere ab.
  Future<void> _migrateSnapshot(String path) async {
    final raw = sqlite.sqlite3.open(path);
    final int version;
    try {
      version = raw.userVersion;
    } finally {
      raw.close();
    }
    if (version > _db.schemaVersion) {
      throw BackupException(AppLocale.strings.backupTooNew);
    }
    final snapshot = AppDatabase(NativeDatabase(File(path)));
    try {
      await snapshot.customSelect('SELECT 1').get(); // öffnet + migriert
    } finally {
      await snapshot.close();
    }
  }

  Future<void> _replaceData(String restorePath) async {
    final tables = _db.allTables.toList();
    final shared = AppDatabase.syncTableNames.toSet();
    // Alle wiederhergestellten Zeilen liegen danach über dem bisherigen
    // Zähler — auch Partner, die schon viel von uns haben, holen sie ab.
    final base = _ctx.currentSeq;
    final previous = {
      for (final key in _keptSettings) key: await _ctx.setting(key),
    };
    // KEY '': Sicherungs-DB ist unverschlüsselt (sonst gälte der Geräteschlüssel).
    await _db.customStatement("ATTACH DATABASE ? AS bk KEY ''", [
      restorePath,
    ]);
    try {
      await _db.transaction(() async {
        for (final table in tables) {
          final name = table.actualTableName;
          final columns = table.$columns.map((c) => '"${c.name}"').join(', ');
          if (shared.contains(name)) {
            await _db.customStatement('DELETE FROM main."$name"');
            await _db.customStatement(
              'INSERT INTO main."$name" ($columns) '
              'SELECT $columns FROM bk."$name"',
            );
            await _db.customStatement(
              'UPDATE main."$name" SET seq = seq + ?',
              [base],
            );
          } else if (name == 'local_settings') {
            // Die Geräte-ID gehört zu diesem Gerät, nicht zur Sicherung.
            await _db.customStatement(
              'DELETE FROM main.local_settings WHERE key <> ?',
              [SettingKeys.deviceId],
            );
            await _db.customStatement(
              'INSERT INTO main.local_settings ($columns) '
              'SELECT $columns FROM bk.local_settings WHERE key <> ?',
              [SettingKeys.deviceId],
            );
          } else if (name == 'peers') {
            // Sync-Stand neu beginnen: alles einmal vollständig abgleichen.
            await _db.customStatement('DELETE FROM main.peers');
          }
        }
        // Fehlt etwas Unverzichtbares in der Sicherung, das Bisherige behalten.
        for (final MapEntry(:key, :value) in previous.entries) {
          if (value == null) continue;
          await _db.customStatement(
            'INSERT OR IGNORE INTO main.local_settings (key, value) '
            'VALUES (?, ?)',
            [key, value],
          );
        }
      });
    } finally {
      await _db.customStatement('DETACH DATABASE bk');
    }
    _db.markTablesUpdated(tables);
  }

  static const _keptSettings = [
    SettingKeys.memberId,
    SettingKeys.householdId,
  ];

  Future<Directory> _workDir() async {
    final dir = Directory(
      p.join(
        (await _tempDir()).path,
        'backup_${DateTime.now().microsecondsSinceEpoch}',
      ),
    );
    return dir.create(recursive: true);
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}
