import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../data/app_database.dart';
import '../data/data_context.dart';
import 'invite.dart';
import 'sync_crypto.dart';
import 'sync_engine.dart';

enum SyncPhase { off, idle, syncing, error }

/// Ein Gerät des Haushalts, das gerade im selben WLAN zu sehen ist.
class NearbyPeer {
  NearbyPeer(this.deviceId, this.host, this.port, this.lastSeen);

  final String deviceId;
  String host;
  int port;
  DateTime lastSeen;
  DateTime? lastSync;
}

@immutable
class SyncStatus {
  const SyncStatus({
    this.phase = SyncPhase.off,
    this.lastSyncAt,
    this.lastError,
    this.nearby = const [],
  });

  final SyncPhase phase;
  final DateTime? lastSyncAt;
  final String? lastError;

  /// Geräte-IDs, die gerade im WLAN zu sehen sind.
  final List<String> nearby;

  SyncStatus copyWith({
    SyncPhase? phase,
    DateTime? lastSyncAt,
    String? lastError,
    bool clearError = false,
    List<String>? nearby,
  }) => SyncStatus(
    phase: phase ?? this.phase,
    lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    lastError: clearError ? null : (lastError ?? this.lastError),
    nearby: nearby ?? this.nearby,
  );
}

class SyncException implements Exception {
  const SyncException(this.code);

  /// `unreachable`, `auth`, `household`, `protocol`.
  final String code;

  @override
  String toString() => 'SyncException($code)';
}

/// Teilen im Haushalt ohne Server: Geräte finden sich per UDP-Broadcast im
/// selben WLAN und tauschen Änderungen direkt per HTTP aus — verschlüsselt
/// mit dem Haushaltsschlüssel aus dem QR-Code.
///
/// Läuft nur, solange die App im Vordergrund ist (kein Hintergrunddienst).
class SyncService {
  SyncService(this.ctx, {SyncEngine? engine})
    : engine = engine ?? SyncEngine(ctx);

  final DataContext ctx;
  final SyncEngine engine;

  static const discoveryPort = 47231;
  static const preferredPort = 47232;
  static const _beaconPrefix = 'MAIHH1';
  static const _netChannel = MethodChannel('mai/net');

  final status = ValueNotifier<SyncStatus>(const SyncStatus());

  HttpServer? _server;
  RawDatagramSocket? _udp;
  Timer? _beaconTimer;
  Timer? _debounce;
  StreamSubscription<void>? _changes;
  SyncCrypto? _crypto;
  String? _tag;
  String? _householdId;
  bool _dirty = false;
  bool _running = false;
  final _nearby = <String, NearbyPeer>{};
  final _busy = <String>{};

  bool get isShared => _crypto != null;
  int? get port => _server?.port;

  // ---------------------------------------------------------------------
  // Lebenszyklus
  // ---------------------------------------------------------------------

