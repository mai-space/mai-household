import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../domain/chores/schedule.dart';
import '../../domain/chores/templates.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'chores_page.dart';

/// Aufgabe anlegen oder bearbeiten.
class ChoreFormPage extends StatefulWidget {
  const ChoreFormPage({super.key, required this.data, this.chore});

  final ChoreData data;
  final Chore? chore;

  @override
  State<ChoreFormPage> createState() => _ChoreFormPageState();
}

class _ChoreFormPageState extends State<ChoreFormPage> {
  late final _name = TextEditingController(text: widget.chore?.name ?? '');
  late String _areaId = widget.chore?.areaId ?? BuiltinArea.general.id;
  late Recurrence _recurrence = widget.chore == null
      ? Recurrence.floating
      : Recurrence.values[widget.chore!.recurrence];
  late int _interval = widget.chore?.intervalDays ?? 7;
  late int _weekdays = widget.chore?.weekdays ?? 0;
  late DateTime? _dueDate = widget.chore?.dueDate == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(widget.chore!.dueDate!);
  late int _effort = widget.chore?.effortMinutes ?? Effort.medium.minutes;
  late Assignment _assignment = widget.chore == null
      ? Assignment.none
      : Assignment.values[widget.chore!.assignment];
  late String? _assignee = widget.chore?.assigneeId;
  late bool _remind = widget.chore?.remind ?? true;
  bool _doneToday = false;

  bool get _editing => widget.chore != null;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final repo = context.services.chores;
    final assignee = _assignment == Assignment.none ? null : _assignee;
    if (_editing) {
      await repo.updateChore(
        widget.chore!.id,
        ChoresCompanion(
          name: Value(name),
          areaId: Value(_areaId),
          recurrence: Value(_recurrence.index),
          intervalDays: Value(_interval),
          weekdays: Value(_weekdays),
          dueDate: Value(_dueDate?.millisecondsSinceEpoch),
          effortMinutes: Value(_effort),
          assignment: Value(_assignment.index),
          assigneeId: Value(assignee),
          remind: Value(_remind),
        ),
      );
    } else {
      await repo.addChore(
        name: name,
        areaId: _areaId,
        recurrence: _recurrence,
        intervalDays: _interval,
        weekdays: _weekdays,
        dueDate: _dueDate,
        effortMinutes: _effort,
        assignment: _assignment,
        assigneeId: assignee,
        lastDoneAt: _doneToday ? DateTime.now() : null,
        remind: _remind,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final weekdayNames = MaterialLocalizations.of(context).narrowWeekdays;
    final members = widget.data.members;
    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? l10n.choreEdit : l10n.choreAdd),
        actions: [
          TextButton(onPressed: _save, child: Text(l10n.commonSave)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          TextField(
            controller: _name,
            autofocus: !_editing,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.titleLarge,
            decoration: InputDecoration(
              labelText: l10n.choreName,
              hintText: l10n.choreNameHint,
            ),
          ),
          if (!_editing) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in ChoreTemplate.all)
                  ActionChip(
                    label: Text(l10n.choreTemplateName(t.key)),
                    onPressed: () => setState(() {
                      _name.text = l10n.choreTemplateName(t.key);
                      _areaId = t.area.id;
                      _interval = t.intervalDays;
                      _effort = t.effort.minutes;
                      _recurrence = t.recurrence;
                    }),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Text(l10n.choreArea, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final a in widget.data.areas)
                ChoiceChip(
                  avatar: Icon(AppIcons.area(a.id), size: 18),
                  label: Text(l10n.areaName(a)),
                  selected: _areaId == a.id,
                  onSelected: (_) => setState(() => _areaId = a.id),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(l10n.choreRepeat, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<Recurrence>(
            segments: [
              ButtonSegment(
                value: Recurrence.floating,
                label: Text(l10n.choreRepeatFloating),
              ),
              ButtonSegment(
                value: Recurrence.weekly,
                label: Text(l10n.choreRepeatWeekly),
              ),
              ButtonSegment(
                value: Recurrence.once,
                label: Text(l10n.choreRepeatOnce),
              ),
            ],
            selected: {_recurrence},
            onSelectionChanged: (v) => setState(() => _recurrence = v.first),
          ),
          const SizedBox(height: 12),
          switch (_recurrence) {
            Recurrence.floating => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.choreFloatingHint, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _interval > 1
                          ? () => setState(() => _interval--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Expanded(
                      child: Text(
                        l10n.choreEveryDays(_interval),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () => setState(() => _interval++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    for (final d in const [1, 2, 3, 7, 14, 30])
                      ChoiceChip(
                        label: Text(l10n.choreEveryDays(d)),
                        selected: _interval == d,
                        onSelected: (_) => setState(() => _interval = d),
                      ),
                  ],
                ),
              ],
            ),
            Recurrence.weekly => Wrap(
              spacing: 6,
              children: [
                for (var i = 0; i < 7; i++)
                  FilterChip(
                    // narrowWeekdays beginnt mit Sonntag.
                    label: Text(weekdayNames[(i + 1) % 7]),
                    selected: _weekdays & (1 << i) != 0,
                    onSelected: (v) => setState(
                      () => _weekdays = v
                          ? _weekdays | (1 << i)
                          : _weekdays & ~(1 << i),
                    ),
                  ),
              ],
            ),
            Recurrence.once => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(
                _dueDate == null
                    ? l10n.choreNoDate
                    : MaterialLocalizations.of(
                        context,
                      ).formatFullDate(_dueDate!),
              ),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 5),
                  initialDate: _dueDate ?? now,
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
            ),
          },
          if (!_editing && _recurrence == Recurrence.floating)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _doneToday,
              onChanged: (v) => setState(() => _doneToday = v ?? false),
              title: Text(l10n.choreDoneTodayAlready),
            ),
          const SizedBox(height: 20),
          Text(l10n.choreEffort, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: [
              for (final e in Effort.values)
                ButtonSegment(
                  value: e.minutes,
                  label: Text(l10n.choreEffortMinutes(e.minutes)),
                ),
            ],
            selected: {
              Effort.values
                  .map((e) => e.minutes)
                  .reduce((a, b) => (a - _effort).abs() <= (b - _effort).abs()
                      ? a
                      : b),
            },
            onSelectionChanged: (v) => setState(() => _effort = v.first),
          ),
          const SizedBox(height: 20),
          Text(l10n.choreWho, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChoiceChip(
                label: Text(l10n.choreAnyone),
                selected: _assignment == Assignment.none,
                onSelected: (_) => setState(() {
                  _assignment = Assignment.none;
                  _assignee = null;
                }),
              ),
              for (final m in members)
                ChoiceChip(
                  avatar: MemberAvatar(m, size: 22),
                  label: Text(m.name),
                  selected:
                      _assignment == Assignment.member && _assignee == m.id,
                  onSelected: (_) => setState(() {
                    _assignment = Assignment.member;
                    _assignee = m.id;
                  }),
                ),
              if (members.length > 1)
                ChoiceChip(
                  avatar: const Icon(Icons.autorenew, size: 18),
                  label: Text(l10n.choreRotating),
                  selected: _assignment == Assignment.rotating,
                  onSelected: (_) => setState(() {
                    _assignment = Assignment.rotating;
                    _assignee ??= members.first.id;
                  }),
                ),
            ],
          ),
          if (_assignment == Assignment.rotating)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.choreRotatingHint,
                style: theme.textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.choreRemind),
            subtitle: Text(l10n.choreRemindHint),
            value: _remind,
            onChanged: (v) => setState(() => _remind = v),
          ),
        ],
      ),
    );
  }
}
