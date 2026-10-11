import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/repositories/chore_repository.dart';
import '../../domain/waste/waste.dart';
import '../../l10n/l10n.dart';
import '../../services/reminders.dart';
import '../../widgets/common.dart';
import 'chores_page.dart';

/// Müllabfuhr: Termine je Tonne, Import des kommunalen Abfallkalenders.
class WastePage extends StatefulWidget {
  const WastePage({super.key, required this.data});

  final ChoreData data;

  @override
  State<WastePage> createState() => _WastePageState();
}

class _WastePageState extends State<WastePage> {
  @override
  void initState() {
    super.initState();
    widget.data.addListener(_changed);
  }

  @override
  void dispose() {
    widget.data.removeListener(_changed);
    super.dispose();
  }

  void _changed() => setState(() {});

  Future<void> _import() async {
    final l10n = context.l10n;
    final services = context.services;
    final List<PlatformFile> files;
    try {
      // Viele Dateimanager kennen keinen MIME-Typ für .ics — daher alle
      // Dateien zulassen und den Inhalt prüfen.
      files = await FilePicker.pickFiles(type: FileType.any);
    } catch (_) {
      return;
    }
    final file = files.firstOrNull;
    if (file == null) return;
    final text = utf8.decode(await file.readAsBytes(), allowMalformed: true);
    final today = DateTime.now();
    final events = WasteIcs.parse(text)
        .where((e) => !e.date.isBefore(DateTime(today.year, today.month, today.day)))
        .toList();
    var added = 0;
    for (final type in WasteType.values) {
      added += await services.chores.addPickups(
        type,
        events.where((e) => e.type == type).map((e) => e.date),
      );
    }
    if (mounted) showMessage(context, l10n.wasteImported(added));
  }

  Future<void> _add() async {
    final services = context.services;
    final l10n = context.l10n;
    final result = await showModalBottomSheet<(WasteType, DateTime, int)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AddPickupSheet(),
    );
    if (result == null) return;
    final (type, first, every) = result;
    final days = WasteIcs.repeat(
      first,
      every,
      every == 0 ? first : DateTime(first.year + 1, first.month, first.day),
    );
    final n = await services.chores.addPickups(type, days);
    if (mounted) showMessage(context, l10n.wasteImported(n));
  }

  Future<void> _typeMenu(WasteType type) async {
    final l10n = context.l10n;
    final services = context.services;
    final members = widget.data.members;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                l10n.wasteTypeName(type),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(l10n.wasteNobody),
              onTap: () => Navigator.pop(context, 'assign:'),
            ),
            for (final m in members)
              ListTile(
                leading: MemberAvatar(m),
                title: Text(l10n.wasteAssign(m.name)),
                onTap: () => Navigator.pop(context, 'assign:${m.id}'),
              ),
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined),
              title: Text(l10n.wasteDeleteFuture),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null) return;
    final today = DateTime.now();
    if (action == 'delete') {
      await services.chores.deleteFutureOfType(type, today);
    } else if (action.startsWith('assign:')) {
      final id = action.substring(7);
      await services.chores.assignType(type, id.isEmpty ? null : id, today);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final pickups = widget.data.pickups;
    final byDay = <String, List<WastePickup>>{};
    for (final p in pickups) {
      (byDay[p.day] ??= []).add(p);
    }
    final fmt = MaterialLocalizations.of(context);
    final types = pickups.map((p) => WasteType.values[p.type]).toSet();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wasteTitle),
        actions: [
          IconButton(
            tooltip: l10n.wasteImport,
            icon: const Icon(Icons.file_open_outlined),
            onPressed: _import,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: Text(l10n.wasteAdd),
      ),
      body: pickups.isEmpty
          ? EmptyState(
              icon: Icons.delete_outline,
              title: l10n.wasteEmptyTitle,
              message: l10n.wasteEmptyMessage,
              action: OutlinedButton.icon(
                onPressed: _import,
                icon: const Icon(Icons.file_open_outlined),
                label: Text(l10n.wasteImport),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in WasteType.values)
                        if (types.contains(t))
                          ActionChip(
                            avatar: CircleAvatar(backgroundColor: Color(t.color)),
                            label: Text(l10n.wasteTypeName(t)),
                            onPressed: () => _typeMenu(t),
                          ),
                    ],
                  ),
                ),
                for (final entry in byDay.entries.take(60))
                  ListTile(
                    title: Text(
                      fmt.formatFullDate(ChoreRepository.parseDay(entry.key)),
                    ),
                    subtitle: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        for (final p in entry.value)
                          Chip(
                            visualDensity: VisualDensity.compact,
                            avatar: CircleAvatar(
                              backgroundColor: Color(
                                WasteType.values[p.type].color,
                              ),
                            ),
                            label: Text(
                              [
                                l10n.wasteTypeName(WasteType.values[p.type]),
                                ?widget.data.member(p.assigneeId)?.name,
                              ].join(' · '),
                            ),
                          ),
                      ],
                    ),
                    titleTextStyle: theme.textTheme.titleMedium,
                  ),
              ],
            ),
    );
  }
}

class _AddPickupSheet extends StatefulWidget {
  const _AddPickupSheet();

  @override
  State<_AddPickupSheet> createState() => _AddPickupSheetState();
}

class _AddPickupSheetState extends State<_AddPickupSheet> {
  WasteType _type = WasteType.residual;
  DateTime _first = DateTime.now().add(const Duration(days: 1));
  int _every = 14;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.wasteAdd, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in WasteType.values)
                  ChoiceChip(
                    avatar: CircleAvatar(backgroundColor: Color(t.color)),
                    label: Text(l10n.wasteTypeName(t)),
                    selected: _type == t,
                    onSelected: (_) => setState(() => _type = t),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(l10n.wasteFirstDate),
              subtitle: Text(
                MaterialLocalizations.of(context).formatFullDate(_first),
              ),
              onTap: () async {
                final now = DateTime.now();
                final d = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 2),
                  initialDate: _first,
                );
                if (d != null) setState(() => _first = d);
              },
            ),
            Text(l10n.wasteRepeat, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                for (final (days, label) in [
                  (0, l10n.wasteOnce),
                  (7, l10n.wasteWeekly),
                  (14, l10n.wasteBiweekly),
                  (28, l10n.wasteFourWeekly),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: _every == days,
                    onSelected: (_) => setState(() => _every = days),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, (_type, _first, _every)),
              child: Text(l10n.commonAdd),
            ),
          ],
        ),
      ),
    );
  }
}

/// Karte „Morgen: Papier · Gelber Sack“ (Aufgaben- und Heute-Seite).
class WasteSoonCard extends StatelessWidget {
  const WasteSoonCard({super.key, required this.data});

  final ChoreData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = ChoreRepository.dayKey(now);
    final tomorrow = ChoreRepository.dayKey(
      DateTime(now.year, now.month, now.day + 1),
    );
    final soon = data.pickups
        .where((p) => p.day == today || p.day == tomorrow)
        .toList();
    if (soon.isEmpty) return const SizedBox.shrink();
    final isToday = soon.any((p) => p.day == today);
    final shown = soon.where((p) => p.day == (isToday ? today : tomorrow));
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Card(
        color: theme.colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isToday ? l10n.wasteToday : l10n.wasteTomorrow,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final p in shown)
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Color(WasteType.values[p.type].color),
                      ),
                      label: Text(
                        [
                          l10n.wasteTypeName(WasteType.values[p.type]),
                          ?data.member(p.assigneeId)?.name,
                        ].join(' · '),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
