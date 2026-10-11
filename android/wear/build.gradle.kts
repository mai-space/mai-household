import java.util.Properties

// Uhr-App (Wear OS): Kacheln, Komplikationen und eine kleine Liste.
// Eigenständiges APK mit derselben applicationId und Signatur wie die
// Telefon-App — nur dann tauschen beide Daten über die Datenschicht aus.
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties().apply {
    if (keyPropertiesFile.exists()) keyPropertiesFile.inputStream().use { load(it) }
}

// Version aus pubspec.yaml („version: 1.2.3+45“). Die Uhr braucht einen
// eigenen versionCode (gleiche applicationId wie das Telefon-APK).
val pubspecVersion = rootProject.file("../pubspec.yaml").readLines()
    .firstOrNull { it.startsWith("version:") }
    ?.substringAfter(":")
    ?.trim()
    ?: "1.0.0+1"
val buildNumber = pubspecVersion.substringAfter("+", "1").toIntOrNull() ?: 1

android {
    namespace = "space.mai.mai_household.wear"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "space.mai.mai_household"
        // Wear OS 3 und neuer.
        minSdk = 30
        targetSdk = 36
        versionCode = 200_000_000 + buildNumber
        versionName = pubspecVersion.substringBefore("+")
    }

    signingConfigs {
        if (keyPropertiesFile.exists()) {
            create("release") {
                // Pfad wie im Telefon-Modul relativ zu android/app.
                storeFile = rootProject.file("app").resolve(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Wie das Telefon-APK: ohne android/key.properties mit Debug-Key.
            signingConfig = signingConfigs.getByName(
                if (keyPropertiesFile.exists()) "release" else "debug",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    implementation("com.google.android.gms:play-services-wearable:19.0.0")
    implementation("androidx.wear.tiles:tiles:1.4.1")
    implementation("androidx.wear.protolayout:protolayout:1.2.1")
    implementation("androidx.wear.watchface:watchface-complications-data-source-ktx:1.2.1")
    implementation("androidx.concurrent:concurrent-futures:1.2.0")

    testImplementation("junit:junit:4.13.2")
    // Echte org.json-Klassen statt der Android-Attrappen im Unit-Test.
    testImplementation("org.json:json:20240303")
}
