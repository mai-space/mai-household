import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/services.dart';
import '../../data/data_context.dart';
import '../../l10n/l10n.dart';
import '../../sync/invite.dart';
import '../../sync/sync_service.dart';
import '../../widgets/common.dart';

/// Zeigt den Einladungs-QR-Code. Solange die Seite offen ist, wartet das
/// Gerät auf das andere Gerät im selben WLAN.
class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  Invite? _invite;
  String? _error;
  int _peersAtStart = -1;

  @override
  void initState() {
    super.initState();
    _create();
  }

  Future<void> _create() async {
    try {
      final invite = await context.services.sync.createInvite();
      if (mounted) setState(() => _invite = invite);
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final invite = _invite;
    final services = context.services;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.shareInviteTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(l10n.shareInviteIntro, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          if (_error != null)
            Text(_error!, style: TextStyle(color: theme.colorScheme.error))
          else if (invite == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: invite.encode(),
                  size: 260,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (invite.addresses.isEmpty)
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.shareNoWifi),
                ),
              ),
            StreamBuilder(
              stream: services.sync.watchPeers(),
              builder: (context, snap) {
                final peers = snap.data ?? const [];
                if (snap.hasData && _peersAtStart < 0) {
                  _peersAtStart = peers.length;
                }
                final joined =
                    _peersAtStart >= 0 && peers.length > _peersAtStart;
                return Card(
                  child: ListTile(
                    leading: joined
                        ? Icon(Icons.check_circle,
                            color: theme.colorScheme.primary)
                        : const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                    title: Text(
                      joined
                          ? l10n.shareJoined(peers.last.name)
                          : l10n.shareWaiting,
                    ),
                    subtitle: Text(l10n.shareSameWifi),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(l10n.shareSecurityNote, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// QR-Code eines anderen Geräts scannen und beitreten bzw. abgleichen.
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  bool _handling = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;
    for (final code in capture.barcodes) {
      final invite = Invite.tryParse(code.rawValue ?? '');
      if (invite == null) continue;
      _handling = true;
      await _controller.stop();
      if (!mounted) return;
      await _join(invite);
      return;
    }
  }

  Future<void> _join(Invite invite) async {
    final l10n = context.l10n;
    final services = context.services;
    final navigator = Navigator.of(context);
    final ctx = services.ctx;
    final same =
        invite.householdId == await ctx.setting(SettingKeys.householdId);
    bool keepMine = true;
    if (!same && mounted) {
      final hasData = (await services.shopping.openItems()).isNotEmpty ||
          (await services.chores.chores()).isNotEmpty;
      if (hasData && mounted) {
        final choice = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text(l10n.joinTitle(invite.name)),
            content: Text(l10n.joinKeepQuestion),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.joinDiscardMine),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.joinKeepMine),
              ),
            ],
          ),
        );
        keepMine = choice ?? true;
      }
    }
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(l10n.joinConnecting)),
          ],
        ),
      ),
    );
    bool reached;
    try {
      reached = await services.sync.join(invite, keepMine: keepMine);
      // Eigene Person nach dem Verwerfen wieder anlegen.
      final me = await (ctx.db.select(
        ctx.db.members,
      )..where((t) => t.id.equals(ctx.memberId))).getSingleOrNull();
      if (me == null || me.deleted) {
        final name = await ctx.setting(SettingKeys.myName) ?? '';
        if (name.isNotEmpty) await services.household.setMyName(name);
      }
    } catch (_) {
      reached = false;
    }
    if (!mounted) return;
    navigator.pop(); // Fortschritt
    navigator.pop(); // Scanner
    showMessage(
      context,
      reached ? l10n.joinSuccess(invite.name) : l10n.joinSavedNotReached,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanTitle)),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.scanHint,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Status-Zeile „Synchronisiert vor 2 Min. · 1 Gerät in der Nähe“.
class SyncStatusTile extends StatelessWidget {
  const SyncStatusTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final services = context.services;
    return ValueListenableBuilder<SyncStatus>(
      valueListenable: services.sync.status,
      builder: (context, s, _) {
        final last = s.lastSyncAt;
        final when = last == null
            ? l10n.syncNever
            : l10n.syncLast(
                TimeOfDay.fromDateTime(last).format(context),
              );
        final icon = switch (s.phase) {
          SyncPhase.off => Icons.cloud_off_outlined,
          SyncPhase.syncing => Icons.sync,
          SyncPhase.error => Icons.sync_problem,
          SyncPhase.idle =>
            s.nearby.isEmpty ? Icons.wifi_find_outlined : Icons.devices,
        };
        return ListTile(
          leading: Icon(icon),
          title: Text(
            s.phase == SyncPhase.off
                ? l10n.syncOff
                : (s.nearby.isEmpty
                      ? l10n.syncSearching
                      : l10n.syncNearby(s.nearby.length)),
          ),
          subtitle: s.phase == SyncPhase.off ? null : Text(when),
          trailing: s.phase == SyncPhase.off
              ? null
              : IconButton(
                  tooltip: l10n.syncNow,
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    final n = await services.sync.syncNearby();
                    if (context.mounted && s.nearby.isNotEmpty) {
                      showMessage(context, l10n.syncDone(n));
                    }
                  },
                ),
        );
      },
    );
  }
}
