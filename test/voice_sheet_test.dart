import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_household/features/shopping/voice_sheet.dart';
import 'package:mai_household/l10n/l10n.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text_platform_interface/speech_to_text_platform_interface.dart';

/// Ahmt das Android-Plugin nach: Bei einem Fehler meldet es erst
/// `notListening`/`doneNoResult` und danach den Fehler (immer „permanent“).
class _FakeSpeech extends SpeechToTextPlatform {
  final listens = <SpeechListenOptions>[];
  int cancels = 0;
  int stops = 0;
  bool listening = false;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> initialize({
    debugLogging = false,
    List<SpeechConfigOption>? options,
  }) async => true;

  @override
  Future<bool> listen({
    String? localeId,
    partialResults = true,
    onDevice = false,
    int listenMode = 0,
    sampleRate = 0,
    SpeechListenOptions? options,
  }) async {
    if (listening) return false;
    listens.add(options!);
    listening = true;
    onStatus?.call('listening');
    return true;
  }

  @override
  Future<void> stop() async {
    stops++;
    _end(resultSent: true);
  }

  @override
  Future<void> cancel() async {
    cancels++;
    _end(resultSent: false);
  }

  void _end({required bool resultSent}) {
    if (!listening) return;
    listening = false;
    onStatus?.call('notListening');
    onStatus?.call(resultSent ? 'done' : 'doneNoResult');
  }

  void fail(String errorMsg) {
    _end(resultSent: false);
    onError?.call(jsonEncode({'errorMsg': errorMsg, 'permanent': true}));
  }

  void hear(String words, {bool last = false}) {
    onTextRecognition?.call(
      jsonEncode({
        'alternates': [
          {'recognizedWords': words, 'confidence': 0.9},
        ],
        'resultType': last ? 2 : 1,
      }),
    );
  }
}

void main() {
  late _FakeSpeech speech;

  setUp(() {
    speech = _FakeSpeech();
    SpeechToTextPlatform.instance = speech;
    resetSpeechForTest(SpeechToText.withMethodChannel());
  });

  /// Blatt schließen und Zeitgeber des Plugins ablaufen lassen.
  Future<void> cleanUp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  }

  /// Öffnet das Blatt und liefert ein Future auf das Ergebnis.
  Future<Future<String?>> open(WidgetTester tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        locale: AppLocale.german,
        supportedLocales: AppLocale.supported,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (c) {
            ctx = c;
            return const Scaffold();
          },
        ),
      ),
    );
    final result = listenForSentence(ctx, title: 'Diktieren', hint: '');
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('fehlt das Sprachpaket, hört die Standard-Erkennung weiter zu', (
    tester,
  ) async {
    final result = await open(tester);
    expect(speech.listens, hasLength(1));
    expect(speech.listens.first.onDevice, isTrue);

    // Erkennung auf dem Gerät: kein deutsches Sprachpaket installiert.
    speech.fail('error_language_unavailable');
    await tester.pumpAndSettle();

    // Zweiter Versuch ohne onDevice — und der darf nicht gleich wieder
    // abgebrochen werden.
    expect(speech.listens, hasLength(2));
    expect(speech.listens.last.onDevice, isFalse);
    expect(speech.cancels, 0);
    expect(speech.listening, isTrue);
    expect(find.text('Ich höre zu …'), findsOneWidget);

    speech.hear('Milch und Eier');
    await tester.pump();
    speech.hear('Milch und Eier', last: true);
    await tester.pumpAndSettle();
    expect(await result, 'Milch und Eier');
    await cleanUp(tester);
  });

  testWidgets('endet die Aufnahme ohne Worte, steht nicht mehr „Ich höre zu“', (
    tester,
  ) async {
    await open(tester);
    expect(find.text('Ich höre zu …'), findsOneWidget);

    // Plugin beendet die Aufnahme ohne Ergebnis und ohne Fehler.
    speech.listening = false;
    speech.onStatus?.call('notListening');
    speech.onStatus?.call('doneNoResult');
    await tester.pumpAndSettle();

    expect(find.text('Ich höre zu …'), findsNothing);
    expect(
      find.text('Nichts gehört. Tippe aufs Mikrofon und sprich.'),
      findsOneWidget,
    );

    // Tippen aufs Mikrofon startet neu.
    await tester.tap(find.byIcon(Icons.mic_none));
    await tester.pumpAndSettle();
    expect(speech.listens, hasLength(2));
    expect(find.text('Ich höre zu …'), findsOneWidget);
    await cleanUp(tester);
  });

  testWidgets('andere Fehler zeigen Eingabefeld statt endlosem Zuhören', (
    tester,
  ) async {
    await open(tester);
    speech.fail('error_audio_error');
    await tester.pumpAndSettle();

    expect(speech.listens, hasLength(1));
    expect(find.text('Ich höre zu …'), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
    await cleanUp(tester);
  });

  testWidgets('wartet vor dem ersten Wort länger als danach', (tester) async {
    await open(tester);
    final firstPause = speech.listens.single.pauseFor!;
    expect(firstPause, greaterThan(const Duration(seconds: 3)));

    // Ohne Worte nach drei Sekunden: noch kein Abbruch.
    await tester.pump(const Duration(seconds: 4));
    expect(speech.stops, 0);
    expect(find.text('Ich höre zu …'), findsOneWidget);
    await cleanUp(tester);
  });
}
