import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/services.dart';
import '../../data/repositories/shopping_repository.dart';
import '../../domain/shopping/voice_parser.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';
import '../../widgets/labels.dart';
import 'shopping_data.dart';

/// Eingabezeile „Was fehlt?“ mit Vorschlägen aus der eigenen Historie.
///
/// Versteht dieselben Sätze wie die Spracheingabe („2 l Milch, Eier bei
/// Rewe“). Nach dem Hinzufügen bleibt der Fokus im Feld, damit man direkt
/// weitertippen kann.
class AddBar extends StatefulWidget {
  const AddBar({
    super.key,
    required this.data,
    required this.storeId,
    required this.onVoice,
    this.focusRequest,
  });

  final ShoppingData data;
  final String? storeId;
  final VoidCallback onVoice;

  /// Feuert, wenn das Eingabefeld den Fokus bekommen soll (z. B. „+“ im
  /// Homescreen-Widget).
  final Listenable? focusRequest;

  @override
  State<AddBar> createState() => _AddBarState();
}

class _AddBarState extends State<AddBar> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  List<ItemSuggestion> _suggestions = const [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.focusRequest?.addListener(_requestFocus);
    _focus.addListener(() {
      if (_focus.hasFocus) _load();
      if (!_focus.hasFocus) setState(() => _suggestions = const []);
    });
  }

  void _requestFocus() => _focus.requestFocus();

  @override
  void didUpdateWidget(AddBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusRequest != widget.focusRequest) {
      oldWidget.focusRequest?.removeListener(_requestFocus);
      widget.focusRequest?.addListener(_requestFocus);
    }
  }

  @override
  void dispose() {
    widget.focusRequest?.removeListener(_requestFocus);
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), _load);
  }

  Future<void> _load() async {
    final text = _controller.text;
    // Nur das letzte Stück nach einem Komma vervollständigen.
    final last = text.split(',').last.trim();
    final s = await context.services.shopping.suggestions(last);
    if (mounted && _focus.hasFocus) setState(() => _suggestions = s);
  }

  Future<void> _submit([String? override]) async {
    final services = context.services;
    final l10n = context.l10n;
    final text = override ?? _controller.text;
    if (text.trim().isEmpty) return;
    final parser = VoiceParser(storeAliases(widget.data));
    final items = parser.parse(text);
    if (items.isEmpty) return;
    _controller.clear();
    setState(() => _suggestions = const []);
    final result = await services.shopping.addItems(items);
    if (!mounted) return;
    _load();
    showUndo(
      context,
      l10n.shopAdded(result.count),
      undoLabel: l10n.commonUndo,
      onUndo: () => services.shopping.undoAdd(result),
    );
  }

  Future<void> _pickSuggestion(ItemSuggestion s) async {
    final parts = _controller.text.split(',');
    parts.removeLast();
    final prefix = parts.isEmpty ? '' : '${parts.join(',')}, ';
    await _submit('$prefix${s.name}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: TextField(
            controller: _controller,
            focusNode: _focus,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            onChanged: _onChanged,
            onSubmitted: (_) {
              _submit();
              _focus.requestFocus();
            },
            decoration: InputDecoration(
              hintText: l10n.shopAddHint,
              prefixIcon: const Icon(Icons.add),
              suffixIcon: IconButton(
                tooltip: l10n.shopVoiceTooltip,
                icon: const Icon(Icons.mic_none),
                onPressed: widget.onVoice,
              ),
            ),
          ),
        ),
        if (_suggestions.isNotEmpty)
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _suggestions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = _suggestions[i];
                final dep = s.departmentId == null
                    ? null
                    : widget.data.department(s.departmentId!);
                return ActionChip(
                  avatar: Icon(
                    s.fromHistory
                        ? Icons.history
                        : (dep == null
                              ? Icons.add
                              : AppIcons.department(dep.id)),
                    size: 18,
                  ),
                  label: Text(s.name),
                  tooltip: dep == null ? null : l10n.departmentName(dep),
                  onPressed: () => _pickSuggestion(s),
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Laden-Namen, wie sie gesprochen/getippt werden.
List<StoreAlias> storeAliases(ShoppingData data) => [
  for (final s in data.stores)
    StoreAlias(s.id, {
      s.name.toLowerCase(),
      s.name.toLowerCase().replaceAll('-', ' '),
    }.toList()),
];
