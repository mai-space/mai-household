import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../data/data_context.dart';
import '../../domain/shopping/departments.dart';
import '../../domain/shopping/store_order.dart';
import '../../domain/shopping/voice_parser.dart';
import '../../home_widgets/home_widgets.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'add_bar.dart';
import 'item_sheet.dart';
import 'shopping_data.dart';
import 'store_mode_page.dart';
import 'stores_page.dart';
import 'voice_sheet.dart';

/// Eine Einkaufsliste für den ganzen Haushalt; der Laden ist eine Ansicht.
class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  ShoppingData? _data;
  String? _storeId;
  bool _showDone = false;
  List<ProductMemory> _restock = const [];
  StreamSubscription<WidgetLink>? _links;
  final _focusAdd = ValueNotifier<int>(0);

  /// Aktion aus dem Homescreen-Widget, bis die Liste geladen ist.
  String? _pendingAction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_data == null) {
      final services = context.services;
      _links = services.widgets.links.stream.listen(_onWidgetLink);
      _data = ShoppingData(services.shopping)..addListener(_changed);
      services.ctx.setting(SettingKeys.shoppingStore).then((id) {
        if (mounted && id != null && id.isNotEmpty) {
          setState(() => _storeId = id);
        }
      });
    }
  }

  int _lastOpenCount = -1;

  void _onWidgetLink(WidgetLink link) {
    if (link.tab != 1 || link.action == null) return;
    _pendingAction = link.action;
    if (_data!.loaded) _runWidgetAction();
  }

  void _runWidgetAction() {
    final action = _pendingAction;
    _pendingAction = null;
    // Nach dem Reiterwechsel, damit Fokus/Sheet auf der sichtbaren Seite
    // landen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (action == 'voice') {
        _voice();
      } else if (action == 'add') {
        _focusAdd.value++;
      }
    });
  }

  void _changed() {
    final data = _data!;
    if (_pendingAction != null && data.loaded) _runWidgetAction();
    if (_storeId != null && data.loaded && data.store(_storeId) == null) {
      _storeId = null;
    }
    if (data.open.length != _lastOpenCount) {
      _lastOpenCount = data.open.length;
      _loadRestock();
    }
    setState(() {});
  }

  Future<void> _loadRestock() async {
    final r = await context.services.shopping.restockSuggestions();
    if (mounted) setState(() => _restock = r);
  }

  @override
  void dispose() {
    _links?.cancel();
    _focusAdd.dispose();
    _data?.dispose();
    super.dispose();
  }

  void _selectStore(String? id) {
    setState(() => _storeId = id);
    context.services.ctx.setSetting(SettingKeys.shoppingStore, id ?? '');
  }

  Future<void> _voice() async {
    final services = context.services;
    final l10n = context.l10n;
    final data = _data!;
    final sentence = await listenForSentence(
      context,
      title: l10n.shopVoiceTitle,
      hint: l10n.shopVoiceHint,
      phrases: [for (final s in data.stores) s.name],
    );
    if (sentence == null || !mounted) return;
    final items = VoiceParser(storeAliases(data)).parse(sentence);
    if (items.isEmpty) {
      showMessage(context, l10n.voiceNothing);
      return;
    }
    final result = await services.shopping.addItems(items);
    if (!mounted) return;
    showUndo(
      context,
      l10n.shopAddedNames(items.map((i) => i.name).join(', ')),
      undoLabel: l10n.commonUndo,
      onUndo: () => services.shopping.undoAdd(result),
    );
  }

  Future<void> _toggle(ShoppingItem item) async {
    final repo = context.services.shopping;
    if (item.status == ItemStatus.done.index) {
      await repo.setStatus(item, ItemStatus.open);
    } else {
      await repo.setStatus(item, ItemStatus.done, storeId: _storeId);
    }
  }

  Future<void> _startShopping() async {
    final data = _data!;
    var storeId = _storeId;
    if (storeId == null) {
      storeId = await showModalBottomSheet<String>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final l10n = context.l10n;
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Text(
                    l10n.shopWhichStore,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                for (final s in data.stores)
                  ListTile(
                    leading: CircleAvatar(backgroundColor: Color(s.color)),
                    title: Text(s.name),
                    trailing: Text('${data.openCount(s.id)}'),
                    onTap: () => Navigator.pop(context, s.id),
                  ),
              ],
            ),
          );
        },
      );
      if (storeId == null) return;
      _selectStore(storeId);
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StoreModePage(data: data, storeId: storeId!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = _data!;
    final groups = data.groups(_storeId);
    final done = data.done
        .where((i) => ShoppingData.availableIn(i, _storeId))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabShopping),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              final services = context.services;
              switch (v) {
                case 'stores':
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => StoresPage(data: data),
                    ),
                  );
                case 'clear':
                  final n = await services.shopping.clearDone();
                  if (context.mounted) {
                    showMessage(context, l10n.shopCleared(n));
                  }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'stores',
                child: Text(l10n.shopManageStores),
              ),
              PopupMenuItem(
                value: 'clear',
                enabled: data.done.isNotEmpty,
                child: Text(l10n.shopClearDone),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: data.open.isEmpty
          ? null
          : FloatingActionButton.extended(
              heroTag: 'shop',
              onPressed: _startShopping,
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text(
                _storeId == null
                    ? l10n.shopGoShopping
                    : l10n.shopGoShoppingAt(data.store(_storeId)?.name ?? ''),
              ),
            ),
      body: !data.loaded
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _storeChips(data, l10n)),
                SliverToBoxAdapter(
                  child: AddBar(
                    data: data,
                    storeId: _storeId,
                    onVoice: _voice,
                    focusRequest: _focusAdd,
                  ),
                ),
                if (_restock.isNotEmpty)
                  SliverToBoxAdapter(child: _restockRow(l10n)),
                if (groups.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.shopping_basket_outlined,
                      title: l10n.shopEmptyTitle,
                      message: l10n.shopEmptyMessage,
                      action: FilledButton.icon(
                        onPressed: _voice,
                        icon: const Icon(Icons.mic),
                        label: Text(l10n.shopVoiceButton),
                      ),
                    ),
                  ),
                for (final g in groups) ...[
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      l10n.departmentName(g.department),
                      icon: AppIcons.department(g.department.id),
                    ),
                  ),
                  if (g.department.id == BuiltinDepartment.other.id)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                        child: Text(
                          l10n.shopOtherHint,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  SliverList.list(
                    children: [
                      for (final item in g.items) _itemTile(data, item, l10n),
                    ],
                  ),
                ],
                if (done.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      l10n.shopDoneSection(done.length),
                      icon: Icons.check_circle_outline,
                      trailing: IconButton(
                        icon: Icon(
                          _showDone ? Icons.expand_less : Icons.expand_more,
                        ),
                        onPressed: () => setState(() => _showDone = !_showDone),
                      ),
                    ),
                  ),
                  if (_showDone)
                    SliverList.list(
                      children: [
                        for (final item in done.take(50))
                          _itemTile(data, item, l10n),
                      ],
                    ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 96)),
              ],
            ),
    );
  }

  Widget _storeChips(ShoppingData data, AppLocalizations l10n) => SizedBox(
    height: 52,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      scrollDirection: Axis.horizontal,
      children: [
        ChoiceChip(
          label: Text('${l10n.shopAllStores}  ${data.openCount(null)}'),
          selected: _storeId == null,
          onSelected: (_) => _selectStore(null),
        ),
        for (final s in data.stores) ...[
          const SizedBox(width: 8),
          ChoiceChip(
            avatar: CircleAvatar(backgroundColor: Color(s.color)),
            label: Text('${s.name}  ${data.openCount(s.id)}'),
            selected: _storeId == s.id,
            onSelected: (_) => _selectStore(s.id),
          ),
        ],
      ],
    ),
  );

  Widget _restockRow(AppLocalizations l10n) {
    final services = context.services;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 44,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          children: [
            Center(
              child: Text(
                l10n.shopRestock,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            for (final m in _restock) ...[
              const SizedBox(width: 8),
              ActionChip(
                avatar: const Icon(Icons.replay, size: 18),
                label: Text(m.name),
                onPressed: () async {
                  final r = await services.shopping.addItems([
                    ParsedItem(name: m.name),
                  ]);
                  if (!mounted) return;
                  showUndo(
                    context,
                    l10n.shopAddedNames(m.name),
                    undoLabel: l10n.commonUndo,
                    onUndo: () => services.shopping.undoAdd(r),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _itemTile(ShoppingData data, ShoppingItem item, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDone = item.status == ItemStatus.done.index;
    final notFound = data.isNotFound(item);
    final subtitle = itemSubtitle(item, l10n);
    final badges = storeBadges(data, item, _storeId);
    final services = context.services;
    return Dismissible(
      key: ValueKey('item-${item.id}-${item.status}'),
      background: Container(
        color: theme.colorScheme.primaryContainer,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: Icon(isDone ? Icons.undo : Icons.check),
      ),
      secondaryBackground: Container(
        color: theme.colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await _toggle(item);
        } else {
          await services.shopping.delete(item);
          if (mounted) {
            showUndo(
              context,
              l10n.shopDeleted(item.name),
              undoLabel: l10n.commonUndo,
              onUndo: () => services.shopping.restore(item),
            );
          }
        }
        return false;
      },
      child: ListTile(
        onTap: () => _toggle(item),
        onLongPress: () => showItemSheet(context, data, item),
        leading: Icon(
          isDone
              ? Icons.check_circle
              : (notFound ? Icons.help_outline : Icons.radio_button_unchecked),
          color: isDone
              ? theme.colorScheme.primary
              : (notFound ? theme.colorScheme.tertiary : null),
        ),
        title: Text(
          item.name,
          style: isDone
              ? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null,
        ),
        subtitle: notFound || subtitle.isNotEmpty
            ? Text(
                [
                  if (notFound)
                    l10n.shopNotFoundAt(
                      data.store(item.doneStoreId)?.name ?? l10n.shopLastStore,
                    ),
                  if (subtitle.isNotEmpty) subtitle,
                ].join(' · '),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ?badges,
            IconButton(
              icon: const Icon(Icons.more_horiz),
              tooltip: l10n.commonEdit,
              onPressed: () => showItemSheet(context, data, item),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wird auf „Heute“ und im Haushalt gebraucht: Laden-IDs als Liste.
List<String> storeIdsOf(ShoppingItem item) => IdList.parse(item.storeIds);
