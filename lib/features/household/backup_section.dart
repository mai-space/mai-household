import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/services.dart';
import '../../l10n/l10n.dart';
import '../../services/backup_service.dart';
import '../../widgets/common.dart';

/// Haushalt → Sicherung: alle Daten verschlüsselt exportieren und wieder
/// einspielen (neues Handy, Gerät verloren).
class BackupSection extends StatefulWidget {
  const BackupSection({super.key, this.onRestored});

  /// Nach erfolgreichem Wiederherstellen (z. B. Einstellungen neu laden).
  final VoidCallback? onRestored;

  @override
  State<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<BackupSection> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() task) async {
    setState(() => _busy = true);
    try {
      await task();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (!backupSupported) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Text(l10n.backupUnsupported),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.backupIntro),
          const SizedBox(height: 12),
          if (_busy) const LinearProgressIndicator(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy
                      ? null
                      : () => _run(() => createBackup(context)),
                  icon: const Icon(Icons.upload_file),
                  label: Text(l10n.backupCreate),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy
                      ? null
                      : () => _run(() async {
                          if (await restoreBackup(context)) {
                            widget.onRestored?.call();
                          }
                        }),
                  icon: const Icon(Icons.restore),
                  label: Text(l10n.backupRestore),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Verschlüsselte Sicherung erstellen und teilen.
Future<void> createBackup(BuildContext context) async {
  final l10n = context.l10n;
  final passphrase = await _askPassphrase(context, confirm: true);
  if (passphrase == null || !context.mounted) return;
  final service = BackupService(context.services.ctx);
  try {
    final file = await service.createBackupFile(passphrase);
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/octet-stream')],
          fileNameOverrides: [BackupService.suggestedFileName(DateTime.now())],
          subject: l10n.backupShareSubject,
        ),
      );
      if (result.status != ShareResultStatus.dismissed && context.mounted) {
        showMessage(context, l10n.backupCreated);
      }
    } finally {
      try {
        await file.delete();
      } catch (_) {}
    }
  } on BackupException catch (e) {
    if (context.mounted) showMessage(context, e.message);
  } catch (e) {
    debugPrint('Sicherung fehlgeschlagen: $e');
    if (context.mounted) showMessage(context, l10n.backupFailed);
  }
}

/// Sicherung auswählen und **alle** Daten damit ersetzen; `true` bei Erfolg.
Future<bool> restoreBackup(BuildContext context) async {
  final l10n = context.l10n;
  final files = await FilePicker.pickFiles(dialogTitle: l10n.backupPick);
  if (files.isEmpty || !context.mounted) return false;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.backupRestoreConfirmTitle),
      content: Text(l10n.backupRestoreConfirmText),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.backupReplace),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return false;
  final passphrase = await _askPassphrase(context, confirm: false);
  if (passphrase == null || !context.mounted) return false;
  final services = context.services;
  final service = BackupService(services.ctx);
  try {
    final (path, staged) = await _localPath(files.first);
    // Während des Ersetzens nichts mit anderen Geräten abgleichen.
    await services.sync.stop();
    try {
      final createdAt = await service.restoreFile(path, passphrase);
      if (context.mounted) {
        showMessage(
          context,
          l10n.backupRestored(
            DateFormat.yMd(l10n.localeName).add_Hm().format(createdAt.toLocal()),
          ),
        );
      }
      return true;
    } finally {
      if (staged) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
      // Haushaltsschlüssel kann sich geändert haben → Teilen neu starten
      // und den Abgleich anstoßen.
      await services.sync.restart();
      services.ctx.notifyChanged();
      services.scheduleReminders();
    }
  } on BackupException catch (e) {
    if (context.mounted) showMessage(context, e.message);
  } catch (e) {
    debugPrint('Wiederherstellung fehlgeschlagen: $e');
    if (context.mounted) showMessage(context, l10n.backupFailed);
  }
  return false;
}

/// Lokaler Pfad der Auswahl; ohne Pfad (`content://`) wird in den
/// Temp-Ordner kopiert (staged = danach löschen).
Future<(String, bool)> _localPath(PlatformFile file) async {
  final direct = file.path;
  if (direct != null) return (direct, false);
  final target = File(
    p.join(
      (await getTemporaryDirectory()).path,
      'import_${DateTime.now().microsecondsSinceEpoch}.maihh',
    ),
  );
  final sink = target.openWrite();
  try {
    await sink.addStream(file.readAsByteStream());
  } finally {
    await sink.close();
  }
  return (target.path, true);
}

/// Fragt das Sicherungspasswort ab (beim Erstellen doppelt).
Future<String?> _askPassphrase(BuildContext context, {required bool confirm}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _PassphraseDialog(confirm: confirm),
  );
}

class _PassphraseDialog extends StatefulWidget {
  const _PassphraseDialog({required this.confirm});

  final bool confirm;

  @override
  State<_PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<_PassphraseDialog> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _second = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.confirm ? l10n.backupCreate : l10n.backupRestore),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.confirm
                  ? l10n.backupPassphraseCreateHint
                  : l10n.backupPassphraseRestoreHint,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _first,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.backupPassphrase),
              validator: (v) =>
                  (v ?? '').length < BackupCrypto.minPassphraseLength
                  ? l10n.backupPassphraseTooShort
                  : null,
            ),
            if (widget.confirm) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _second,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.backupPassphraseRepeat,
                ),
                validator: (v) =>
                    v != _first.text ? l10n.backupPassphraseMismatch : null,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () {
            if (_form.currentState!.validate()) {
              Navigator.pop(context, _first.text);
            }
          },
          child: Text(l10n.backupContinue),
        ),
      ],
    );
  }
}
