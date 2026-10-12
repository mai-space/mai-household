# Mai Household — UX- und Produktkonzept

Stand: 11.10.2026 · Status: Entwurf zur Abstimmung

Eine Haushalts-App für Paare, WGs und Familien: **Einkaufsliste**, die sich
selbst nach Abteilung und Supermarkt sortiert, **wiederkehrende Aufgaben**
(Boden wischen, Saugen, Müll) und ein **Rezeptbuch**, das direkt in die
Einkaufsliste kocht. Gestaltet nach dem menschzentrierten Prozess der
DIN EN ISO 9241-210 — wie schon das Rezept-Konzept
(`design-concept-sharing-recipes`).

---

## 1. Was wir aus den bestehenden Projekten übernehmen

| Quelle | Was sich bewährt hat | Übernahme in Mai Household |
|--------|----------------------|----------------------------|
| **mai-doctor-hub** (Flutter) | Flutter + drift/SQLite (verschlüsselt), DE/EN per `lib/l10n/parts/*.json` + `merge_arb.py`, 4-Tab-`NavigationBar`, `IndexedStack`, Repository-Schicht mit reaktiven Streams, lokale Notifications ohne Server, verschlüsselte `.maibackup`-Sicherung (`packages/mai_backup_format`), Autovervollständigung aus eigener Historie (`SuggestionRepository`), On-Device-KI (Gemma via LiteRT-LM) opt-in, CI mit `flutter analyze`/`flutter test`/APK, strikte Regeln zu additiven Migrationen | Gleicher Stack, gleiche Projektstruktur (`lib/features/…`, `lib/data/repositories/…`, `lib/services/…`), gleiche CLAUDE.md-Regeln zur Rückwärtskompatibilität ab dem ersten Release, Backup-Paket wiederverwenden |
| **shopping-list** (Koffan, Go/HTMX) | Abschnitte (Sections) mit `sort_order`, „unsicher“-Markierung (nicht gefunden), Abhaken ohne Löschen, `item_history` merkt sich **letzte Abteilung pro Produkt** → nächstes Mal automatisch richtig, Fuzzy-Vorschläge (Levenshtein), Offline-Operationslog mit idempotenter Synchronisation, Echtzeit-Sync per WebSocket für mehrere Einkaufende, „Gekaufte löschen“ als Sammelaktion | Abteilungs-Lernen aus der Historie, Unsicher-Status, Operationslog als Basis für Haushalts-Sync, Bulk-Aktionen |
| **design-concept-sharing-recipes** | Umfrage: 100 % kochen mit dem Smartphone → Mobile First; eigene Sammlungen (100 %) wichtiger als Lesezeichen; Offline-Lesen wichtig (64 %); Anekdoten/Familienkommentare erkennbar, aber am Seitenende; Tipps & Tricks als zugeklapptes Akkordeon über der Anleitung; Portionen in der Detailansicht skalierbar; Zutaten in Verwendungsreihenfolge; Filter-Taxonomie (Herkunft, Ernährungsart, Unverträglichkeit, Anlass, Saison); Typografie: dicke Überschriften, dünne Labels, gerahmte Listen | Rezept-Datenmodell (Zutat, Schritt, Haushaltsgerät, Anekdote, Sammlung), Kategorien als Tags, Layout-Erkenntnisse. **Anders:** kein 14-Schritte-Wizard (zu lang für den Alltag) — siehe 5.3 |

---

## 2. Nutzungskontext (ISO 9241-210, Schritt 1)

### Personas

- **Lena (34), plant für die Familie.** Schreibt Einkäufe nebenbei auf, oft mit
  Kind auf dem Arm oder Händen im Teig → *Sprache, eine Hand, kein Tippen.*
- **Tom (36), kauft auf dem Heimweg ein.** Entscheidet spontan, ob Aldi oder
  Rewe auf dem Weg liegt → *will nur sehen, was es in diesem Laden gibt, in
  Gang-Reihenfolge.*
- **Mia (15), soll im Haushalt helfen.** Reagiert auf klare, kleine Aufgaben,
  nicht auf Vorwürfe → *sichtbare Fairness, kein Nörgel-Push.*
- **Oma Ingrid (71), Familienrezepte.** Will Rezepte weitergeben, nicht
  Formulare ausfüllen → *Foto vom Rezeptzettel reicht.*

