import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/data_context.dart';
import '../../data/seed.dart';
import '../../domain/chores/templates.dart';
import '../../domain/shopping/departments.dart';
import '../../l10n/l10n.dart';
import '../../widgets/labels.dart';
import '../household/share_pages.dart';

/// Einrichten in drei kurzen Schritten — antippen statt ausfüllen.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _name = TextEditingController();
  final _pages = PageController();
  int _step = 0;
  final _stores = BuiltinStore.values.toSet();
  late final _templates = {
    for (final t in ChoreTemplate.all)
      if (t.preselected) t.key,
  };
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    _pages.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _base() async {
    final s = context.services;
    await seedBuiltins(s.ctx, stores: _stores);
    await s.ctx.setSetting(SettingKeys.myName, _name.text.trim());
    await s.household.setMyName(_name.text.trim());
  }

  Future<void> _finish() async {
    if (_busy) return;
    setState(() => _busy = true);
    final s = context.services;
    final l10n = context.l10n;
    await _base();
    for (final t in ChoreTemplate.all) {
      if (!_templates.contains(t.key)) continue;
      await s.chores.addChore(
        name: l10n.choreTemplateName(t.key),
        areaId: t.area.id,
        intervalDays: t.intervalDays,
        effortMinutes: t.effort.minutes,
        recurrence: t.recurrence,
      );
    }
    await s.ctx.setSetting(SettingKeys.onboarded, '1');
    widget.onDone();
  }

  Future<void> _joinExisting() async {
    if (_busy) return;
    setState(() => _busy = true);
    final s = context.services;
    await _base();
    await s.ctx.setSetting(SettingKeys.onboarded, '1');
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ScanPage()),
    );
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final nameOk = _name.text.trim().isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / 3),
            Expanded(
              child: PageView(
                controller: _pages,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Icon(
                        Icons.cottage_outlined,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.onboardingWelcome,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.onboardingIntro, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _name,
                        autofocus: true,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => nameOk ? _next() : null,
                        decoration: InputDecoration(
                          labelText: l10n.onboardingName,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: nameOk ? _next : null,
                        child: Text(l10n.onboardingStart),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: nameOk && !_busy ? _joinExisting : null,
                        icon: const Icon(Icons.qr_code_scanner),
                        label: Text(l10n.onboardingJoin),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.onboardingJoinHint,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        l10n.onboardingStores,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.onboardingStoresHint),
                      const SizedBox(height: 16),
                      for (final s in BuiltinStore.values)
                        CheckboxListTile(
                          value: _stores.contains(s),
                          onChanged: (v) => setState(
                            () => v == true ? _stores.add(s) : _stores.remove(s),
                          ),
                          secondary: CircleAvatar(
                            backgroundColor: Color(s.color),
                          ),
                          title: Text(s.label),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.onboardingStoresMore,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),
                      FilledButton(onPressed: _next, child: Text(l10n.commonNext)),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        l10n.onboardingChores,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.onboardingChoresHint),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in ChoreTemplate.all)
                            FilterChip(
                              avatar: Icon(AppIcons.area(t.area.id), size: 18),
                              label: Text(l10n.choreTemplateName(t.key)),
                              selected: _templates.contains(t.key),
                              onSelected: (v) => setState(
                                () => v
                                    ? _templates.add(t.key)
                                    : _templates.remove(t.key),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: _busy ? null : _finish,
                        child: Text(l10n.onboardingFinish),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
