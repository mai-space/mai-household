import 'package:flutter/material.dart';

import '../data/app_database.dart';

/// Farbiger Kreis mit Initiale einer Person.
class MemberAvatar extends StatelessWidget {
  const MemberAvatar(this.member, {super.key, this.size = 28});

  final Member? member;
  final double size;

  @override
  Widget build(BuildContext context) {
    final m = member;
    final color = m == null
        ? Theme.of(context).colorScheme.outlineVariant
        : Color(m.color);
    final initial = m == null || m.name.isEmpty
        ? '?'
        : m.name.characters.first.toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.45,
        ),
      ),
    );
  }
}

/// Kleiner farbiger Laden-Hinweis („Rewe“).
class StoreBadge extends StatelessWidget {
  const StoreBadge(this.store, {super.key, this.dense = false});

  final Store store;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final color = Color(store.color);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 6 : 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Text(
        store.name,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Freundlicher Leerzustand mit Symbol, Text und optionaler Aktion.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}

/// Abschnittsüberschrift in Listen.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.icon, this.trailing});

  final String title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Fortschrittsbalken „frisch → dran“ für Aufgaben. Überfällig wird nicht
/// rot, sondern einfach voll (freundlich statt fordernd).
class FreshnessBar extends StatelessWidget {
  const FreshnessBar(this.progress, {super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = progress.clamp(0.0, 1.0);
    final color = Color.lerp(scheme.primary, scheme.tertiary, p)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: p,
        minHeight: 6,
        color: color,
        backgroundColor: scheme.surfaceContainerHighest,
      ),
    );
  }
}

/// Kurze Rückmeldung mit „Rückgängig“.
void showUndo(
  BuildContext context,
  String message, {
  required String undoLabel,
  required VoidCallback onUndo,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 6),
      action: SnackBarAction(label: undoLabel, onPressed: onUndo),
    ),
  );
}

void showMessage(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

/// Einfacher Texteingabe-Dialog.
Future<String?> askText(
  BuildContext context, {
  required String title,
  String? initial,
  String? hint,
  required String confirm,
  required String cancel,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(hintText: hint),
        onSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text.trim()),
          child: Text(confirm),
        ),
      ],
    ),
  );
}
