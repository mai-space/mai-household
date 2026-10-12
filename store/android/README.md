# Play-Store-Material — Haushalt

Alles für den Store-Eintrag in der Play Console (Wachstum › Store-Präsenz ›
Haupt-Store-Eintrag). Deutsch ist die Standardsprache, Englisch eine
Übersetzung (en-US bzw. en-GB).

| Play-Console-Feld | Datei | Grenze |
|---|---|---|
| App-Name | `de/title.txt`, `en/title.txt` | 30 Zeichen |
| Kurzbeschreibung | `de/short_description.txt`, `en/short_description.txt` | 80 Zeichen |
| Vollständige Beschreibung | `de/full_description.txt`, `en/full_description.txt` | 4000 Zeichen |
| App-Symbol | `icon_512.png` (512 × 512, ohne Transparenz) | — |
| Feature-Grafik | `feature_graphic_de.png`, `feature_graphic_en.png` (1024 × 500) | — |
| Smartphone-Screenshots | `screenshots/de/*.png`, `screenshots/en/*.png` (1080 × 1920, 8 Stück) | 2–8 |

Die Screenshots in der Reihenfolge der Dateinamen hochladen
(01 Heute · 02 Einkauf · 03 Ladenmodus · 04 Aufgaben · 05 Müllkalender ·
06 Rezept · 07 Wochenplan · 08 Haushalt & Teilen).

Weitere Angaben:

- **Kategorie:** Haus & Wohnen (House & Home)
- **Kontakt-E-Mail:** joel@maispace.de
- **Entwickler:** maispace (Joël Maximilian Mai)
- **Datenschutzerklärung:** `docs/datenschutz/` bzw. `docs/privacy/` (GitHub Pages) — deren URL gehört ins Feld „Datenschutzerklärung“.

## Wie die Bilder entstanden sind

- **Screenshots:** gerendert aus den echten Bildschirmen der App per
  Flutter-Widget-Test, ohne Gerät — mit frei erfundenen Beispieldaten
  (Haushalt „Lena“, „Tom“, „Mia“) in einer In-Memory-Datenbank. Es sind
  keine echten Nutzerdaten enthalten. Keine Statusleiste, da kein echtes
  Gerät. Datumsangaben entsprechen dem Tag der Erzeugung.
- **Icon und Feature-Grafik:** aus `assets/branding/logo.svg` und den
  Screenshots per Chromium gerendert. Das Icon hat eckige Ecken mit Rand —
  Google Play rundet es selbst ab.

Neu erzeugen (aus dem Repo-Wurzelordner):

```bash
flutter test tool/store_screenshots/store_screenshots_test.dart
ROBOTO_DIR="$(dirname "$(which flutter)")/cache/artifacts/material_fonts" \
  node tool/store_screenshots/render_graphics.mjs   # braucht Playwright
```

Die Texte beschreiben nur, was die App tatsächlich kann. Bei neuen
Funktionen Texte und Screenshots hier mitpflegen.
