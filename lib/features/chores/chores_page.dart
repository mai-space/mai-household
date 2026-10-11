import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/repositories/chore_repository.dart';
import '../../domain/chores/schedule.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'chore_form_page.dart';
import 'fairness_page.dart';
import 'waste_page.dart';

/// Live-Daten für Aufgaben-Ansichten.
class ChoreData extends ChangeNotifier {
  ChoreData(AppServices s) {
    _subs = [
      s.chores.watchChores().listen((v) => _set(() => chores = v)),
      s.chores.watchAreas().listen((v) => _set(() => areas = v)),
      s.household.watchMembers().listen((v) => _set(() => members = v)),
      s.chores
          .watchPickupsFrom(DateTime.now())
          .listen((v) => _set(() => pickups = v)),
    ];
  }

  late final List<StreamSubscription<Object?>> _subs;
  List<Chore> chores = const [];
  List<Area> areas = const [];
  List<Member> members = const [];
  List<WastePickup> pickups = const [];
  int _loaded = 0;
  bool get loaded => _loaded >= 4;

  void _set(VoidCallback f) {
    f();
    if (_loaded < 4) _loaded++;
    notifyListeners();
  }

  Member? member(String? id) {
    if (id == null) return null;
    for (final m in members) {
      if (m.id == id) return m;
    }
    return null;
  }

  Area? area(String id) {
    for (final a in areas) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }
}

class ChoresPage extends StatefulWidget {
  const ChoresPage({super.key});

  @override
  State<ChoresPage> createState() => _ChoresPageState();
}

class _ChoresPageState extends State<ChoresPage> {
  ChoreData? _data;
  bool _mine = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data ??= ChoreData(context.services)..addListener(_changed);
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _data?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = _data!;
    final me = context.services.ctx.memberId;
    final today = DateTime.now();
    final states = ChoreRepository.ranked(data.chores, today)
        .where(
          (s) =>
              !_mine ||
              s.chore.assigneeId == null ||
              s.chore.assigneeId == me,
        )
        .toList();
    final due = states.where((s) => s.timing.isDue).toList();
    final soon = states
        .where((s) => !s.timing.isDue && s.timing.daysUntilDue <= 7)
        .toList();
    final later = states.where((s) => s.timing.daysUntilDue > 7).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabChores),
        actions: [
          IconButton(
            tooltip: l10n.wasteTitle,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => WastePage(data: data)),
            ),
          ),
          IconButton(
            tooltip: l10n.fairnessTitle,
            icon: const Icon(Icons.balance_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => FairnessPage(data: data)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'chore',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => ChoreFormPage(data: data)),
        ),
        icon: const Icon(Icons.add_task),
        label: Text(l10n.choreAdd),
      ),
      body: !data.loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(value: false, label: Text(l10n.choreAll)),
                      ButtonSegment(value: true, label: Text(l10n.choreMine)),
                    ],
                    selected: {_mine},
                    onSelectionChanged: (v) => setState(() => _mine = v.first),
                  ),
                ),
                WasteSoonCard(data: data),
                if (states.isEmpty)
                  EmptyState(
                    icon: Icons.task_alt,
                    title: l10n.choreEmptyTitle,
                    message: l10n.choreEmptyMessage,
                  ),
                if (due.isNotEmpty) ...[
                  SectionHeader(l10n.choreSectionDue, icon: Icons.bolt),
                  for (final s in due) ChoreTile(state: s, data: data),
                ],
                if (soon.isNotEmpty) ...[
                  SectionHeader(l10n.choreSectionSoon, icon: Icons.schedule),
                  for (final s in soon) ChoreTile(state: s, data: data),
                ],
                if (later.isNotEmpty) ...[
                  SectionHeader(
                    l10n.choreSectionLater,
                    icon: Icons.event_available,
                  ),
                  for (final s in later) ChoreTile(state: s, data: data),
                ],
              ],
            ),
    );
  }
}

