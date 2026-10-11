import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../l10n/l10n.dart';

/// Ein Speech-to-Text-Objekt für die ganze App (Initialisierung ist teuer).
final _speech = SpeechToText();
bool _speechReady = false;

/// Hört zu und liefert den erkannten Satz (oder `null`).
///
/// Nutzt die Spracherkennung des Geräts. Wenn möglich auf dem Gerät
/// (offline); ist dafür kein Sprachpaket installiert, fällt Android auf die
/// Standard-Erkennung zurück.
Future<String?> listenForSentence(
  BuildContext context, {
  required String title,
  required String hint,
  List<String> phrases = const [],
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _VoiceSheet(title: title, hint: hint, phrases: phrases),
);

class _VoiceSheet extends StatefulWidget {
  const _VoiceSheet({
    required this.title,
    required this.hint,
    required this.phrases,
  });

  final String title;
  final String hint;
  final List<String> phrases;

  @override
  State<_VoiceSheet> createState() => _VoiceSheetState();
}

enum _State { starting, listening, unavailable, error }

class _VoiceSheetState extends State<_VoiceSheet> {
  _State _state = _State.starting;
  String _words = '';
  double _level = 0;
  bool _triedOnline = false;
  bool _closing = false;
  final _typed = TextEditingController();

  @override
  void initState() {
    super.initState();
    _start(onDevice: true);
  }

  @override
  void dispose() {
    if (_speech.isListening) _speech.cancel();
    _typed.dispose();
    super.dispose();
  }

  Future<void> _start({required bool onDevice}) async {
    try {
      if (!_speechReady) {
        _speechReady = await _speech.initialize(
          onError: _onError,
          onStatus: _onStatus,
        );
      }
    } catch (_) {
      _speechReady = false;
    }
    if (!mounted) return;
    if (!_speechReady) {
      setState(() => _state = _State.unavailable);
      return;
    }
    _speech.errorListener = _onError;
    _speech.statusListener = _onStatus;
    final locale = AppLocale.current.languageCode == 'de' ? 'de_DE' : 'en_US';
    setState(() => _state = _State.listening);
    await _speech.listen(
      onResult: _onResult,
      onSoundLevelChange: (l) {
        if (mounted) setState(() => _level = l);
      },
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
        onDevice: onDevice,
        localeId: locale,
        listenFor: const Duration(seconds: 45),
        pauseFor: const Duration(seconds: 3),
        contextualPhrases: widget.phrases,
        cancelOnError: true,
      ),
    );
  }

  void _onResult(SpeechRecognitionResult r) {
    if (!mounted) return;
    setState(() => _words = r.recognizedWords);
    if (r.finalResult) _finish();
  }

  void _onStatus(String status) {
    if (!mounted) return;
    if ((status == 'done' || status == 'notListening') &&
        _state == _State.listening &&
        _words.isNotEmpty) {
      _finish();
    }
  }

  void _onError(SpeechRecognitionError e) {
    if (!mounted) return;
    // Kein Offline-Sprachpaket → einmal mit Standard-Erkennung versuchen.
    if (!_triedOnline &&
        _words.isEmpty &&
        (e.errorMsg.contains('language') ||
            e.errorMsg.contains('not_available') ||
            e.errorMsg.contains('server'))) {
      _triedOnline = true;
      _start(onDevice: false);
      return;
    }
    if (_words.isNotEmpty) {
      _finish();
      return;
    }
    setState(() => _state = _State.error);
  }

  void _finish() {
    if (_closing) return;
    _closing = true;
    if (_speech.isListening) _speech.stop();
    final text = _words.trim();
    Navigator.of(context).pop(text.isEmpty ? null : text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final listening = _state == _State.listening;
    final failed = _state == _State.unavailable || _state == _State.error;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            widget.hint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          if (!failed)
            Center(
              child: GestureDetector(
                onTap: listening ? _finish : () => _start(onDevice: true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 96 + (_level.clamp(0, 10) * 4),
                  height: 96 + (_level.clamp(0, 10) * 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: listening
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(
                    listening ? Icons.mic : Icons.mic_none,
                    size: 44,
                    color: listening
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          if (_words.isNotEmpty)
            Text(
              _words,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            )
          else if (!failed)
            Text(
              listening ? l10n.voiceListening : l10n.voiceStarting,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          if (failed) ...[
            Text(
              _state == _State.unavailable
                  ? l10n.voiceUnavailable
                  : l10n.voiceError,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _typed,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: l10n.voiceTypeInstead),
              onSubmitted: (v) =>
                  Navigator.of(context).pop(v.trim().isEmpty ? null : v),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_state == _State.error)
                  TextButton(
                    onPressed: () {
                      setState(() => _state = _State.starting);
                      _start(onDevice: true);
                    },
                    child: Text(l10n.voiceRetry),
                  ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    _typed.text.trim().isEmpty ? null : _typed.text,
                  ),
                  child: Text(l10n.commonAdd),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _words.isEmpty ? null : _finish,
              child: Text(l10n.voiceDone),
            ),
          ],
        ],
      ),
    );
  }
}