### Nutzungssituationen

| Situation | Umgebung | Konsequenz für die Gestaltung |
|-----------|----------|-------------------------------|
| Kühlschrank offen, „Milch ist alle“ | Hände voll, 5 Sekunden Zeit | Sprachaufnahme mit einem Tap / vom Sperrbildschirm-Widget; keine Rückfrage, nur Undo |
| Im Supermarkt | Schlechtes Netz, eine Hand am Wagen, grelles Licht | Offline, große Trefferflächen (≥ 56 dp), hoher Kontrast, Display bleibt an, Abhaken per Wisch |
| Sonntag Wochenplanung | Sofa, Zeit, gemeinsam | Rezepte → Wochenplan → Einkaufsliste in einem Fluss |
| Abends Müll | Routine | Erinnerung *am Vorabend* der Abholung, nicht am Morgen |
| Putzen | Sporadisch, „wenn’s nötig ist“ | Fälligkeit relativ zur letzten Erledigung, nicht starre Termine |

### Leitprinzipien

1. **Erfassen ohne Nachdenken.** Jede Eingabe (Sprache, Text, Rezept) wird
   sofort einsortiert. Der Mensch korrigiert, die App fragt nicht vorher.
2. **Die App lernt, statt zu konfigurieren.** Abteilung, Laden und Gang-
   Reihenfolge werden aus Verhalten gelernt; Einstellungen sind optional.
3. **Freundlich statt fordernd.** Aufgaben zeigen Zustand („Bad ist bald
   wieder dran“), keine roten Überfällig-Zähler, keine Rangliste.
4. **Lokal zuerst.** Alles funktioniert offline; Teilen im Haushalt ist ein
   bewusster Schritt (Privacy first wie im Doctor Hub).
5. **Ein Haushalt, mehrere Menschen.** Jede Liste/Aufgabe ist geteilt,
   Zuweisung ist Einladung, nicht Pflicht.

---

## 3. Informationsarchitektur

```
┌──────────────────────────────────────────────────────────┐
│  Heute   │   Einkauf   │   Aufgaben   │   Küche          │  ← NavigationBar
└──────────────────────────────────────────────────────────┘
            🎤 Globaler Sprach-FAB auf jedem Tab
            ⚙ Haushalt & Einstellungen über Avatar oben rechts
```

| Tab | Inhalt |
|-----|--------|
| **Heute** | Was heute dran ist: fällige Aufgaben (meine zuerst), Müllabfuhr morgen, heutiges Gericht aus dem Wochenplan, Einkaufs-Kurzinfo („12 Dinge, davon 8 bei Aldi“) |
| **Einkauf** | Eine Haushaltsliste, gefiltert/sortiert nach Laden; Ladenmodus; Verlauf/Favoriten |
| **Aufgaben** | Räume/Bereiche mit Aufgaben, Fälligkeitsbalken, Zuweisungen, Müllkalender |
| **Küche** | Rezeptbuch (Sammlungen, Suche, Filter), Wochenplan, Kochmodus |

Bewusst **eine** Einkaufsliste statt vieler Listen pro Laden (Koffan-Modell
„Liste je Laden“): Menschen denken „wir brauchen Milch“, nicht „Milch auf die
Aldi-Liste“. Der Laden ist eine *Ansicht*, keine Ablage.

---

## 4. Einkaufsliste

### 4.1 Automatische Sortierung nach Abteilung

Standard-Abteilungen (anpassbar, ergänzbar, als `intEnum`-freie Tabelle):

Obst & Gemüse · Brot & Backwaren · Kühlregal (Milch, Käse, Joghurt) ·
Fleisch & Wurst · Fisch · Tiefkühl · Nudeln, Reis & Getreide · Konserven &
Fertiges · Backen · Gewürze, Öl & Saucen · Frühstück (Müsli, Aufstrich,
Kaffee/Tee) · Süßes & Snacks · Getränke · Drogerie & Hygiene · Haushalt &
Putzmittel · Baby · Tier · Sonstiges

**Klassifikation — Kaskade, schnellste/persönlichste Quelle zuerst:**

1. **Haushalts-Historie** (wie Koffan `item_history.last_section_id`): Wurde
   „Hafermilch“ einmal nach *Kühlregal* verschoben, landet sie dort für immer.
