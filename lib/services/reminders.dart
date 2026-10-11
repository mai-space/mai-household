import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/data_context.dart';
import '../data/repositories/chore_repository.dart';
import '../domain/waste/waste.dart';
import '../l10n/l10n.dart';

/// Lokale Erinnerungen — bewusst sparsam:
/// * eine Tageszusammenfassung („Heute dran: …“) zur gewählten Uhrzeit,
/// * Müllabfuhr am Vorabend.
///
/// Geplant werden die nächsten Tage im Voraus und bei jeder Änderung neu
/// (kein Server, kein Push).
class Reminders {
  Reminders(this.ctx);

  final DataContext ctx;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _deviceChannel = MethodChannel('mai/device');
  static const defaultSummaryMinutes = 18 * 60;
  static const defaultWasteMinutes = 19 * 60;

  static bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> init() async {
    if (_ready || !_supported) return;
    tz.initializeTimeZones();
    try {
      final zone = await _deviceChannel.invokeMethod<String>('timeZone');
      tz.setLocalLocation(tz.getLocation(zone ?? 'Europe/Berlin'));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
    }
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings: settings);
    _ready = true;
  }

  Future<bool> requestPermission() async {
    if (!_supported) return false;
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  Future<bool> enabled() async =>
      (await ctx.setting(SettingKeys.remindersEnabled)) == '1';

  Future<int> minutes(String key, int fallback) async =>
      int.tryParse(await ctx.setting(key) ?? '') ?? fallback;

  /// Alles neu planen (nach Änderungen, beim Start, nach Sync).
  Future<void> reschedule() async {
    if (!_supported) return;
    await init();
    await _plugin.cancelAll();
    if (!await enabled()) return;
    final strings = AppLocale.strings;
    final now = tz.TZDateTime.now(tz.local);
    final summary = await minutes(
      SettingKeys.summaryMinutes,
      defaultSummaryMinutes,
    );
    final waste = await minutes(SettingKeys.wasteMinutes, defaultWasteMinutes);
    final repo = ChoreRepository(ctx);
    final chores = await repo.chores();
    var id = 1;

    // Tageszusammenfassung für die nächsten 7 Tage.
    for (var d = 0; d < 7; d++) {
      final day = DateTime(now.year, now.month, now.day + d);
      final at = tz.TZDateTime(
        tz.local,
        day.year,
        day.month,
        day.day,
        summary ~/ 60,
        summary % 60,
      );
      if (at.isBefore(now)) continue;
      final due = [
        for (final c in chores)
          if (c.remind &&
              (c.assigneeId == null || c.assigneeId == ctx.memberId))
            (c, ChoreRepository.timingOf(c, day)),
      ].where((e) => e.$2.isDue);
      final names = due.map((e) => e.$1.name).toList();
      if (names.isEmpty) continue;
      await _schedule(
        id++,
        at,
        strings.reminderChoresTitle(names.length),
        names.take(4).join(' · '),
      );
    }

    // Müll am Vorabend, 30 Tage im Voraus.
    final pickups = await repo.pickupsBetween(
      now,
      now.add(const Duration(days: 31)),
    );
    final byDay = <String, List<WasteType>>{};
    for (final p in pickups) {
      if (p.assigneeId != null && p.assigneeId != ctx.memberId) continue;
      (byDay[p.day] ??= []).add(WasteType.values[p.type]);
    }
    for (final entry in byDay.entries) {
      final day = ChoreRepository.parseDay(entry.key);
      final eve = DateTime(day.year, day.month, day.day - 1);
      final at = tz.TZDateTime(
        tz.local,
        eve.year,
        eve.month,
        eve.day,
        waste ~/ 60,
        waste % 60,
      );
      if (at.isBefore(now)) continue;
      await _schedule(
        id++,
        at,
        strings.reminderWasteTitle,
        entry.value.map(strings.wasteTypeName).join(' · '),
      );
    }
  }

  Future<void> _schedule(
    int id,
    tz.TZDateTime at,
    String title,
    String body,
  ) => _plugin.zonedSchedule(
    id: id,
    scheduledDate: at,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        'household',
        AppLocale.strings.reminderChannel,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  );
}

extension WasteNames on AppLocalizations {
  String wasteTypeName(WasteType t) => switch (t) {
    WasteType.residual => wasteResidual,
    WasteType.organic => wasteOrganic,
    WasteType.paper => wastePaper,
    WasteType.packaging => wastePackaging,
    WasteType.glass => wasteGlass,
    WasteType.other => wasteOther,
  };
}
