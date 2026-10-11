import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/app_database.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'shopping_data.dart';

const storeColors = <int>[
  0xFF1E5AA8,
  0xFFD52B1E,
  0xFFCC071E,
  0xFFF6C600,
  0xFF2E7D32,
  0xFF6A1B9A,
  0xFFEF6C00,
  0xFF00838F,
  0xFF5D4037,
  0xFF455A64,
];

/// Läden verwalten: hinzufügen, umbenennen, Farbe, Reihenfolge, Gänge.
class StoresPage extends StatefulWidget {
  const StoresPage({super.key, required this.data});

  final ShoppingData data;

  @override
  State<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends State<StoresPage> {
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

  Future<void> _add() async {
    final l10n = context.l10n;
    final repo = context.services.shopping;
    final name = await askText(
      context,
      title: l10n.storesAdd,
      hint: l10n.storesAddHint,
      confirm: l10n.commonAdd,
      cancel: l10n.commonCancel,
    );
    if (name == null || name.isEmpty) return;
    await repo.addStore(
      name,
      storeColors[widget.data.stores.length % storeColors.length],
    );
  }

  Future<void> _edit(Store store) async {
    final l10n = context.l10n;
    final repo = context.services.shopping;
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
            ListTile(
              leading: const Icon(Icons.format_list_numbered),
              title: Text(l10n.storesAisles),
              subtitle: Text(l10n.storesAislesHint),
              onTap: () => Navigator.pop(context, 'aisles'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final c in storeColors)
                    InkWell(
                      onTap: () => Navigator.pop(context, 'color:$c'),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(c),
                        child: c == store.color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.commonDelete),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    if (action == 'rename') {
      final name = await askText(
        context,
        title: l10n.commonRename,
        initial: store.name,
        confirm: l10n.commonSave,
        cancel: l10n.commonCancel,
      );
      if (name != null && name.isNotEmpty) {
        await repo.updateStore(store.id, name: name);
      }
    } else if (action == 'aisles') {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => AislesPage(data: widget.data, storeId: store.id),
        ),
      );
    } else if (action.startsWith('color:')) {
      await repo.updateStore(store.id, color: int.parse(action.substring(6)));
    } else if (action == 'delete') {
      await repo.updateStore(store.id, deleted: true);
      if (mounted) {
        showUndo(
          context,
          l10n.storesDeleted(store.name),
          undoLabel: l10n.commonUndo,
          onUndo: () => repo.updateStore(store.id, deleted: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stores = widget.data.stores;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.shopManageStores)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add_business_outlined),
        label: Text(l10n.storesAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(l10n.storesIntro),
          ),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: true,
            onReorderItem: (from, to) {
              final ids = stores.map((s) => s.id).toList();
              ids.insert(to, ids.removeAt(from));
              context.services.shopping.reorderStores(ids);
            },
            children: [
              for (final s in stores)
                ListTile(
                  key: ValueKey(s.id),
                  leading: CircleAvatar(backgroundColor: Color(s.color)),
                  title: Text(s.name),
                  subtitle: Text(l10n.storesOpen(widget.data.openCount(s.id))),
                  onTap: () => _edit(s),
                ),
            ],
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(l10n.storesDepartments),
            subtitle: Text(l10n.storesDepartmentsHint),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AislesPage(data: widget.data, storeId: null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reihenfolge der Abteilungen — je Laden (Gänge) oder allgemein.
class AislesPage extends StatefulWidget {
  const AislesPage({super.key, required this.data, required this.storeId});

  final ShoppingData data;
  final String? storeId;

  @override
  State<AislesPage> createState() => _AislesPageState();
}

class _AislesPageState extends State<AislesPage> {
  late List<Department> _order = widget.data.orderedDepartments(
    widget.storeId,
  );

  Future<void> _addDepartment() async {
    final l10n = context.l10n;
    final repo = context.services.shopping;
    final name = await askText(
      context,
      title: l10n.storesAddDepartment,
      confirm: l10n.commonAdd,
      cancel: l10n.commonCancel,
    );
    if (name == null || name.isEmpty) return;
    await repo.addDepartment(name);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      setState(
        () => _order = widget.data.orderedDepartments(widget.storeId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final store = widget.data.store(widget.storeId);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          store == null ? l10n.storesDepartments : l10n.storesAislesOf(store.name),
        ),
        actions: [
          if (widget.storeId == null)
            IconButton(
              tooltip: l10n.storesAddDepartment,
              icon: const Icon(Icons.add),
              onPressed: _addDepartment,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              store == null ? l10n.storesDepartmentsHint : l10n.storesAislesHint,
            ),
          ),
          Expanded(
            child: ReorderableListView(
              onReorderItem: (from, to) {
                setState(() {
                  _order.insert(to, _order.removeAt(from));
                });
                context.services.shopping.reorderDepartments(
                  widget.storeId,
                  _order.map((d) => d.id).toList(),
                );
              },
              children: [
                for (final d in _order)
                  ListTile(
                    key: ValueKey(d.id),
                    leading: Icon(AppIcons.department(d.id)),
                    title: Text(l10n.departmentName(d)),
                    onLongPress: d.name == null
                        ? null
                        : () async {
                            final repo = context.services.shopping;
                            final name = await askText(
                              context,
                              title: l10n.commonRename,
                              initial: d.name,
                              confirm: l10n.commonSave,
                              cancel: l10n.commonCancel,
                            );
                            if (name != null && name.isNotEmpty) {
                              await repo.renameDepartment(d.id, name);
                            }
                          },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