2. **Mitgeliefertes Wörterbuch** (`assets/catalog/products.de.json`,
   ~2 000 Begriffe inkl. Synonyme, Plural, Marken-Gattungen: „Tempos“ →
   Drogerie). Normalisierung: Kleinschreibung, Umlaute, Singular
   („Tomaten“ → „tomate“), Mengen/Einheiten abgeschnitten.
3. **Fuzzy-Treffer** (Levenshtein/Teilwort: „Vollkorntoast“ → *toast*).
4. **Optional On-Device-KI** (wenn Gemma-Modell geladen, wie im Doctor Hub):
   nur für unbekannte Begriffe, Ergebnis wird in die Historie übernommen.
5. Sonst *Sonstiges* — mit dezentem Hinweis „Wohin gehört das?“ (ein Tap auf
   eine Abteilung lernt dauerhaft).

Korrektur ist **Drag & Drop** in eine andere Abteilung oder Long-Press →
Abteilung wählen. Kein Dialog beim Anlegen.

### 4.2 Supermärkte (Aldi, HIT, Rewe, Netto …)

- Läden als eigene Einträge mit Farbe/Logo-Kürzel (keine Markenlogos
  einbinden — nur Name + Farbe), vorbelegt: **Aldi, HIT, Rewe, Netto**;
  beliebig ergänzbar (Lidl, Edeka, dm, Wochenmarkt …), optional mit Filiale.
- Jeder Artikel hat **„Wo?“ = egal (Standard) oder ein/mehrere Läden**.
  „Hafermilch nur bei Rewe“ wird ebenfalls gelernt: wurde ein Artikel dreimal
  im selben Laden abgehakt, schlägt die App diesen Laden vor (als Chip, nicht
  automatisch gesetzt).
- **Pro Laden eine eigene Abteilungs-Reihenfolge** (Aldi beginnt mit Obst,
  HIT mit Getränken). Sie wird
  - initial aus einer Vorlage je Kette gesetzt und
  - **implizit gelernt**: die Reihenfolge, in der im Ladenmodus abgehakt
    wird, verschiebt die Abteilungen schrittweise (gleitender Mittelwert der
    Abhak-Position je Abteilung). Nach 2–3 Einkäufen entspricht die Liste dem
    eigenen Laufweg — ohne Einstellungsseite.
- Ansicht oben als Chip-Leiste: `Alle · Aldi 8 · HIT 3 · Rewe 5 · Netto 2`
  (Zähler = offene Artikel inkl. „egal“).

### 4.3 Ladenmodus („Ich bin bei …“)

Ein Tap auf „Einkaufen bei Aldi“:

- Liste zeigt nur Artikel für Aldi + „egal“, in Aldi-Reihenfolge.
- Display bleibt an, größere Schrift, Abhaken per Tap oder Wisch nach rechts;
  abgehakte wandern in einen eingeklappten Bereich „Im Wagen (7)“.
- Wisch nach links = **„Gab’s nicht“** (Koffan „unsicher“): Artikel bleibt
  offen und wird für den nächsten Laden markiert.
- „Fertig“ → Zusammenfassung: „3 Dinge noch offen — bei Rewe vormerken?“
- Andere Haushaltsmitglieder sehen live „Tom kauft gerade bei Aldi ein“ und
  können noch etwas ergänzen (Sync, siehe 7).
- Später: Geofence-Vorschlag „Du bist bei Netto — Liste öffnen?“ (opt-in).

### 4.4 Sprachgesteuert Einkaufsliste erstellen

**Interaktion:** Großer Mikrofon-FAB (global), Homescreen-Widget und
Quick-Settings-Kachel. Gedrückt halten = sprechen, loslassen = fertig
(alternativ Tap-Start/Auto-Stopp bei Stille).

**Beispiel:** *„Zwei Liter Milch, ein Brot, Eier und drei Paprika, und
Spülmittel bei Rewe“*

```
✓ Milch          2 l     Kühlregal
✓ Brot           1       Brot & Backwaren
✓ Eier                   Kühlregal
✓ Paprika        3       Obst & Gemüse
✓ Spülmittel             Haushalt        · Rewe
                         [Rückgängig]  (Snackbar, 8 s)
```

**Pipeline (alles auf dem Gerät):**

