import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Verschlüsselung zwischen Geräten eines Haushalts.
///
/// Der Haushaltsschlüssel (256 Bit) wird nur per QR-Code von Gerät zu Gerät
/// weitergegeben und verlässt nie das lokale Netz. Jede Nachricht ist mit
/// AES-256-GCM verschlüsselt und authentisiert; fremde Geräte im WLAN können
/// weder mitlesen noch Daten einschleusen.
class SyncCrypto {
  SyncCrypto(List<int> key) : _key = SecretKey(key);

  final SecretKey _key;
  static final _aes = AesGcm.with256bits();

  static List<int> newKey() {
    final r = Random.secure();
    return List<int>.generate(32, (_) => r.nextInt(256));
  }

  static String encodeKey(List<int> key) =>
      base64Url.encode(key).replaceAll('=', '');

  static List<int> decodeKey(String s) =>
      base64Url.decode(s.padRight((s.length + 3) ~/ 4 * 4, '='));

  /// JSON → gzip → AES-GCM → Base64-Umschlag.
  Future<String> seal(Map<String, Object?> message) async {
    final clear = gzip.encode(utf8.encode(jsonEncode(message)));
    final box = await _aes.encrypt(clear, secretKey: _key);
    return jsonEncode({
      'v': 1,
      'n': base64.encode(box.nonce),
      'c': base64.encode(box.cipherText),
      'm': base64.encode(box.mac.bytes),
    });
  }

  /// Wirft [SyncAuthException], wenn die Nachricht nicht mit unserem
  /// Schlüssel erzeugt wurde.
  Future<Map<String, Object?>> open(String envelope) async {
    try {
      final map = jsonDecode(envelope) as Map<String, Object?>;
      final box = SecretBox(
        base64.decode(map['c'] as String),
        nonce: base64.decode(map['n'] as String),
        mac: Mac(base64.decode(map['m'] as String)),
      );
      final clear = await _aes.decrypt(box, secretKey: _key);
      return jsonDecode(utf8.decode(gzip.decode(clear)))
          as Map<String, Object?>;
    } on SecretBoxAuthenticationError {
      throw const SyncAuthException();
    } on FormatException {
      throw const SyncAuthException();
    } on TypeError {
      throw const SyncAuthException();
    }
  }

  /// Kurzes, nicht umkehrbares Kennzeichen des Haushalts für die
  /// Geräte-Suche im WLAN (verrät weder Schlüssel noch Haushalts-ID).
  static Future<String> tag(List<int> key) async {
    final hash = await Sha256().hash([...utf8.encode('mai-household-tag'), ...key]);
    return hash.bytes
        .take(8)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static Uint8List bytes(List<int> l) => Uint8List.fromList(l);
}

class SyncAuthException implements Exception {
  const SyncAuthException();
}
