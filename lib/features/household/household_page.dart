import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/data_context.dart';
import '../../l10n/l10n.dart';
import '../../services/reminders.dart';
import '../../widgets/common.dart';
import '../shopping/shopping_data.dart';
import '../shopping/stores_page.dart';
import 'backup_section.dart';
import 'share_pages.dart';

/// Haushalt & Einstellungen: Personen, Geräte teilen, Erinnerungen.
class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  bool _reminders = false;
  int _summary = Reminders.defaultSummaryMinutes;
  int _waste = Reminders.defaultWasteMinutes;
  bool _shared = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = context.services;
    final reminders = await s.reminders.enabled();
    final summary = await s.reminders.minutes(
      SettingKeys.summaryMinutes,
      Reminders.defaultSummaryMinutes,
    );
    final waste = await s.reminders.minutes(
      SettingKeys.wasteMinutes,
      Reminders.defaultWasteMinutes,
    );
    final shared = await s.ctx.setting(SettingKeys.householdKey) != null;
    if (!mounted) return;
    setState(() {
      _reminders = reminders;
      _summary = summary;
      _waste = waste;
      _shared = shared;
    });
  }

  Future<void> _editMember(Member m) async {
    final l10n = context.l10n;
    final repo = context.services.household;
    final me = context.services.ctx.memberId;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.commonRename),
              onTap: () => Navigator.pop(context, 'rename'),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.beach_access_outlined),
              title: Text(l10n.memberPaused),
              subtitle: Text(l10n.memberPausedHint),
              value: m.paused,
              onChanged: (v) => Navigator.pop(context, v ? 'pause' : 'resume'),
            ),
            if (m.id != me)
              ListTile(
                leading: const Icon(Icons.person_remove_outlined),
                title: Text(l10n.memberRemove),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    switch (action) {
      case 'rename':
        final name = await askText(
          context,
          title: l10n.commonRename,
          initial: m.name,
          confirm: l10n.commonSave,
          cancel: l10n.commonCancel,
        );
        if (name != null && name.isNotEmpty) {
          if (m.id == me) {
            await repo.setMyName(name);
          } else {
            await repo.update(m.id, name: name);
          }
        }
      case 'pause':
        await repo.update(m.id, paused: true);
      case 'resume':
        await repo.update(m.id, paused: false);
      case 'remove':
        await repo.update(m.id, deleted: true);
    }
  }

  Future<void> _addMember() async {
    final l10n = context.l10n;
    final repo = context.services.household;
    final name = await askText(
      context,
      title: l10n.memberAdd,
      hint: l10n.memberAddHint,
      confirm: l10n.commonAdd,
      cancel: l10n.commonCancel,
    );
    if (name != null && name.isNotEmpty) await repo.add(name);
  }

  Future<void> _pickTime(String key, int current) async {
    final s = context.services;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked == null) return;
    await s.ctx.setSetting(key, '${picked.hour * 60 + picked.minute}');
    await _load();
    s.scheduleReminders();
  }

  String _time(int minutes) =>
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60).format(context);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final services = context.services;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.householdTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          SectionHeader(l10n.householdPeople, icon: Icons.people_outline),
          StreamBuilder<List<Member>>(
            stream: services.household.watchMembers(),
            builder: (context, snap) {
              final members = snap.data ?? const <Member>[];
              return Column(
                children: [
                  for (final m in members)
                    ListTile(
                      leading: MemberAvatar(m, size: 36),
                      title: Text(
                        m.id == services.ctx.memberId
                            ? l10n.memberMe(m.name)
                            : m.name,
                      ),
                      subtitle: m.paused ? Text(l10n.memberPaused) : null,
                      onTap: () => _editMember(m),
                    ),
                  ListTile(
                    leading: const Icon(Icons.person_add_alt),
                    title: Text(l10n.memberAdd),
                    subtitle: Text(l10n.memberAddHint),
                    onTap: _addMember,
                  ),
                ],
              );
            },
          ),
          SectionHeader(l10n.householdSharing, icon: Icons.wifi),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(l10n.householdSharingIntro),
          ),
          const SyncStatusTile(),
          ListTile(
            leading: const Icon(Icons.qr_code_2),
            title: Text(l10n.shareInviteTitle),
            subtitle: Text(l10n.shareInviteSubtitle),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const InvitePage()),
              );
              _load();
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: Text(l10n.scanTitle),
            subtitle: Text(l10n.scanSubtitle),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ScanPage()),
              );
              _load();
            },
          ),
          StreamBuilder<List<Peer>>(
            stream: services.sync.watchPeers(),
            builder: (context, snap) {
              final peers = snap.data ?? const <Peer>[];
              if (peers.isEmpty) return const SizedBox.shrink();
              final fmt = MaterialLocalizations.of(context);
              return Column(
                children: [
                  for (final p in peers)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.smartphone),
                      title: Text(p.name.isEmpty ? l10n.syncDevice : p.name),
                      subtitle: p.lastSyncAt == null
                          ? null
                          : Text(
                              l10n.syncLast(
                                '${fmt.formatShortDate(DateTime.fromMillisecondsSinceEpoch(p.lastSyncAt!))} '
                                '${TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(p.lastSyncAt!)).format(context)}',
                              ),
                            ),
                    ),
                ],
              );
            },
          ),
          if (_shared)
            ListTile(
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text(l10n.householdLeave),
              subtitle: Text(l10n.householdLeaveHint),
              onTap: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.householdLeave),
                    content: Text(l10n.householdLeaveConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.commonCancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(l10n.householdLeave),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  await services.sync.leave();
                  await _load();
                }
              },
            ),
          SectionHeader(
            l10n.householdReminders,
            icon: Icons.notifications_outlined,
          ),
          SwitchListTile(
            title: Text(l10n.remindersEnabled),
            subtitle: Text(l10n.remindersHint),
            value: _reminders,
            onChanged: (v) async {
              if (v) {
                final granted = await services.reminders.requestPermission();
                if (!granted && context.mounted) {
                  showMessage(context, l10n.remindersDenied);
                }
              }
              await services.ctx.setSetting(
                SettingKeys.remindersEnabled,
                v ? '1' : '0',
              );
              await _load();
              services.scheduleReminders();
            },
          ),
          if (_reminders) ...[
            ListTile(
              leading: const Icon(Icons.wb_twilight),
              title: Text(l10n.remindersSummary),
              trailing: Text(_time(_summary)),
              onTap: () => _pickTime(SettingKeys.summaryMinutes, _summary),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.remindersWaste),
              trailing: Text(_time(_waste)),
              onTap: () => _pickTime(SettingKeys.wasteMinutes, _waste),
            ),
          ],
          SectionHeader(l10n.tabShopping, icon: Icons.storefront_outlined),
          ListTile(
            leading: const Icon(Icons.store_outlined),
            title: Text(l10n.shopManageStores),
            onTap: () async {
              final data = ShoppingData(services.shopping);
              await Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => StoresPage(data: data)),
              );
              data.dispose();
            },
          ),
          SectionHeader(l10n.backupTitle, icon: Icons.backup_outlined),
          BackupSection(onRestored: _load),
          SectionHeader(l10n.householdAbout, icon: Icons.info_outline),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(l10n.householdPrivacy),
          ),
        ],
      ),
    );
  }
}