1. **Spracherkennung**: Android `SpeechRecognizer` mit Offline-Präferenz
   (`speech_to_text`-Plugin bzw. eigener Kanal wie die Kotlin/Swift-Kanäle im
   Doctor Hub), Sprache = Systemsprache.
2. **Zerlegung** (deterministischer Parser, getestet): Trennung an „,“,
   „und“, „sowie“, „außerdem“; Zahlwörter („zwei“, „ein halbes“), Einheiten
   (l, ml, g, kg, Packung, Dose, Bund, Flasche, Stück); Ladenerkennung
   („bei/von/im Rewe“ – gilt für den letzten oder alle Artikel, je nach
   Position); Verben ignorieren („wir brauchen noch“, „kauf mal“).
3. **Abgleich** mit offenen Artikeln: „Milch“ steht schon drauf → Menge
   erhöhen statt Duplikat.
4. **Klassifikation** nach 4.1.
5. **Bestätigung ohne Dialog**: Ergebnis animiert in die Liste, Undo-Snackbar,
   Tippen auf eine Zeile korrigiert.

Optional: Gemma (wenn installiert) als Fallback für freie Sätze
(„für Pfannkuchen fehlt noch alles“ → Rezept erkennen → Zutaten anbieten).
Später: Google-Assistant-App-Actions / Siri-Kurzbefehl „Füge Milch zur
Einkaufsliste hinzu“.

Sprache funktioniert auch für **Aufgaben** („Bad geputzt“ hakt die Aufgabe
ab) — Erkennungswörter je Aufgabe aus ihrem Namen.

### 4.5 Weitere Einkaufs-Details

- **Schnell-Hinzufügen** per Text mit Vorschlägen aus Historie (häufigste
  zuerst, wie `SuggestionRepository`), leeres Feld zeigt „Oft gekauft“.
- **Standardartikel/Vorrat**: „Immer da haben“ (Milch, Klopapier) → Vorschlag,
  wenn lange nicht gekauft (Ø-Intervall aus Historie).
- Notiz und Menge je Artikel, Foto optional („diese Sorte“).
- Herkunft sichtbar: „für Lasagne (Do)“ bei Artikeln aus Rezepten.

---

## 5. Aufgaben

### 5.1 Modell

- **Bereiche/Räume**: Küche, Bad, Wohnzimmer, Schlafzimmer, Flur, Draußen,
  Allgemein (anpassbar, Icon + Farbe).
- **Aufgabe**: Name, Bereich, Aufwand (S/M/L ≈ 5/15/45 min), Wiederholung,
  Zuständige (niemand / eine Person / rotierend), Erinnerung ja/nein.
- **Wiederholungsarten** (das ist der Kern):
  - *Gleitend* — „alle 7 Tage **nach letzter Erledigung**“ (Saugen,
    Bodenwischen, Bettwäsche). Wer am Freitag statt Montag saugt, verschiebt
    den nächsten Termin. Entspricht der Realität des Putzens.
  - *Fest* — „jeden Dienstag“, „1. des Monats“ (Pflanzen gießen,
    Filter wechseln).
  - *Einmalig* — „Glühbirne Flur tauschen“.
- **Zustandsanzeige statt Fälligkeitsdatum**: Balken pro Aufgabe, der sich
  von „frisch“ bis „dran“ füllt (Anteil der verstrichenen Intervallzeit).
  Überfällig wird nicht rot, sondern einfach „voll“.

### 5.2 Vorlagen beim Einrichten

Beim Onboarding: „Was fällt bei euch an?“ — antippbare Vorlagen statt leerer
Seite, jeweils mit sinnvollem Intervall:

| Bereich | Vorlagen (Intervall) |
|---------|----------------------|
| Allgemein | Staubsaugen (7 T), Boden wischen (14 T), Staub wischen (14 T), Müll leeren (2 T) |
| Küche | Spülmaschine ausräumen (1 T), Kühlschrank auswischen (30 T), Herd/Ofen reinigen (14 T) |
| Bad | Bad putzen (7 T), Handtücher wechseln (7 T), Abfluss reinigen (30 T) |
| Schlafzimmer | Bettwäsche wechseln (14 T) |
| Wäsche | Wäsche waschen (3 T), Wäsche aufhängen/zusammenlegen |
| Draußen | Pflanzen gießen (3 T), Altglas wegbringen (14 T) |

### 5.3 Müllabfuhr