  Future<void> start() async {
    if (_running) return;
    final key = await ctx.setting(SettingKeys.householdKey);
    if (key == null) {
      status.value = const SyncStatus(phase: SyncPhase.off);
      return;
    }
    final keyBytes = SyncCrypto.decodeKey(key);
    _crypto = SyncCrypto(keyBytes);
    _tag = await SyncCrypto.tag(keyBytes);
    _householdId = await ctx.setting(SettingKeys.householdId);
    _running = true;
    status.value = status.value.copyWith(phase: SyncPhase.idle);
    try {
      await _netChannel.invokeMethod<void>('acquireMulticast');
    } catch (_) {
      // Kein Kanal (Tests/iOS): Broadcast geht trotzdem meistens.
    }
    await _startServer();
    await _startDiscovery();
    _changes = ctx.localChanges.listen((_) {
      _dirty = true;
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 1500), syncNearby);
    });
  }

  Future<void> stop() async {
    _running = false;
    _debounce?.cancel();
    _beaconTimer?.cancel();
    await _changes?.cancel();
    _changes = null;
    _udp?.close();
    _udp = null;
    await _server?.close(force: true);
    _server = null;
    _nearby.clear();
    try {
      await _netChannel.invokeMethod<void>('releaseMulticast');
    } catch (_) {}
    status.value = status.value.copyWith(
      phase: isShared ? SyncPhase.idle : SyncPhase.off,
      nearby: const [],
    );
  }

  Future<void> restart() async {
    await stop();
    _crypto = null;
    await start();
  }

  Future<void> _startServer() async {
    HttpServer server;
    try {
      server = await HttpServer.bind(InternetAddress.anyIPv4, preferredPort);
    } on SocketException {
      server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    }
    _server = server;
    server.listen(_handle, onError: (_) {});
  }

  Future<void> _startDiscovery() async {
    try {
      final udp = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        discoveryPort,
        reuseAddress: true,
      );
      udp.broadcastEnabled = true;
      udp.listen((event) {
        if (event != RawSocketEvent.read) return;
        final d = udp.receive();
        if (d != null) _onBeacon(d);
      });
      _udp = udp;
    } on SocketException {
      // Port belegt (zweite App-Instanz) — dann nur ohne Suche.
    }
    _beaconTimer = Timer.periodic(const Duration(seconds: 4), (_) => _tick());
    _tick();
  }

  Future<void> _tick() async {
    await _sendBeacon();
    final now = DateTime.now();
    _nearby.removeWhere((_, p) => now.difference(p.lastSeen).inSeconds > 20);
    _publishNearby();
    // Sicherheitsnetz: alle 60 s abgleichen, auch ohne lokale Änderung.
    for (final p in _nearby.values.toList()) {
      if (p.lastSync == null || now.difference(p.lastSync!).inSeconds > 60) {
        unawaited(_syncPeer(p));
      }
    }
  }

  Future<void> _sendBeacon() async {
    final udp = _udp;
    final port = _server?.port;
    if (udp == null || port == null || _tag == null) return;
    final msg = utf8.encode('$_beaconPrefix|$_tag|${ctx.deviceId}|$port');
    final targets = <InternetAddress>{InternetAddress('255.255.255.255')};
    for (final a in await localAddresses()) {
      final parts = a.split('.');
      if (parts.length == 4) {
        targets.add(InternetAddress('${parts[0]}.${parts[1]}.${parts[2]}.255'));
      }
    }
    for (final t in targets) {
      try {
        udp.send(msg, t, discoveryPort);
      } catch (_) {}
    }
  }

  void _onBeacon(Datagram d) {
    final parts = utf8.decode(d.data, allowMalformed: true).split('|');
    if (parts.length != 4 || parts[0] != _beaconPrefix) return;
    if (parts[1] != _tag || parts[2] == ctx.deviceId) return;
    final port = int.tryParse(parts[3]);
    if (port == null) return;
    final id = parts[2];
    final known = _nearby[id];
    final now = DateTime.now();
    if (known == null) {
      final peer = NearbyPeer(id, d.address.address, port, now);
      _nearby[id] = peer;
      _publishNearby();
      unawaited(_syncPeer(peer));
    } else {
      known
        ..host = d.address.address
        ..port = port
        ..lastSeen = now;
      if (_dirty) unawaited(_syncPeer(known));
    }
  }

  void _publishNearby() {
    status.value = status.value.copyWith(nearby: _nearby.keys.toList());
  }

  /// IPv4-Adressen dieses Geräts im lokalen Netz.
  static Future<List<String>> localAddresses() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );
      final out = <String>[];
      // WLAN zuerst, mobile Daten (rmnet/ccmni) nie.
      interfaces.sort((a, b) {
        int score(NetworkInterface i) =>
            i.name.startsWith('wlan') || i.name.startsWith('en') ? 0 : 1;
        return score(a).compareTo(score(b));
      });
      for (final i in interfaces) {
        if (i.name.startsWith('rmnet') || i.name.startsWith('ccmni')) continue;
        for (final a in i.addresses) {
          if (!a.isLoopback && !a.isLinkLocal) out.add(a.address);
        }
      }
      return out;
    } catch (_) {
      return const [];
    }
  }

  // ---------------------------------------------------------------------
  // Abgleich
  // ---------------------------------------------------------------------

  /// Mit allen sichtbaren Geräten abgleichen (z. B. nach einer Änderung).
  Future<int> syncNearby() async {
    var changed = 0;
    final peers = _nearby.values.toList();
    var allOk = true;
    for (final p in peers) {
      final r = await _syncPeer(p);
      if (r == null) {
        allOk = false;
      } else {
        changed += r;
      }
    }
    if (allOk) _dirty = false;
    return changed;
  }

  Future<int?> _syncPeer(NearbyPeer p) async {
    if (_busy.contains(p.deviceId)) return null;
    try {
      final r = await syncWith(p.host, p.port, deviceId: p.deviceId);
      p.lastSync = DateTime.now();
      return r;
    } catch (_) {
      return null;
    }
  }

  /// Gleicht mit dem Gerät unter [host]:[port] ab. Liefert die Zahl der
  /// übernommenen Zeilen.
  Future<int> syncWith(String host, int port, {String? deviceId}) async {
    final crypto = _crypto;
    if (crypto == null) throw const SyncException('household');
    final key = deviceId ?? '$host:$port';
    if (!_busy.add(key)) return 0;
    status.value = status.value.copyWith(phase: SyncPhase.syncing);
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 4)
      ..idleTimeout = const Duration(seconds: 2);
    try {
      final peer = deviceId == null ? null : await _peer(deviceId);
      final ourSeq = ctx.currentSeq;
      final request = {
        'household': _householdId,
        'device': ctx.deviceId,
        'name': await _myName(),
        'since': peer?.theirSeq ?? 0,
        'seq': ourSeq,
        'rows': await engine.exportSince(peer?.ourSeqAcked ?? 0),
      };
      final HttpClientResponse response;
      try {
        final req = await client.post(host, port, '/v1/sync');
        req.headers.contentType = ContentType.json;
        req.write(await crypto.seal(request));
        response = await req.close().timeout(const Duration(seconds: 20));
      } on SocketException {
        throw const SyncException('unreachable');
      } on TimeoutException {
        throw const SyncException('unreachable');
      } on HttpException {
        throw const SyncException('unreachable');
      }
      final body = await utf8.decodeStream(response);
      if (response.statusCode == 403) throw const SyncException('auth');
      if (response.statusCode == 409) throw const SyncException('household');
      if (response.statusCode != 200) throw const SyncException('protocol');
      final reply = await crypto.open(body);
      final rows = _rows(reply['rows']);
      final changed = await engine.import(rows);
      final remoteId = reply['device'] as String?;
      if (remoteId == null) throw const SyncException('protocol');
      await _savePeer(
        remoteId,
        name: reply['name'] as String? ?? '',
        address: '$host:$port',
        theirSeq: reply['seq'] as int?,
        ourSeqAcked: ourSeq,
      );
      // Nachfolgende Abgleiche mit diesem Gerät nutzen den Stand.
      if (deviceId == null && _nearby[remoteId] == null) {
        _nearby[remoteId] = NearbyPeer(remoteId, host, port, DateTime.now())
          ..lastSync = DateTime.now();
        _publishNearby();
      }
      status.value = status.value.copyWith(
        phase: SyncPhase.idle,
        lastSyncAt: DateTime.now(),
        clearError: true,
      );
      return changed;
    } on SyncAuthException {
      status.value = status.value.copyWith(
        phase: SyncPhase.error,
        lastError: 'auth',
      );
      throw const SyncException('auth');
    } on SyncException catch (e) {
      status.value = status.value.copyWith(
        phase: SyncPhase.error,
        lastError: e.code,
      );
      rethrow;
    } finally {
      _busy.remove(key);
      client.close(force: true);
    }
  }

  Future<void> _handle(HttpRequest request) async {
    final response = request.response;
    try {
      if (request.method != 'POST' || request.uri.path != '/v1/sync') {
        response.statusCode = HttpStatus.notFound;
        return;
      }
      final crypto = _crypto;
      if (crypto == null) {
        response.statusCode = HttpStatus.forbidden;
        return;
      }
      final body = await utf8.decodeStream(request);
      final Map<String, Object?> message;
      try {
        message = await crypto.open(body);
      } on SyncAuthException {
        response.statusCode = HttpStatus.forbidden;
        return;
      }
      if (message['household'] != _householdId) {
        response.statusCode = HttpStatus.conflict;
        return;
      }
      final device = message['device'] as String?;
      if (device == null || device == ctx.deviceId) {
        response.statusCode = HttpStatus.badRequest;
        return;
      }
      // Erst eigenen Stand exportieren, dann übernehmen (kein Echo).
      final since = (message['since'] as int?) ?? 0;
      final ourSeq = ctx.currentSeq;
      final rows = await engine.exportSince(since);
      await engine.import(_rows(message['rows']));
      await _savePeer(
        device,
        name: message['name'] as String? ?? '',
        address: null,
        theirSeq: message['seq'] as int?,
      );
      response.statusCode = HttpStatus.ok;
      response.headers.contentType = ContentType.json;
      response.write(
        await crypto.seal({
          'device': ctx.deviceId,
          'name': await _myName(),
          'seq': ourSeq,
          'rows': rows,
        }),
      );
      status.value = status.value.copyWith(lastSyncAt: DateTime.now());
      final known = _nearby[device];
      if (known != null) known.lastSync = DateTime.now();
    } catch (_) {
      response.statusCode = HttpStatus.internalServerError;
    } finally {
      await response.close();
    }
  }

  static RowBatch _rows(Object? raw) {
    if (raw is! Map) return const {};
    return {
      for (final e in raw.entries)
        if (e.key is String && e.value is List)
          e.key as String: [
            for (final r in e.value as List)
              if (r is Map) r.cast<String, Object?>(),
          ],
    };
  }

  Future<String> _myName() async {
    final me = await (ctx.db.select(
      ctx.db.members,
    )..where((t) => t.id.equals(ctx.memberId))).getSingleOrNull();
    return me?.name ?? '';
  }

  Future<Peer?> _peer(String deviceId) => (ctx.db.select(
    ctx.db.peers,
  )..where((t) => t.deviceId.equals(deviceId))).getSingleOrNull();

  Future<void> _savePeer(
    String deviceId, {
    required String name,
    required String? address,
    int? theirSeq,
    int? ourSeqAcked,
  }) async {
    final existing = await _peer(deviceId);
    await ctx.db
        .into(ctx.db.peers)
        .insertOnConflictUpdate(
          PeersCompanion.insert(
            deviceId: deviceId,
            name: name,
            lastAddress: Value(address ?? existing?.lastAddress),
            lastSyncAt: Value(DateTime.now().millisecondsSinceEpoch),
            theirSeq: Value(theirSeq ?? existing?.theirSeq ?? 0),
            ourSeqAcked: Value(ourSeqAcked ?? existing?.ourSeqAcked ?? 0),
          ),
        );
  }

  Stream<List<Peer>> watchPeers() => (ctx.db.select(
    ctx.db.peers,
  )..orderBy([(t) => OrderingTerm(expression: t.name)])).watch();

  // ---------------------------------------------------------------------
  // Haushalt teilen
  // ---------------------------------------------------------------------

  /// Einladung für ein weiteres Gerät. Erzeugt beim ersten Mal den
  /// Haushaltsschlüssel und startet das Teilen.
  Future<Invite> createInvite() async {
    var key = await ctx.setting(SettingKeys.householdKey);
    if (key == null) {
      key = SyncCrypto.encodeKey(SyncCrypto.newKey());
      await ctx.setSetting(SettingKeys.householdKey, key);
      await restart();
    } else if (!_running) {
      await start();
    }
    final port = _server?.port ?? preferredPort;
    return Invite(
      householdId: (await ctx.setting(SettingKeys.householdId))!,
      key: key,
      deviceId: ctx.deviceId,
      name: await _myName(),
      addresses: [for (final a in await localAddresses()) '$a:$port'],
    );
  }

  /// Einladung annehmen. Mit [keepMine] werden die bisherigen Einträge
  /// dieses Geräts in den Haushalt übernommen, sonst verworfen.
  /// Liefert `true`, wenn das andere Gerät direkt erreichbar war.
  Future<bool> join(Invite invite, {required bool keepMine}) async {
    final sameHousehold =
        invite.householdId == await ctx.setting(SettingKeys.householdId) &&
        invite.key == await ctx.setting(SettingKeys.householdKey);
    if (!sameHousehold) {
      await stop();
      if (!keepMine) await engine.wipeShared();
      await ctx.setSetting(SettingKeys.householdId, invite.householdId);
      await ctx.setSetting(SettingKeys.householdKey, invite.key);
      await ctx.db.delete(ctx.db.peers).go();
      _crypto = null;
      await start();
    }
    for (final address in invite.addresses) {
      final i = address.lastIndexOf(':');
      final host = address.substring(0, i);
      final port = int.tryParse(address.substring(i + 1));
      if (port == null) continue;
      try {
        await syncWith(host, port, deviceId: invite.deviceId);
        return true;
      } on SyncException {
        continue;
      }
    }
    return false;
  }

  /// Haushalt verlassen: Daten bleiben als eigene Kopie, Teilen endet.
  Future<void> leave() async {
    await stop();
    await (ctx.db.delete(
      ctx.db.localSettings,
    )..where((t) => t.key.equals(SettingKeys.householdKey))).go();
    await ctx.setSetting(SettingKeys.householdId, DataContext.newId());
    await ctx.db.delete(ctx.db.peers).go();
    _crypto = null;
    status.value = const SyncStatus(phase: SyncPhase.off);
  }

  Future<void> dispose() async {
    await stop();
    status.dispose();
  }
}
