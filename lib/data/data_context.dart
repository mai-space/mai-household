import 'dart:async';
import 'dart:math' as math;

import 'package:uuid/uuid.dart';

import 'app_database.dart';

/// Hybride Uhr: nie rückwärts, nie zweimal derselbe Wert, und mindestens so
/// spät wie alles, was wir schon von anderen Geräten gesehen haben. So
/// gewinnt beim Zusammenführen die wirklich spätere Änderung, auch wenn die
/// Geräteuhren leicht abweichen.
class HybridClock {
  HybridClock({int last = 0, int Function()? wallClock})
    : _last = last, // ignore: prefer_initializing_formals
      _wall = wallClock ?? (() => DateTime.now().millisecondsSinceEpoch);

  int _last;
  final int Function() _wall;

  int now() => _last = math.max(_wall(), _last + 1);

  void observe(int remote) {
    if (remote > _last) _last = remote;
  }
}

/// Gemeinsamer Zugriff für alle Repositories: Datenbank, Uhr, Änderungs-
/// zähler, eigene Geräte-/Personen-ID und ein Signal bei lokalen Änderungen
/// (löst die Synchronisation aus).
class DataContext {
  DataContext(this.db, {HybridClock? clock}) : clock = clock ?? HybridClock();

  final AppDatabase db;
  final HybridClock clock;
  int _seq = 0;

  late String deviceId;

  /// Person, die dieses Gerät benutzt (Mitglied im Haushalt).
  late String memberId;

  final _localChanges = StreamController<void>.broadcast();

  /// Feuert nach jeder lokalen Änderung an geteilten Daten.
  Stream<void> get localChanges => _localChanges.stream;

  static const _uuid = Uuid();
  static String newId() => _uuid.v4();

  /// Liest den höchsten Stand aus der Datenbank (beim Start und nach dem
  /// Wiederherstellen einer Sicherung). Der Änderungszähler geht dabei nie
  /// zurück, damit Partnergeräte keine neuen Änderungen übersehen.
  Future<void> load() async {
    var maxSeq = 0;
    var maxTime = 0;
    for (final table in AppDatabase.syncTableNames) {
      final row = await db
          .customSelect(
            'SELECT COALESCE(MAX(seq), 0) AS s, '
            'COALESCE(MAX(updated_at), 0) AS t FROM $table',
          )
          .getSingle();
      maxSeq = math.max(maxSeq, row.read<int>('s'));
      maxTime = math.max(maxTime, row.read<int>('t'));
    }
    _seq = math.max(_seq, maxSeq);
    clock.observe(maxTime);
    deviceId = await setting(SettingKeys.deviceId) ?? await _init();
    memberId = (await setting(SettingKeys.memberId))!;
  }

  Future<String> _init() async {
    final id = newId();
    await setSetting(SettingKeys.deviceId, id);
    await setSetting(SettingKeys.memberId, newId());
    await setSetting(SettingKeys.householdId, newId());
    return id;
  }

  int nextSeq() => ++_seq;
  int get currentSeq => _seq;

  /// Zeitstempel + seq für eine lokale Änderung.
  ({int updatedAt, int seq}) stamp() => (updatedAt: clock.now(), seq: nextSeq());

  void notifyChanged() {
    if (!_localChanges.isClosed) _localChanges.add(null);
  }

  Future<String?> setting(String key) async {
    final row = await (db.select(
      db.localSettings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) => db
      .into(db.localSettings)
      .insertOnConflictUpdate(LocalSetting(key: key, value: value));

  Stream<String?> watchSetting(String key) =>
      (db.select(db.localSettings)..where((t) => t.key.equals(key)))
          .watchSingleOrNull()
          .map((r) => r?.value);

  Future<void> dispose() async {
    await _localChanges.close();
  }
}

abstract final class SettingKeys {
  static const deviceId = 'device_id';
  static const memberId = 'member_id';
  static const householdId = 'household_id';

  /// Haushaltsschlüssel (Base64, 32 Byte) — nur gesetzt, wenn geteilt.
  static const householdKey = 'household_key';
  static const onboarded = 'onboarded';
  static const remindersEnabled = 'reminders_enabled';

  /// Uhrzeit der Tageszusammenfassung, Minuten nach Mitternacht.
  static const summaryMinutes = 'summary_minutes';
  static const wasteMinutes = 'waste_minutes';
  static const shoppingStore = 'shopping_store';

  /// Eigener Name (zum Wiederherstellen nach einem Beitritt ohne Daten).
  static const myName = 'my_name';
}

/// Hilfen für kommagetrennte ID-Listen.
abstract final class IdList {
  static List<String> parse(String s) =>
      s.isEmpty ? const [] : s.split(',').where((e) => e.isNotEmpty).toList();

  static String join(Iterable<String> ids) => ids.join(',');
}