Eigener Typ, weil fest terminiert und farbcodiert: Restmüll (grau), Bio
(braun), Papier (blau), Gelber Sack/Tonne (gelb), Glas.
- Termine manuell oder per **.ics-Import** des Abfallkalenders der Kommune
  (fast alle deutschen Kommunen bieten das an; der Doctor Hub hat bisher nur
  den `.ics`-Export in `services/calendar/ics.dart` — der Import ist neu).
- Erinnerung **am Vorabend** (Uhrzeit einstellbar) an die zuständige Person,
  auf „Heute“ als Karte „Morgen: Papier + Gelber Sack“.
- Wichtig zu trennen: *Mülleimer in der Wohnung leeren* (gleitende Aufgabe)
  vs. *Tonne rausstellen* (fester Termin).

### 5.4 Zuweisung & Fairness — menschzentriert

- Zuweisung optional. „Rotierend“ wechselt nach jeder Erledigung zur nächsten
  Person.
- Abhaken durch **jede** Person möglich („Ich hab’s gemacht“ zählt, auch wenn
  es nicht meine Aufgabe war) — verhindert „war nicht meine Aufgabe“-Streit.
- **Ausgleich statt Wettbewerb**: Wochenansicht „Wer hat was gemacht“ als
  Aufwandsminuten pro Person, ohne Ranking, ohne Punkte für Kinder-Druck.
  Optional „Danke“-Reaktion auf erledigte Aufgaben (leise, positiv).
- **Benachrichtigungen sparsam**: max. eine gebündelte Tageszusammenfassung
  zu einer gewählten Uhrzeit + Müll-Vorabend. Snooze „heute nicht“ ohne
  schlechtes Gewissen (verschiebt um 1 Tag, kein Zähler).
- Urlaub/Abwesenheit: Person pausieren → rotierende Aufgaben überspringen sie.

---

## 6. Küche: Rezeptbuch & Wochenplan

### 6.1 Rezept erfassen — drei Wege, alle kurz

Erkenntnis aus dem Rezept-Projekt: Der 14-Schritte-Wizard sichert Qualität,
ist aber für Familienrezepte im Alltag zu lang. Deshalb **progressive
Offenlegung**:

1. **Schnell**: Titel, Zutaten (eine pro Zeile, freier Text wie
   „200 g Mehl“ — gleicher Parser wie Sprache), Zubereitung (Absätze = Schritte).
   Alles andere optional, später ergänzbar.
2. **Foto/Scan**: Rezeptzettel oder Kochbuchseite fotografieren → OCR (ML Kit
   Texterkennung + Dokumentenscanner, beides schon im Doctor Hub) → Vorschau
   mit erkannten Zutaten/Schritten zum Korrigieren. Originalfoto bleibt am
   Rezept („Omas Handschrift“).
3. **Link-Import**: Rezept-URL teilen → schema.org-`Recipe`-JSON-LD auslesen
   (Chefkoch & Co. liefern das) → Quelle wird gespeichert.

Optionale Felder (aus dem Domänenmodell): Portionen, Zeiten (Vorbereitung /
Kochen / Ruhen), Schwierigkeit, Haushaltsgeräte, Kategorien (Herkunft,
Ernährungsart, Unverträglichkeit, Anlass, Saison — Taxonomie aus
`PPSS21_Mai_Filter_und_Kategorien.md`), Tipps & Tricks, **Anekdote**, Fotos.

### 6.2 Rezept lesen & kochen

- Kopf: Foto, Titel (dicke Schrift), Labels dünn; Zeiten/Portionen als Chips.
- **Portionen-Stepper** skaliert alle Mengen (Einheiten sinnvoll runden,
  „1,5 Eier“ → „1–2 Eier“).
- Zutaten in Verwendungsreihenfolge, gerahmte Liste (Styleguide-Erkenntnis).
- „Tipps & Tricks“ als **eingeklapptes Akkordeon** über der Anleitung.
- **Anekdote/Familiengeschichte am Ende**, deutlich als solche gestaltet.
- **Kochmodus**: Bildschirm bleibt an, ein Schritt pro Seite, große Schrift,
  Zutaten des Schritts eingeblendet, Timer aus erkannten Zeitangaben
  („20 Minuten köcheln“ → Timer-Button), Sprachbefehl „weiter“/„zurück“.