/// „Seit 2 Tagen dran“, „Heute“, „In 3 Tagen“, „Morgen“.
String dueText(ChoreTiming t, AppLocalizations l10n) {
  final d = t.daysUntilDue;
  if (d < 0) return l10n.choreDueSince(-d);
  if (d == 0) return l10n.choreDueToday;
  if (d == 1) return l10n.choreDueTomorrow;
  return l10n.choreDueIn(d);
}

/// Aufgabe in Listen: Name, Fälligkeit, Zuständig, Frische-Balken, Haken.
class ChoreTile extends StatelessWidget {
  const ChoreTile({super.key, required this.state, required this.data});

  final ChoreState state;
  final ChoreData data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final chore = state.chore;
    final assignee = data.member(chore.assigneeId);
    final area = data.area(chore.areaId);
    return InkWell(
      onTap: () => showChoreSheet(context, data, chore),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Icon(AppIcons.area(chore.areaId), color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chore.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    [
                      dueText(state.timing, l10n),
                      if (area != null) l10n.areaName(area),
                      if (chore.assignment == Assignment.rotating.index)
                        l10n.choreRotating,
                    ].join(' · '),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  FreshnessBar(state.timing.progress),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (assignee != null) MemberAvatar(assignee, size: 26),
            IconButton(
              iconSize: 32,
              tooltip: l10n.choreDone,
              icon: Icon(
                Icons.check_circle_outline,
                color: theme.colorScheme.primary,
              ),
              onPressed: () => completeChore(context, chore),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> completeChore(BuildContext context, Chore chore) async {
  final services = context.services;
  final l10n = context.l10n;
  final undo = await services.chores.complete(
    chore,
    memberId: services.ctx.memberId,
  );
  if (!context.mounted) return;
  showUndo(
    context,
    l10n.choreCompleted(chore.name),
    undoLabel: l10n.commonUndo,
    onUndo: () => services.chores.undoComplete(undo),
  );
}

/// Details: Verlauf, Verschieben, Bearbeiten, Löschen.
Future<void> showChoreSheet(
  BuildContext context,
  ChoreData data,
  Chore chore,
) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (sheetContext) {
    final l10n = sheetContext.l10n;
    final services = sheetContext.services;
    final theme = Theme.of(sheetContext);
    final timing = ChoreRepository.timingOf(chore, DateTime.now());
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(chore.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(dueText(timing, l10n)),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.check),
              label: Text(l10n.choreDoneByMe),
              onPressed: () {
                Navigator.pop(sheetContext);
                completeChore(context, chore);
              },
            ),
            if (data.members.length > 1) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final m in data.members)
                    if (m.id != services.ctx.memberId)
                      ActionChip(
                        avatar: MemberAvatar(m, size: 22),
                        label: Text(l10n.choreDoneBy(m.name)),
                        onPressed: () async {
                          Navigator.pop(sheetContext);
                          final undo = await services.chores.complete(
                            chore,
                            memberId: m.id,
                          );
                          if (!context.mounted) return;
                          showUndo(
                            context,
                            l10n.choreCompleted(chore.name),
                            undoLabel: l10n.commonUndo,
                            onUndo: () => services.chores.undoComplete(undo),
                          );
                        },
                      ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.snooze),
              label: Text(l10n.choreSnooze),
              onPressed: () {
                Navigator.pop(sheetContext);
                services.chores.snooze(chore);
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<ChoreCompletion>>(
              future: services.chores.completionsOf(chore.id),
              builder: (context, snap) {
                final list = snap.data ?? const [];
                if (list.isEmpty) return const SizedBox.shrink();
                final fmt = MaterialLocalizations.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.choreHistory, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    for (final c in list.take(5))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            MemberAvatar(data.member(c.memberId), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              fmt.formatMediumDate(
                                DateTime.fromMillisecondsSinceEpoch(c.doneAt),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.commonDelete),
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    services.chores.deleteChore(chore.id);
                    showUndo(
                      context,
                      l10n.choreDeleted(chore.name),
                      undoLabel: l10n.commonUndo,
                      onUndo: () => services.chores.updateChore(
                        chore.id,
                        const ChoresCompanion(deleted: Value(false)),
                      ),
                    );
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.commonEdit),
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ChoreFormPage(data: data, chore: chore),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
);
