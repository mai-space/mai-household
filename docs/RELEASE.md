# Release-Signierung (Google Play)

Die CI (`.github/workflows/ci.yml`) baut bei jedem Push eine APK. Auf dem
**Standard-Branch** baut sie zusätzlich **signierte App-Bundles** (AAB) für
Telefon und Uhr, sobald die Signatur-Secrets angelegt sind:

- Artefakt `mai-household-release-aab` mit `app-release.aab` (Telefon) und
  `wear-release.aab` (Wear OS), 30 Tage aufbewahrt.
- Die APK im Artefakt `mai-household-apk` trägt dann ebenfalls den
  Upload-Schlüssel statt des Debug-Schlüssels.
- Die CI prüft, dass alle drei Dateien mit dem Upload-Schlüssel (nicht mit
  dem Debug-Schlüssel) signiert sind.

Ohne Secrets und auf allen anderen Branches läuft alles wie bisher.
Der Upload in die Play Console geschieht von Hand (AAB aus dem Artefakt).

Im Repo liegt nichts Geheimes: Keystore und `android/key.properties`
entstehen nur zur Laufzeit im Runner und werden danach gelöscht
(`key.properties`, `*.jks`, `*.keystore` sind in `android/.gitignore`).

## 1. Upload-Schlüssel erzeugen (einmalig)

```sh
keytool -genkeypair -v -keystore upload-keystore.jks -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
base64 -w0 upload-keystore.jks > upload-keystore.jks.b64   # macOS: base64 -i upload-keystore.jks
```

Keystore und Passwörter sicher aufbewahren (Passwortmanager), nie
einchecken. Mit **Play App Signing** (Standard für neue Apps) verwaltet
Google den eigentlichen App-Signaturschlüssel; dies ist nur der
Upload-Schlüssel und lässt sich bei Verlust über den Play-Support
zurücksetzen.

## 2. GitHub-Secrets anlegen

Repository → **Settings → Secrets and variables → Actions → New repository
secret**:

| Secret | Inhalt |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Inhalt von `upload-keystore.jks.b64` |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore-Passwort |
| `ANDROID_KEY_ALIAS` | Alias (`upload` im Beispiel) |
| `ANDROID_KEY_PASSWORD` | Schlüssel-Passwort |

Danach die lokale `.b64`-Datei löschen. Der nächste Push auf den
Standard-Branch (oder **Actions → CI → Re-run**) baut die signierten Bundles.

## 3. Lokal signiert bauen

`android/key.properties` anlegen (wird nicht eingecheckt):

```properties
storeFile=/absoluter/pfad/zu/upload-keystore.jks
storePassword=…
keyAlias=upload
keyPassword=…
```

```sh
flutter build appbundle --release
(cd android && ./gradlew :wear:bundleRelease)
```

## Version

`versionName` und `versionCode` kommen aus `version:` in `pubspec.yaml`
(`1.0.0+1` → Name `1.0.0`, Code `1`). Für jeden Upload die Zahl hinter `+`
erhöhen — Google Play nimmt jeden versionCode nur einmal an. Die Uhr-App
bekommt automatisch `200000000 + versionCode`.

## Uhr-App in der Play Console

Telefon- und Uhr-App haben dieselbe Paket-ID `space.mai.mai_household` und
denselben Schlüssel (sonst tauschen sie keine Daten aus). In der Play Console
den Formfaktor Wear OS hinzufügen (*Release → Erweiterte Einstellungen →
Formfaktoren*) und `wear-release.aab` dort in den Wear-Track hochladen.