- **„Auf die Einkaufsliste“**: Bottom-Sheet mit allen Zutaten, Vorrats-
  artikel (Salz, Öl) vorab abgewählt, Haken entfernen = „haben wir“. Mengen
  werden mit bestehenden Artikeln zusammengeführt, Herkunft „für Lasagne“.

### 6.3 Organisieren

- **Sammlungen** (wichtigste Personalisierung lt. Umfrage, 100 %) mit eigenem
  Titelbild; Favoriten; Lesezeichen nur nachrangig.
- Suche über Titel, Zutaten, Tags („was kann ich mit Zucchini machen?“).
- Export als PDF / Teilen als Datei (Drucken ist selten, aber gewünscht).

### 6.4 Wochenplan (Brücke zwischen allen drei Bereichen)

- 7 Tage, je Tag ein oder mehrere Gerichte (Rezept oder Freitext „Pizza
  bestellen“), wer kocht.
- „Zutaten für die Woche einkaufen“ → ein Sheet mit allen Zutaten,
  zusammengeführt und nach Abteilung sortiert.
- „Heute“ zeigt das Gericht des Tages; Kochmodus mit einem Tap.

---

## 7. Haushalt teilen & Daten

**Lokal zuerst, Teilen opt-in** (Privacy first wie Doctor Hub, aber Teilen ist
hier Kernnutzen):

- Drift/SQLite (verschlüsselt) auf jedem Gerät; jede Änderung zusätzlich als
  Operation in einem Log (`pending_ops`, Konzept aus Koffan
  `offline_operations`: idempotente IDs, Wiederholung ohne Duplikate,
  Last-Write-Wins pro Feld).
- **Synchronisation** über einen kleinen, **selbst hostbaren Go-Server**
  (Koffan-Architektur: Fiber + SQLite + WebSocket, ~3 MB RAM) als Relais für
  **Ende-zu-Ende-verschlüsselte** Operationen. Der Server sieht keine
  Klartexte (Einkaufslisten verraten viel: Gesundheit, Gewohnheiten).
- **Haushalt beitreten** per QR-Code/Einladungslink auf dem Gerät eines
  Mitglieds (enthält Haushaltsschlüssel) — kein Account, keine E-Mail.
- Ohne Server: App funktioniert vollständig für ein Gerät; Sicherung/Umzug
  per verschlüsselter `.maihh`-Sicherung (`packages/mai_backup_format`).

### Datenmodell (Skizze)

```
Household(id, name)                    Member(id, name, color, paused)
Store(id, name, color, sort)           Department(id, name, icon, sort)
StoreDepartmentOrder(storeId, departmentId, position, learnedWeight)
ShoppingItem(id, name, normalizedName, qty, unit, note, departmentId,
             status[open|inCart|notFound|done], addedBy, recipeId?, mealPlanId?,
             createdAt, doneAt, doneInStoreId?)
ShoppingItemStore(itemId, storeId)     ← leer = „egal“
ProductMemory(normalizedName, departmentId, storeId?, usageCount,
              avgIntervalDays, lastBoughtAt, isStaple)
Area(id, name, icon, color)
Chore(id, areaId, name, effort, recurrence[floating|fixed|once],
      intervalDays?, rrule?, assignment[none|member|rotating], assigneeId?,
      remind, archived)
ChoreCompletion(id, choreId, memberId, doneAt)      ← Fairness & Historie
WasteType(id, name, color)  WastePickup(id, wasteTypeId, date)
Recipe(id, title, servings, prepMin, cookMin, restMin, difficulty,
       story(Anekdote), tips, sourceUrl?, createdBy, createdAt)
RecipeIngredient(id, recipeId, pos, qty, unit, name, note, departmentId?)
RecipeStep(id, recipeId, pos, text, timerSec?)
RecipeMedia(id, recipeId, path, kind[photo|scan])
Tag(id, kind[origin|diet|intolerance|occasion|season|custom], name)
RecipeTag(recipeId, tagId)   Collection(id, name, coverPath)  CollectionRecipe
MealPlanEntry(id, date, recipeId?, freeText?, cookId?)
PendingOp(id, entity, entityId, payload(enc), createdAt, sentAt?)
```

Alle Enums als `intEnum` nur am Ende erweitern; ab Release 1.0 gelten die
CLAUDE.md-Regeln des Doctor Hub (additive Migrationen, Migrationstests).

