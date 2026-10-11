import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/data_context.dart';
import '../../data/repositories/shopping_repository.dart';
import '../../domain/text/quantity.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'shopping_data.dart';

/// Artikel bearbeiten: Name, Menge, Notiz, Laden, Abteilung, Vorrat.
Future<void> showItemSheet(
  BuildContext context,
  ShoppingData data,
  ShoppingItem item,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _ItemSheet(data: data, item: item),
);

class _ItemSheet extends StatefulWidget {
  const _ItemSheet({required this.data, required this.item});

  final ShoppingData data;
  final ShoppingItem item;

  @override
  State<_ItemSheet> createState() => _ItemSheetState();
}

class _ItemSheetState extends State<_ItemSheet> {
  late final _name = TextEditingController(text: widget.item.name);
  late final _amount = TextEditingController(
    text: widget.item.amount == null
        ? ''
        : Quantity.formatAmount(widget.item.amount!),
  );
  late final _unit = TextEditingController(text: widget.item.unit ?? '');
  late final _note = TextEditingController(text: widget.item.note ?? '');
  late Set<String> _stores = IdList.parse(widget.item.storeIds).toSet();
  late String _department = widget.item.departmentId;
  ProductMemory? _memory;

  @override
  void initState() {
    super.initState();
    context.services.shopping.memoryFor(widget.item.name).then((m) {
      if (mounted) setState(() => _memory = m);
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _unit.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final repo = context.services.shopping;
    final amountText = _amount.text.trim().replaceAll(',', '.');
    final parsedAmount = amountText.isEmpty
        ? null
        : Quantity.parse('$amountText x').amount ?? double.tryParse(amountText);
    await repo.update(
      widget.item,
      name: _name.text,
      amount: Value(parsedAmount),
      unit: Value(_unit.text.trim().isEmpty ? null : _unit.text.trim()),
      note: Value(_note.text.trim().isEmpty ? null : _note.text.trim()),
      storeIds: _stores.toList(),
    );
    if (_department != widget.item.departmentId) {
      await repo.moveToDepartment(widget.item, _department);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final preferred = _memory == null
        ? null
        : widget.data.store(StoreCounts.preferred(_memory!.storeCounts));
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              style: theme.textTheme.titleLarge,
              decoration: InputDecoration(labelText: l10n.shopItemName),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(labelText: l10n.shopAmount),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _unit,
                    decoration: InputDecoration(
                      labelText: l10n.shopUnit,
                      hintText: 'l, g, Pck.',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.shopNote),
            ),
            const SizedBox(height: 20),
            Text(l10n.shopWhere, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.shopAnyStore),
                  selected: _stores.isEmpty,
                  onSelected: (_) => setState(() => _stores = {}),
                ),
                for (final s in widget.data.stores)
                  FilterChip(
                    label: Text(s.name),
                    avatar: CircleAvatar(backgroundColor: Color(s.color)),
                    selected: _stores.contains(s.id),
                    onSelected: (v) => setState(() {
                      _stores = {..._stores};
                      v ? _stores.add(s.id) : _stores.remove(s.id);
                    }),
                  ),
              ],
            ),
            if (preferred != null && !_stores.contains(preferred.id)) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: ActionChip(
                  avatar: const Icon(Icons.lightbulb_outline, size: 18),
                  label: Text(l10n.shopUsuallyAt(preferred.name)),
                  onPressed: () => setState(() => _stores = {preferred.id}),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(l10n.shopDepartment, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              l10n.shopDepartmentHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final d in widget.data.departments)
                  ChoiceChip(
                    avatar: Icon(AppIcons.department(d.id), size: 18),
                    label: Text(l10n.departmentName(d)),
                    selected: _department == d.id,
                    onSelected: (_) => setState(() => _department = d.id),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.shopStaple),
              subtitle: Text(l10n.shopStapleHint),
              value: _memory?.staple ?? false,
              onChanged: (v) async {
                final repo = context.services.shopping;
                await repo.setStaple(widget.item.name, v);
                final m = await repo.memoryFor(widget.item.name);
                if (mounted) setState(() => _memory = m);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.commonDelete),
                  onPressed: () async {
                    final services = context.services;
                    final messenger = ScaffoldMessenger.of(context);
                    await services.shopping.delete(widget.item);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(l10n.shopDeleted(widget.item.name)),
                        action: SnackBarAction(
                          label: l10n.commonUndo,
                          onPressed: () =>
                              services.shopping.restore(widget.item),
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Untertitel eines Artikels: Menge · Notiz · Herkunft.
String itemSubtitle(ShoppingItem item, AppLocalizations l10n) {
  final decimal = AppLocale.current.languageCode == 'de' ? ',' : '.';
  return [
    Quantity.label(item.amount, item.unit, decimal: decimal),
    ?item.note,
    if (item.source != null) l10n.shopFor(item.source!),
  ].where((s) => s.isNotEmpty).join(' · ');
}

/// Kleines Symbol, falls ein Artikel nur in bestimmten Läden gekauft wird.
Widget? storeBadges(ShoppingData data, ShoppingItem item, String? current) {
  final ids = IdList.parse(item.storeIds);
  if (ids.isEmpty) return null;
  final stores = [
    for (final id in ids)
      if (id != current) ?data.store(id),
  ];
  if (stores.isEmpty) return null;
  return Wrap(
    spacing: 4,
    children: [for (final s in stores) StoreBadge(s, dense: true)],
  );
}
