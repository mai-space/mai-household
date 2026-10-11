import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import 'chores_page.dart';

/// Wer hat was gemacht — als Aufwand in Minuten, ohne Rangliste und
/// ohne Punkte. Soll Ausgleich sichtbar machen, nicht Wettbewerb.
class FairnessPage extends StatefulWidget {
  const FairnessPage({super.key, required this.data});

  final ChoreData data;

  @override
  State<FairnessPage> createState() => _FairnessPageState();
}

class _FairnessPageState extends State<FairnessPage> {
  int _days = 7;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final since = DateTime(now.year, now.month, now.day - _days + 1);
    final choreNames = {for (final c in widget.data.chores) c.id: c.name};
    return Scaffold(
      appBar: AppBar(title: Text(l10n.fairnessTitle)),
      body: StreamBuilder<List<ChoreCompletion>>(
        stream: context.services.chores.watchCompletionsSince(since),
        builder: (context, snap) {
          final list = snap.data ?? const <ChoreCompletion>[];
          final minutes = <String?, int>{};
          for (final c in list) {
            minutes[c.memberId] = (minutes[c.memberId] ?? 0) + c.effortMinutes;
          }
          final total = minutes.values.fold(0, (a, b) => a + b);
          final fmt = MaterialLocalizations.of(context);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 7, label: Text(l10n.fairnessWeek)),
                  ButtonSegment(value: 30, label: Text(l10n.fairnessMonth)),
                ],
                selected: {_days},
                onSelectionChanged: (v) => setState(() => _days = v.first),
              ),
              const SizedBox(height: 16),
              Text(l10n.fairnessIntro, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              if (list.isEmpty)
                EmptyState(
                  icon: Icons.spa_outlined,
                  title: l10n.fairnessEmpty,
                ),
              for (final m in widget.data.members)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      MemberAvatar(m, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.name, style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                value: total == 0
                                    ? 0
                                    : (minutes[m.id] ?? 0) / total,
                                color: Color(m.color),
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(l10n.fairnessMinutes(minutes[m.id] ?? 0)),
                    ],
                  ),
                ),
              if (list.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(l10n.fairnessRecent, style: theme.textTheme.titleSmall),
                for (final c in list.take(30))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: MemberAvatar(widget.data.member(c.memberId)),
                    title: Text(choreNames[c.choreId] ?? '—'),
                    subtitle: Text(
                      fmt.formatMediumDate(
                        DateTime.fromMillisecondsSinceEpoch(c.doneAt),
                      ),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