---

## 8. Screens (Low-Fidelity)

**Einkauf — Übersicht**
```
┌─────────────────────────────────┐
│ Einkauf                    👤   │
│ [Alle 18] [Aldi 8] [HIT 3]      │
│ [Rewe 5] [Netto 2] [+]          │
│ ┌ + Was fehlt? ───────── 🎤 ┐   │
│ OBST & GEMÜSE                   │
│ ○ Paprika        3              │
│ ○ Bananen               Aldi    │
│ KÜHLREGAL                       │
│ ○ Milch          2 l            │
│ ○ Hafermilch            Rewe    │
│ ○ Eier · für Pfannkuchen (Sa)   │
│ ...                             │
│        [ 🛒 Einkaufen bei … ]   │
└─────────────────────────────────┘
```

**Heute**
```
┌─────────────────────────────────┐
│ Guten Abend, Lena               │
│ ┌ Morgen früh ───────────────┐  │
│ │ 🟦 Papier  🟨 Gelber Sack   │  │
│ │ Tom stellt raus      [✓]    │  │
│ └─────────────────────────────┘ │
│ Heute dran                      │
│ ▓▓▓▓▓▓▓▓▓ Staubsaugen  · Ich [✓]│
│ ▓▓▓▓▓▓▓░░ Bad          · Mia    │
│ Heute gibt’s: Lasagne  [Kochen] │
│ Einkauf: 18 offen · Tom bei Aldi│
│                           (🎤)  │
└─────────────────────────────────┘
```

---

## 9. Vorgehen nach ISO 9241-210 & Roadmap

1. **Nutzungskontext verstehen**: 5–8 Haushalte (Paar, Familie, WG)
   interviewen; Tagebuch eine Woche „Wann fällt mir ein, was fehlt?“.
2. **Anforderungen**: User-Story-Mapping-Workshop mit Haushaltsmitgliedern
   (Moderationsleitfaden aus dem Rezept-Projekt wiederverwenden), MVP-Linie
   gemeinsam ziehen.
3. **Gestaltungslösungen**: Figma-Clickdummy der drei Kernflüsse
   (Sprache → Liste, Ladenmodus, Aufgabe abhaken).
4. **Evaluieren**: Think-Aloud im echten Supermarkt; Messgrößen: Zeit bis
   Artikel erfasst (< 5 s per Sprache), Anteil korrekt einsortierter Artikel
   (> 90 % nach 2 Wochen), SUS-Fragebogen ≥ 80.

| Release | Umfang |
|---------|--------|
| **M1 — Einkauf solo** | Flutter-Projekt nach Doctor-Hub-Vorlage, eine Liste, Abteilungs-Kaskade (Historie + Wörterbuch), Läden + Ladenmodus, Sprach-Eingabe mit Parser, Undo, Backup |
| **M2 — Aufgaben** | Bereiche, gleitende/feste Aufgaben, Vorlagen, Müllkalender (+ .ics-Import), Tageszusammenfassung, „Heute“-Tab |
| **M3 — Gemeinsam** | Haushalt per QR, E2E-verschlüsselter Sync-Server (Go), Live-„kauft gerade ein“, Zuweisung/Rotation, Fairness-Ansicht |
| **M4 — Küche** | Rezepte (schnell, Foto/OCR, Link-Import), Portionen, Kochmodus, Zutaten → Liste, Sammlungen |
| **M5 — Planen & lernen** | Wochenplan, gelernte Gang-Reihenfolge je Laden, Vorrats-Vorschläge, Widgets, optional Gemma-Fallback, Geofence |

---

## 10. Offene Entscheidungen

1. **Sync ab M1 oder erst M3?** Empfehlung: Operationslog ab M1 mitschreiben,
   Server erst M3 — so ist kein Datenmodell-Umbau nötig.
2. **Self-hosted vs. betriebener Server** für den Sync (Koffan ist
   self-hosted; für Familie ohne Technikaffinität evtl. zentral, aber E2E).
3. **iOS** gleich mit (Doctor Hub hat iOS bereits) — Sprache dort via
   `SFSpeechRecognizer`.
4. **Produkt-Wörterbuch**: selbst kuratieren (empfohlen, Lizenz klar) vs.
   Open Food Facts-Kategorien (ODbL, groß, aber unsauber für Abteilungen).
