import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../domain/shopping/store_order.dart';
import '../../l10n/l10n.dart';
import '../../sync/sync_service.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'item_sheet.dart';
import 'shopping_data.dart';

/// „Ich bin bei …“: nur Artikel für diesen Laden, in Gang-Reihenfolge,
/// große Trefferflächen, Display bleibt an.
///
/// Die Reihenfolge, in der abgehakt wird, verbessert beim Beenden die
/// Gang-Reihenfolge dieses Ladens.
class StoreModePage extends StatefulWidget {
  const StoreModePage({super.key, required this.data, required this.storeId});

  final ShoppingData data;
  final String storeId;

  @override
  State<StoreModePage> createState() => _StoreModePageState();
}

class _StoreModePageState extends State<StoreModePage> {
  /// In diesem Einkauf abgehakte Artikel (für „Im Wagen“ und Rückgängig).
  final _inCart = <String>[];

  /// Abteilungen in Abhak-Reihenfolge.
  final _visited = <String>[];
  bool _showCart = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable().catchError((_) {});
    widget.data.addListener(_changed);
  }

  @override
  void dispose() {
    WakelockPlus.disable().catchError((_) {});
    widget.data.removeListener(_changed);
    super.dispose();
  }

  void _changed() => setState(() {});

  Store? get _store => widget.data.store(widget.storeId);

  Future<void> _check(ShoppingItem item) async {
    _inCart.add(item.id);
    if (_visited.isEmpty || _visited.last != item.departmentId) {
      _visited.add(item.departmentId);
    }
    await context.services.shopping.setStatus(
      item,
      ItemStatus.done,
      storeId: widget.storeId,
    );
  }

  Future<void> _uncheck(ShoppingItem item) async {
    _inCart.remove(item.id);
    await context.services.shopping.setStatus(item, ItemStatus.open);
  }

  Future<void> _notFound(ShoppingItem item) async {
    await context.services.shopping.setStatus(
      item,
      ItemStatus.notFound,
      storeId: widget.storeId,
    );
  }

  bool _finishing = false;

  Future<void> _finish() async {
    if (_finishing) return;
    _finishing = true;
    final services = context.services;
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    await services.shopping.learnStoreOrder(widget.storeId, _visited);
    final left = widget.data.open
        .where((i) => ShoppingData.availableIn(i, widget.storeId))
        .toList();
    final others = widget.data.stores
        .where((s) => s.id != widget.storeId)
        .toList();
    if (left.isNotEmpty && others.isNotEmpty && mounted) {
      final target = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Text(
                  l10n.storeModeLeft(left.length),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              for (final s in others)
                ListTile(
                  leading: CircleAvatar(backgroundColor: Color(s.color)),
                  title: Text(l10n.storeModeMoveTo(s.name)),
                  onTap: () => Navigator.pop(context, s.id),
                ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: Text(l10n.storeModeKeep),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
      if (target != null) {
        for (final item in left) {
          await services.shopping.update(item, storeIds: [target]);
          if (item.status == ItemStatus.notFound.index) {
            await services.shopping.setStatus(item, ItemStatus.open);
          }
        }
      }
    }
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final data = widget.data;
    final groups = data.groups(widget.storeId);
    final cart = [
      for (final id in _inCart.reversed)
        ...data.done.where((i) => i.id == id),
    ];
    final services = context.services;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.storeModeTitle(_store?.name ?? '')),
          actions: [
            ValueListenableBuilder<SyncStatus>(
              valueListenable: services.sync.status,
              builder: (context, s, _) => s.nearby.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Tooltip(
                        message: l10n.syncLive,
                        child: const Icon(Icons.sync, size: 20),
                      ),
                    ),
            ),
            TextButton(onPressed: _finish, child: Text(l10n.storeModeDone)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            if (groups.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: EmptyState(
                  icon: Icons.celebration_outlined,
                  title: l10n.storeModeAllDone,
                  action: FilledButton(
                    onPressed: _finish,
                    child: Text(l10n.storeModeDone),
                  ),
                ),
              ),
            for (final g in groups) ...[
              SectionHeader(
                l10n.departmentName(g.department),
                icon: AppIcons.department(g.department.id),
              ),
              for (final item in g.items)
                Dismissible(
                  key: ValueKey('store-${item.id}-${item.status}'),
                  background: Container(
                    color: theme.colorScheme.primaryContainer,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 24),
                    child: const Icon(Icons.check),
                  ),
                  secondaryBackground: Container(
                    color: theme.colorScheme.tertiaryContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.storeModeNotFound),
                        const SizedBox(width: 8),
                        const Icon(Icons.help_outline),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      await _check(item);
                    } else {
                      await _notFound(item);
                    }
                    return false;
                  },
                  child: _BigTile(
                    item: item,
                    subtitle: [
                      if (data.isNotFound(item)) l10n.storeModeNotFound,
                      itemSubtitle(item, l10n),
                    ].where((s) => s.isNotEmpty).join(' · '),
                    notFound: data.isNotFound(item),
                    onTap: () => _check(item),
                    onLongPress: () => showItemSheet(context, data, item),
                  ),
                ),
            ],
            if (cart.isNotEmpty) ...[
              SectionHeader(
                l10n.storeModeCart(cart.length),
                icon: Icons.shopping_cart_checkout,
                trailing: IconButton(
                  icon: Icon(_showCart ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _showCart = !_showCart),
                ),
              ),
              if (_showCart)
                for (final item in cart)
                  ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: l10n.commonUndo,
                      icon: const Icon(Icons.undo),
                      onPressed: () => _uncheck(item),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BigTile extends StatelessWidget {
  const _BigTile({
    required this.item,
    required this.subtitle,
    required this.notFound,
    required this.onTap,
    required this.onLongPress,
  });

  final ShoppingItem item;
  final String subtitle;
  final bool notFound;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(
                notFound ? Icons.help_outline : Icons.radio_button_unchecked,
                size: 30,
                color: notFound
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.outline,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: theme.textTheme.titleLarge),
                    if (subtitle.isNotEmpty)
                      Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
