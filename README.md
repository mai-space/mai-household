# Mai Household

Haushalts-App für Paare, Familien und WGs — **lokal, ohne Konto, ohne Cloud**.

- **Einkauf:** eine Liste für alle; Artikel landen automatisch in der
  richtigen Abteilung (Wörterbuch + eigene Historie). Läden (Aldi, HIT, Rewe,
  Netto, eigene) als Filter; **Ladenmodus** zeigt nur, was es dort gibt, in
  Gang-Reihenfolge — die Reihenfolge lernt aus dem Abhaken. Spracheingabe:
  „Zwei Liter Milch, Eier und Spülmittel bei Rewe“.
- **Aufgaben:** Staubsaugen, Boden wischen, Müll … „alle N Tage nach letzter
  Erledigung“, feste Wochentage oder einmalig; reihum; Frische-Balken statt
  roter Zähler; Müllkalender (auch `.ics`-Import) mit Erinnerung am Vorabend;
  Ausgleichs-Ansicht „Wer hat was gemacht“.
- **Küche:** Rezeptbuch (Portionen skalieren, Tipps, Familiengeschichte,
  Sammlungen), ganzes Rezept als Text einfügen, Kochmodus mit Timern,
  Wochenplan → Zutaten der Woche auf die Einkaufsliste.
- **Teilen:** QR-Code zeigen/scannen; danach gleichen sich die Geräte im
  selben WLAN direkt ab (UDP-Suche + HTTP, AES-256-GCM mit dem
  Haushaltsschlüssel aus dem QR-Code). Kein Server.
- **Homescreen-Widgets (Android):** Aufgaben heute, Einkaufsliste und
  Essensplan — frei skalierbar (kleine Zeile bis große Liste), direkt
  abhaken; „+“ und Mikrofon öffnen die Eingabe. Abgehaktes trägt die App
  beim nächsten Öffnen ein (`lib/home_widgets/`,
  `android/…/widgets/`).

Konzept und UX-Begründung: [`docs/KONZEPT.md`](docs/KONZEPT.md)

## Entwicklung

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # nach Schema-Änderungen
python3 tool/merge_arb.py && flutter gen-l10n              # nach Text-Änderungen
flutter analyze
flutter test
flutter build apk --release
```

CI (`.github/workflows/ci.yml`) baut bei jedem Push eine Release-APK
(Artefakt `mai-household-apk`, mit Debug-Schlüssel signiert).
