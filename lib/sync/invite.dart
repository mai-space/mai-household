/// Inhalt des Einladungs-QR-Codes.
///
/// `maihh:1?h=<Haushalt>&k=<Schlüssel>&d=<Gerät>&n=<Name>&a=<ip:port,…>`
///
/// Der Code enthält den Haushaltsschlüssel — wer ihn scannt, gehört zum
/// Haushalt. Deshalb wird er nur auf Wunsch angezeigt.
class Invite {
  const Invite({
    required this.householdId,
    required this.key,
    required this.deviceId,
    required this.name,
    required this.addresses,
  });

  final String householdId;

  /// Base64url ohne Auffüllung.
  final String key;
  final String deviceId;
  final String name;

  /// `ip:port` aller WLAN-Adressen des einladenden Geräts.
  final List<String> addresses;

  static const scheme = 'maihh';

  String encode() {
    final q = {
      'h': householdId,
      'k': key,
      'd': deviceId,
      'n': name,
      'a': addresses.join(','),
    };
    return '$scheme:1?${q.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
  }

  static Invite? tryParse(String raw) {
    final text = raw.trim();
    if (!text.startsWith('$scheme:1?')) return null;
    try {
      final q = Uri.splitQueryString(text.substring('$scheme:1?'.length));
      final h = q['h'], k = q['k'], d = q['d'];
      if (h == null || k == null || d == null || h.isEmpty || k.length < 40) {
        return null;
      }
      return Invite(
        householdId: h,
        key: k,
        deviceId: d,
        name: q['n'] ?? '',
        addresses: (q['a'] ?? '')
            .split(',')
            .where((a) => a.contains(':'))
            .toList(),
      );
    } on FormatException {
      return null;
    }
  }
}
