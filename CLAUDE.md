# Mai Household — Hinweise für Änderungen

Haushalts-App (Flutter, Android; iOS vorbereitet): Einkaufsliste mit
Abteilungs-/Ladensortierung und Spracheingabe, Aufgaben inkl. Müllkalender,
Rezeptbuch mit Wochenplan. Lokal, ohne Konto; Teilen nur direkt zwischen
Geräten im selben WLAN (QR-Code). UI Deutsch/Englisch nach Systemsprache.
Konzept: `docs/KONZEPT.md`.

## Rückwärtskompatibilität (ab dem ersten verteilten Build Pflicht)

Jedes Update muss bestehende Installationen und Daten ohne Verlust
weiterverwenden — und **Geräte mit unterschiedlichen App-Versionen müssen
sich weiter abgleichen können**.

- **Datenbank (drift, `lib/data/app_database.dart`)**
  - Nur additive Migrationen: neue Tabellen, neue Spalten *nullable oder mit
    Default*. Niemals Spalten/Tabellen löschen, umbenennen oder Typ ändern.
  - Jede Änderung: `schemaVersion` +1 und ein eigener Block `if (from < n)`
    in `onUpgrade` (alte Blöcke nie ändern), Migrationstest mit Bestandsdaten.
  - Neue geteilte Tabellen: `with SyncColumns` und in
    `AppDatabase.syncTableNames` aufnehmen (+ seq-Index).
  - Enums (Index gespeichert: `Recurrence`, `Assignment`, `ItemStatus`,
    `WasteType`, `BuiltinDepartment`, `BuiltinArea`) nur am Ende erweitern.
  - Eingebaute Einträge haben feste IDs (`dep-…`, `store-…`, `area-…`) und
    `updatedAt = 1` — nie ändern, sonst entstehen Doppelte beim Teilen.
  - Danach: `dart run build_runner build --delete-conflicting-outputs`.
- **Verschlüsselte Datenbank (`lib/data/connection/`, SQLite3 Multiple
  Ciphers, wie Doctor Hub/Fitness)** — Dateiname `mai_household.sqlite`,
  Keystore-Alias `mai_household_db_wrap` und `db.key` in `noBackupFilesDir`
  nie ändern, sonst ist die Datenbank nicht mehr lesbar. Die einmalige
  Umstellung alter, unverschlüsselter Installationen (Sicherungskopie →
  verschlüsseln → prüfen → sonst zurückspielen) muss erhalten bleiben.
- **Sync (`lib/sync/`)** — Nachrichtenformat nur erweitern; unbekannte
  Spalten/Felder werden ignoriert. `SyncEngine` vergleicht pro Zeile
  `updatedAt` (hybride Uhr). Jede lokale Änderung an geteilten Tabellen
  muss `ctx.stamp()` setzen (`updatedAt` + `seq`) und `ctx.notifyChanged()`
  aufrufen; Löschen nur als Grabstein (`deleted = true`).
- **Einladungs-QR (`maihh:1?…`)** — Version im Schema; neue Felder optional.

## Arbeitsweise

- Strings: `lib/l10n/parts/<bereich>.<de|en>.json` (neue Schlüssel anhängen),
  dann `python3 tool/merge_arb.py && flutter gen-l10n`.
- Prüfen vor jedem Commit: `flutter analyze` (sauber) und `flutter test`.
- Kein `dart format` auf ganze bestehende Dateien (erzeugt fremde Diffs).
- Kommentare im Code auf Deutsch.
