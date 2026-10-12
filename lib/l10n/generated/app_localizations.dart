import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @depProduce.
  ///
  /// In de, this message translates to:
  /// **'Obst & Gemüse'**
  String get depProduce;

  /// No description provided for @depBakery.
  ///
  /// In de, this message translates to:
  /// **'Brot & Backwaren'**
  String get depBakery;

  /// No description provided for @depDairy.
  ///
  /// In de, this message translates to:
  /// **'Kühlregal'**
  String get depDairy;

  /// No description provided for @depMeat.
  ///
  /// In de, this message translates to:
  /// **'Fleisch & Wurst'**
  String get depMeat;

  /// No description provided for @depFish.
  ///
  /// In de, this message translates to:
  /// **'Fisch'**
  String get depFish;

  /// No description provided for @depFrozen.
  ///
  /// In de, this message translates to:
  /// **'Tiefkühl'**
  String get depFrozen;

  /// No description provided for @depPasta.
  ///
  /// In de, this message translates to:
  /// **'Nudeln, Reis & Getreide'**
  String get depPasta;

  /// No description provided for @depCanned.
  ///
  /// In de, this message translates to:
  /// **'Konserven & Fertiges'**
  String get depCanned;

  /// No description provided for @depBaking.
  ///
  /// In de, this message translates to:
  /// **'Backen'**
  String get depBaking;

  /// No description provided for @depSpices.
  ///
  /// In de, this message translates to:
  /// **'Gewürze, Öl & Saucen'**
  String get depSpices;

  /// No description provided for @depBreakfast.
  ///
  /// In de, this message translates to:
  /// **'Frühstück, Kaffee & Tee'**
  String get depBreakfast;

  /// No description provided for @depSweets.
  ///
  /// In de, this message translates to:
  /// **'Süßes & Snacks'**
  String get depSweets;

  /// No description provided for @depDrinks.
  ///
  /// In de, this message translates to:
  /// **'Getränke'**
  String get depDrinks;

  /// No description provided for @depDrugstore.
  ///
  /// In de, this message translates to:
  /// **'Drogerie & Hygiene'**
  String get depDrugstore;

  /// No description provided for @depHousehold.
  ///
  /// In de, this message translates to:
  /// **'Haushalt & Putzmittel'**
  String get depHousehold;

  /// No description provided for @depBaby.
  ///
  /// In de, this message translates to:
  /// **'Baby'**
  String get depBaby;

  /// No description provided for @depPet.
  ///
  /// In de, this message translates to:
  /// **'Tier'**
  String get depPet;

  /// No description provided for @depOther.
  ///
  /// In de, this message translates to:
  /// **'Sonstiges'**
  String get depOther;

  /// No description provided for @areaGeneral.
  ///
  /// In de, this message translates to:
  /// **'Ganze Wohnung'**
  String get areaGeneral;

  /// No description provided for @areaKitchen.
  ///
  /// In de, this message translates to:
  /// **'Küche'**
  String get areaKitchen;

  /// No description provided for @areaBath.
  ///
  /// In de, this message translates to:
  /// **'Bad'**
  String get areaBath;

  /// No description provided for @areaLiving.
  ///
  /// In de, this message translates to:
  /// **'Wohnzimmer'**
  String get areaLiving;

  /// No description provided for @areaBedroom.
  ///
  /// In de, this message translates to:
  /// **'Schlafzimmer'**
  String get areaBedroom;

  /// No description provided for @areaLaundry.
  ///
  /// In de, this message translates to:
  /// **'Wäsche'**
  String get areaLaundry;

  /// No description provided for @areaOutside.
  ///
  /// In de, this message translates to:
  /// **'Draußen'**
  String get areaOutside;

  /// No description provided for @tplVacuum.
  ///
  /// In de, this message translates to:
  /// **'Staubsaugen'**
  String get tplVacuum;

  /// No description provided for @tplMop.
  ///
  /// In de, this message translates to:
  /// **'Boden wischen'**
  String get tplMop;

  /// No description provided for @tplDust.
  ///
  /// In de, this message translates to:
  /// **'Staub wischen'**
  String get tplDust;

  /// No description provided for @tplTrash.
  ///
  /// In de, this message translates to:
  /// **'Mülleimer leeren'**
  String get tplTrash;

  /// No description provided for @tplDishwasher.
  ///
  /// In de, this message translates to:
  /// **'Spülmaschine ausräumen'**
  String get tplDishwasher;

  /// No description provided for @tplFridge.
  ///
  /// In de, this message translates to:
  /// **'Kühlschrank auswischen'**
  String get tplFridge;

  /// No description provided for @tplStove.
  ///
  /// In de, this message translates to:
  /// **'Herd & Ofen reinigen'**
  String get tplStove;

  /// No description provided for @tplBathroom.
  ///
  /// In de, this message translates to:
  /// **'Bad putzen'**
  String get tplBathroom;

  /// No description provided for @tplTowels.
  ///
  /// In de, this message translates to:
  /// **'Handtücher wechseln'**
  String get tplTowels;

  /// No description provided for @tplDrain.
  ///
  /// In de, this message translates to:
  /// **'Abfluss reinigen'**
  String get tplDrain;

  /// No description provided for @tplBedding.
  ///
  /// In de, this message translates to:
  /// **'Bettwäsche wechseln'**
  String get tplBedding;

  /// No description provided for @tplLaundry.
  ///
  /// In de, this message translates to:
  /// **'Wäsche waschen'**
  String get tplLaundry;

  /// No description provided for @tplPlants.
  ///
  /// In de, this message translates to:
  /// **'Pflanzen gießen'**
  String get tplPlants;

  /// No description provided for @tplGlass.
  ///
  /// In de, this message translates to:
  /// **'Altglas wegbringen'**
  String get tplGlass;

  /// No description provided for @tplWindows.
  ///
  /// In de, this message translates to:
  /// **'Fenster putzen'**
  String get tplWindows;

  /// No description provided for @wasteResidual.
  ///
  /// In de, this message translates to:
  /// **'Restmüll'**
  String get wasteResidual;

  /// No description provided for @wasteOrganic.
  ///
  /// In de, this message translates to:
  /// **'Bio'**
  String get wasteOrganic;

  /// No description provided for @wastePaper.
  ///
  /// In de, this message translates to:
  /// **'Papier'**
  String get wastePaper;

  /// No description provided for @wastePackaging.
  ///
  /// In de, this message translates to:
  /// **'Gelber Sack'**
  String get wastePackaging;

  /// No description provided for @wasteGlass.
  ///
  /// In de, this message translates to:
  /// **'Glas'**
  String get wasteGlass;

  /// No description provided for @wasteOther.
  ///
  /// In de, this message translates to:
  /// **'Sonstiges'**
  String get wasteOther;

  /// No description provided for @choreAdd.
  ///
  /// In de, this message translates to:
  /// **'Aufgabe'**
  String get choreAdd;

  /// No description provided for @choreEdit.
  ///
  /// In de, this message translates to:
  /// **'Aufgabe bearbeiten'**
  String get choreEdit;

  /// No description provided for @choreAll.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get choreAll;

  /// No description provided for @choreMine.
  ///
  /// In de, this message translates to:
  /// **'Meine'**
  String get choreMine;

  /// No description provided for @choreAnyone.
  ///
  /// In de, this message translates to:
  /// **'Wer Zeit hat'**
  String get choreAnyone;

  /// No description provided for @choreArea.
  ///
  /// In de, this message translates to:
  /// **'Bereich'**
  String get choreArea;

  /// No description provided for @choreCompleted.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ erledigt — danke!'**
  String choreCompleted(String name);

  /// No description provided for @choreDeleted.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ gelöscht'**
  String choreDeleted(String name);

  /// No description provided for @choreDone.
  ///
  /// In de, this message translates to:
  /// **'Erledigt'**
  String get choreDone;

  /// No description provided for @choreDoneBy.
  ///
  /// In de, this message translates to:
  /// **'{name} hat’s gemacht'**
  String choreDoneBy(String name);

  /// No description provided for @choreDoneByMe.
  ///
  /// In de, this message translates to:
  /// **'Hab ich gemacht'**
  String get choreDoneByMe;

  /// No description provided for @choreDoneTodayAlready.
  ///
  /// In de, this message translates to:
  /// **'Heute schon erledigt'**
  String get choreDoneTodayAlready;

  /// No description provided for @choreDueIn.
  ///
  /// In de, this message translates to:
  /// **'in {count} Tagen'**
  String choreDueIn(int count);

  /// No description provided for @choreDueSince.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{seit gestern dran} other{seit {count} Tagen dran}}'**
  String choreDueSince(int count);

  /// No description provided for @choreDueToday.
  ///
  /// In de, this message translates to:
  /// **'heute dran'**
  String get choreDueToday;

  /// No description provided for @choreDueTomorrow.
  ///
  /// In de, this message translates to:
  /// **'morgen'**
  String get choreDueTomorrow;

  /// No description provided for @choreEffort.
  ///
  /// In de, this message translates to:
  /// **'Aufwand'**
  String get choreEffort;

  /// No description provided for @choreEffortMinutes.
  ///
  /// In de, this message translates to:
  /// **'~{count} min'**
  String choreEffortMinutes(int count);

  /// No description provided for @choreEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Nichts zu tun'**
  String get choreEmptyTitle;

  /// No description provided for @choreEmptyMessage.
  ///
  /// In de, this message translates to:
  /// **'Lege Aufgaben an — z. B. Staubsaugen alle 7 Tage. Die App zeigt dann, wann es wieder dran ist.'**
  String get choreEmptyMessage;

  /// No description provided for @choreEveryDays.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{täglich} other{alle {count} Tage}}'**
  String choreEveryDays(int count);

  /// No description provided for @choreFloatingHint.
  ///
  /// In de, this message translates to:
  /// **'Gezählt ab der letzten Erledigung — wer später putzt, verschiebt den nächsten Termin.'**
  String get choreFloatingHint;

  /// No description provided for @choreHistory.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt erledigt'**
  String get choreHistory;

  /// No description provided for @choreName.
  ///
  /// In de, this message translates to:
  /// **'Was ist zu tun?'**
  String get choreName;

  /// No description provided for @choreNameHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. Bad putzen'**
  String get choreNameHint;

  /// No description provided for @choreNoDate.
  ///
  /// In de, this message translates to:
  /// **'Ohne Datum'**
  String get choreNoDate;

  /// No description provided for @choreRemind.
  ///
  /// In de, this message translates to:
  /// **'In der Tageszusammenfassung'**
  String get choreRemind;

  /// No description provided for @choreRemindHint.
  ///
  /// In de, this message translates to:
  /// **'Eine gebündelte Erinnerung pro Tag — kein Dauer-Ping.'**
  String get choreRemindHint;

  /// No description provided for @choreRepeat.
  ///
  /// In de, this message translates to:
  /// **'Wiederholung'**
  String get choreRepeat;

  /// No description provided for @choreRepeatFloating.
  ///
  /// In de, this message translates to:
  /// **'Regelmäßig'**
  String get choreRepeatFloating;

  /// No description provided for @choreRepeatWeekly.
  ///
  /// In de, this message translates to:
  /// **'Wochentage'**
  String get choreRepeatWeekly;

  /// No description provided for @choreRepeatOnce.
  ///
  /// In de, this message translates to:
  /// **'Einmalig'**
  String get choreRepeatOnce;

  /// No description provided for @choreRotating.
  ///
  /// In de, this message translates to:
  /// **'Reihum'**
  String get choreRotating;

  /// No description provided for @choreRotatingHint.
  ///
  /// In de, this message translates to:
  /// **'Nach jedem Erledigen ist die nächste Person dran (pausierte werden übersprungen).'**
  String get choreRotatingHint;

  /// No description provided for @choreSectionDue.
  ///
  /// In de, this message translates to:
  /// **'Jetzt dran'**
  String get choreSectionDue;

  /// No description provided for @choreSectionSoon.
  ///
  /// In de, this message translates to:
  /// **'Diese Woche'**
  String get choreSectionSoon;

  /// No description provided for @choreSectionLater.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get choreSectionLater;

  /// No description provided for @choreSnooze.
  ///
  /// In de, this message translates to:
  /// **'Heute nicht'**
  String get choreSnooze;

  /// No description provided for @choreWho.
  ///
  /// In de, this message translates to:
  /// **'Wer?'**
  String get choreWho;

  /// No description provided for @fairnessTitle.
  ///
  /// In de, this message translates to:
  /// **'Wer hat was gemacht'**
  String get fairnessTitle;

  /// No description provided for @fairnessWeek.
  ///
  /// In de, this message translates to:
  /// **'7 Tage'**
  String get fairnessWeek;

  /// No description provided for @fairnessMonth.
  ///
  /// In de, this message translates to:
  /// **'30 Tage'**
  String get fairnessMonth;

  /// No description provided for @fairnessIntro.
  ///
  /// In de, this message translates to:
  /// **'Aufwand in Minuten — zum Ausgleichen, nicht zum Vergleichen.'**
  String get fairnessIntro;

  /// No description provided for @fairnessEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch nichts erledigt in diesem Zeitraum.'**
  String get fairnessEmpty;

  /// No description provided for @fairnessMinutes.
  ///
  /// In de, this message translates to:
  /// **'{count} min'**
  String fairnessMinutes(int count);

  /// No description provided for @fairnessRecent.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt'**
  String get fairnessRecent;

  /// No description provided for @wasteTitle.
  ///
  /// In de, this message translates to:
  /// **'Müllabfuhr'**
  String get wasteTitle;

  /// No description provided for @wasteAdd.
  ///
  /// In de, this message translates to:
  /// **'Termine hinzufügen'**
  String get wasteAdd;

  /// No description provided for @wasteImport.
  ///
  /// In de, this message translates to:
  /// **'Abfallkalender importieren (.ics)'**
  String get wasteImport;

  /// No description provided for @wasteImported.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =0{Keine neuen Termine} =1{1 Termin hinzugefügt} other{{count} Termine hinzugefügt}}'**
  String wasteImported(int count);

  /// No description provided for @wasteEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Abfuhrtermine'**
  String get wasteEmptyTitle;

  /// No description provided for @wasteEmptyMessage.
  ///
  /// In de, this message translates to:
  /// **'Lade den Abfallkalender deiner Stadt als .ics herunter und importiere ihn — oder trage den Rhythmus selbst ein. Erinnerung kommt am Vorabend.'**
  String get wasteEmptyMessage;

  /// No description provided for @wasteFirstDate.
  ///
  /// In de, this message translates to:
  /// **'Nächste Abholung'**
  String get wasteFirstDate;

  /// No description provided for @wasteRepeat.
  ///
  /// In de, this message translates to:
  /// **'Rhythmus'**
  String get wasteRepeat;

  /// No description provided for @wasteOnce.
  ///
  /// In de, this message translates to:
  /// **'Einmalig'**
  String get wasteOnce;

  /// No description provided for @wasteWeekly.
  ///
  /// In de, this message translates to:
  /// **'Wöchentlich'**
  String get wasteWeekly;

  /// No description provided for @wasteBiweekly.
  ///
  /// In de, this message translates to:
  /// **'Alle 2 Wochen'**
  String get wasteBiweekly;

  /// No description provided for @wasteFourWeekly.
  ///
  /// In de, this message translates to:
  /// **'Alle 4 Wochen'**
  String get wasteFourWeekly;

  /// No description provided for @wasteToday.
  ///
  /// In de, this message translates to:
  /// **'Heute wird abgeholt'**
  String get wasteToday;

  /// No description provided for @wasteTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Morgen früh rausstellen'**
  String get wasteTomorrow;

  /// No description provided for @wasteNobody.
  ///
  /// In de, this message translates to:
  /// **'Wer Zeit hat'**
  String get wasteNobody;

  /// No description provided for @wasteAssign.
  ///
  /// In de, this message translates to:
  /// **'{name} stellt raus'**
  String wasteAssign(String name);

  /// No description provided for @wasteDeleteFuture.
  ///
  /// In de, this message translates to:
  /// **'Alle künftigen Termine löschen'**
  String get wasteDeleteFuture;

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Haushalt'**
  String get appTitle;

  /// No description provided for @commonAdd.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get commonAdd;

  /// No description provided for @commonCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get commonEdit;

  /// No description provided for @commonNext.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get commonNext;

  /// No description provided for @commonRename.
  ///
  /// In de, this message translates to:
  /// **'Umbenennen'**
  String get commonRename;

  /// No description provided for @commonSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get commonSave;

  /// No description provided for @commonUndo.
  ///
  /// In de, this message translates to:
  /// **'Rückgängig'**
  String get commonUndo;

  /// No description provided for @tabToday.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get tabToday;

  /// No description provided for @tabShopping.
  ///
  /// In de, this message translates to:
  /// **'Einkauf'**
  String get tabShopping;

  /// No description provided for @tabChores.
  ///
  /// In de, this message translates to:
  /// **'Aufgaben'**
  String get tabChores;

  /// No description provided for @tabKitchen.
  ///
  /// In de, this message translates to:
  /// **'Küche'**
  String get tabKitchen;

  /// No description provided for @commonRetry.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get commonRetry;

  /// No description provided for @commonUnderstood.
  ///
  /// In de, this message translates to:
  /// **'Verstanden'**
  String get commonUnderstood;

  /// No description provided for @keyUnavailableTitle.
  ///
  /// In de, this message translates to:
  /// **'Daten gerade nicht lesbar'**
  String get keyUnavailableTitle;

  /// No description provided for @keyUnavailableText.
  ///
  /// In de, this message translates to:
  /// **'Der Schlüssel deiner verschlüsselten Daten ist gerade nicht erreichbar. Deine Daten sind sicher — versuch es gleich noch einmal oder starte das Gerät neu.'**
  String get keyUnavailableText;

  /// No description provided for @unreadableTitle.
  ///
  /// In de, this message translates to:
  /// **'Alte Daten nicht lesbar'**
  String get unreadableTitle;

  /// No description provided for @unreadableText.
  ///
  /// In de, this message translates to:
  /// **'Deine bisherigen Daten ließen sich auf diesem Gerät nicht mehr entschlüsseln und wurden beiseitegelegt. Teilst du den Haushalt mit anderen Geräten, kommen die gemeinsamen Listen beim nächsten Abgleich zurück.'**
  String get unreadableText;

  /// No description provided for @householdTitle.
  ///
  /// In de, this message translates to:
  /// **'Haushalt'**
  String get householdTitle;

  /// No description provided for @householdPeople.
  ///
  /// In de, this message translates to:
  /// **'Personen'**
  String get householdPeople;

  /// No description provided for @memberMe.
  ///
  /// In de, this message translates to:
  /// **'{name} (ich)'**
  String memberMe(String name);

  /// No description provided for @memberAdd.
  ///
  /// In de, this message translates to:
  /// **'Person hinzufügen'**
  String get memberAdd;

  /// No description provided for @memberAddHint.
  ///
  /// In de, this message translates to:
  /// **'Auch ohne eigenes Handy, z. B. Kinder'**
  String get memberAddHint;

  /// No description provided for @memberPaused.
  ///
  /// In de, this message translates to:
  /// **'Pausiert (z. B. Urlaub)'**
  String get memberPaused;

  /// No description provided for @memberPausedHint.
  ///
  /// In de, this message translates to:
  /// **'Wird bei „Reihum“ übersprungen'**
  String get memberPausedHint;

  /// No description provided for @memberRemove.
  ///
  /// In de, this message translates to:
  /// **'Aus dem Haushalt entfernen'**
  String get memberRemove;

  /// No description provided for @householdSharing.
  ///
  /// In de, this message translates to:
  /// **'Teilen im WLAN'**
  String get householdSharing;

  /// No description provided for @householdSharingIntro.
  ///
  /// In de, this message translates to:
  /// **'Ohne Konto und ohne Cloud: Geräte im selben WLAN gleichen sich direkt und verschlüsselt ab, solange die App offen ist.'**
  String get householdSharingIntro;

  /// No description provided for @householdLeave.
  ///
  /// In de, this message translates to:
  /// **'Haushalt verlassen'**
  String get householdLeave;

  /// No description provided for @householdLeaveHint.
  ///
  /// In de, this message translates to:
  /// **'Daten bleiben auf diesem Gerät, Teilen endet'**
  String get householdLeaveHint;

  /// No description provided for @householdLeaveConfirm.
  ///
  /// In de, this message translates to:
  /// **'Dieses Gerät gleicht danach nicht mehr mit den anderen ab. Die Einträge bleiben hier als eigene Kopie erhalten.'**
  String get householdLeaveConfirm;

  /// No description provided for @householdReminders.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen'**
  String get householdReminders;

  /// No description provided for @remindersEnabled.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen'**
  String get remindersEnabled;

  /// No description provided for @remindersHint.
  ///
  /// In de, this message translates to:
  /// **'Eine Tageszusammenfassung und Müll am Vorabend — sonst nichts.'**
  String get remindersHint;

  /// No description provided for @remindersDenied.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen sind in den Systemeinstellungen ausgeschaltet.'**
  String get remindersDenied;

  /// No description provided for @remindersSummary.
  ///
  /// In de, this message translates to:
  /// **'Tageszusammenfassung'**
  String get remindersSummary;

  /// No description provided for @remindersWaste.
  ///
  /// In de, this message translates to:
  /// **'Müll-Erinnerung (Vorabend)'**
  String get remindersWaste;

  /// No description provided for @householdAbout.
  ///
  /// In de, this message translates to:
  /// **'Über die App'**
  String get householdAbout;

  /// No description provided for @householdPrivacy.
  ///
  /// In de, this message translates to:
  /// **'Alle Daten bleiben auf euren Geräten. Kein Konto, kein Server, keine Werbung. Geteilt wird nur direkt zwischen euren Geräten im selben WLAN, verschlüsselt mit einem Schlüssel aus dem QR-Code.'**
  String get householdPrivacy;

  /// No description provided for @shareInviteTitle.
  ///
  /// In de, this message translates to:
  /// **'Gerät hinzufügen'**
  String get shareInviteTitle;

  /// No description provided for @shareInviteSubtitle.
  ///
  /// In de, this message translates to:
  /// **'QR-Code zeigen'**
  String get shareInviteSubtitle;

  /// No description provided for @shareInviteIntro.
  ///
  /// In de, this message translates to:
  /// **'Öffne die App auf dem anderen Handy, wähle „QR-Code scannen“ und halte es hierauf. Beide Geräte müssen im selben WLAN sein.'**
  String get shareInviteIntro;

  /// No description provided for @shareNoWifi.
  ///
  /// In de, this message translates to:
  /// **'Kein WLAN gefunden. Verbinde beide Geräte mit demselben WLAN.'**
  String get shareNoWifi;

  /// No description provided for @shareWaiting.
  ///
  /// In de, this message translates to:
  /// **'Warte auf das andere Gerät …'**
  String get shareWaiting;

  /// No description provided for @shareJoined.
  ///
  /// In de, this message translates to:
  /// **'{name} ist dabei!'**
  String shareJoined(String name);

  /// No description provided for @shareSameWifi.
  ///
  /// In de, this message translates to:
  /// **'Gleiches WLAN, App auf beiden Geräten offen'**
  String get shareSameWifi;

  /// No description provided for @shareSecurityNote.
  ///
  /// In de, this message translates to:
  /// **'Der Code enthält den Schlüssel eures Haushalts. Zeige ihn nur Menschen, die dazugehören.'**
  String get shareSecurityNote;

  /// No description provided for @scanTitle.
  ///
  /// In de, this message translates to:
  /// **'QR-Code scannen'**
  String get scanTitle;

  /// No description provided for @scanSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Einem Haushalt beitreten oder direkt abgleichen'**
  String get scanSubtitle;

  /// No description provided for @scanHint.
  ///
  /// In de, this message translates to:
  /// **'Auf dem anderen Gerät: Haushalt → Gerät hinzufügen'**
  String get scanHint;

  /// No description provided for @joinTitle.
  ///
  /// In de, this message translates to:
  /// **'Haushalt von {name} beitreten'**
  String joinTitle(String name);

  /// No description provided for @joinKeepQuestion.
  ///
  /// In de, this message translates to:
  /// **'Auf diesem Gerät gibt es schon Einträge. Sollen sie in den gemeinsamen Haushalt übernommen werden?'**
  String get joinKeepQuestion;

  /// No description provided for @joinKeepMine.
  ///
  /// In de, this message translates to:
  /// **'Übernehmen'**
  String get joinKeepMine;

  /// No description provided for @joinDiscardMine.
  ///
  /// In de, this message translates to:
  /// **'Verwerfen'**
  String get joinDiscardMine;

  /// No description provided for @joinConnecting.
  ///
  /// In de, this message translates to:
  /// **'Verbinde …'**
  String get joinConnecting;

  /// No description provided for @joinSuccess.
  ///
  /// In de, this message translates to:
  /// **'Verbunden mit {name}'**
  String joinSuccess(String name);

  /// No description provided for @joinSavedNotReached.
  ///
  /// In de, this message translates to:
  /// **'Beigetreten. Das andere Gerät war gerade nicht erreichbar — abgeglichen wird, sobald beide im selben WLAN sind.'**
  String get joinSavedNotReached;

  /// No description provided for @syncOff.
  ///
  /// In de, this message translates to:
  /// **'Noch nicht geteilt'**
  String get syncOff;

  /// No description provided for @syncSearching.
  ///
  /// In de, this message translates to:
  /// **'Suche Geräte im WLAN …'**
  String get syncSearching;

  /// No description provided for @syncNearby.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Gerät verbunden} other{{count} Geräte verbunden}}'**
  String syncNearby(int count);

  /// No description provided for @syncNever.
  ///
  /// In de, this message translates to:
  /// **'Noch nie abgeglichen'**
  String get syncNever;

  /// No description provided for @syncLast.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt abgeglichen: {time}'**
  String syncLast(String time);

  /// No description provided for @syncNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt abgleichen'**
  String get syncNow;

  /// No description provided for @syncDone.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =0{Alles aktuell} =1{1 Änderung übernommen} other{{count} Änderungen übernommen}}'**
  String syncDone(int count);

  /// No description provided for @syncDevice.
  ///
  /// In de, this message translates to:
  /// **'Gerät'**
  String get syncDevice;

  /// No description provided for @syncLive.
  ///
  /// In de, this message translates to:
  /// **'Live mit anderen Geräten'**
  String get syncLive;

  /// No description provided for @onboardingWelcome.
  ///
  /// In de, this message translates to:
  /// **'Willkommen zu Hause'**
  String get onboardingWelcome;

  /// No description provided for @onboardingIntro.
  ///
  /// In de, this message translates to:
  /// **'Einkaufsliste, Haushaltsaufgaben und euer Rezeptbuch — an einem Ort, ohne Konto, alles bleibt bei euch.'**
  String get onboardingIntro;

  /// No description provided for @onboardingName.
  ///
  /// In de, this message translates to:
  /// **'Wie heißt du?'**
  String get onboardingName;

  /// No description provided for @onboardingStart.
  ///
  /// In de, this message translates to:
  /// **'Neuen Haushalt einrichten'**
  String get onboardingStart;

  /// No description provided for @onboardingJoin.
  ///
  /// In de, this message translates to:
  /// **'Bestehendem Haushalt beitreten'**
  String get onboardingJoin;

  /// No description provided for @onboardingJoinHint.
  ///
  /// In de, this message translates to:
  /// **'Jemand aus deinem Haushalt nutzt die App schon? Dann scanne den QR-Code von dessen Gerät.'**
  String get onboardingJoinHint;

  /// No description provided for @onboardingStores.
  ///
  /// In de, this message translates to:
  /// **'Wo kauft ihr ein?'**
  String get onboardingStores;

  /// No description provided for @onboardingStoresHint.
  ///
  /// In de, this message translates to:
  /// **'Artikel lassen sich einem Laden zuordnen; im Laden siehst du sie in Gang-Reihenfolge.'**
  String get onboardingStoresHint;

  /// No description provided for @onboardingStoresMore.
  ///
  /// In de, this message translates to:
  /// **'Weitere Läden kannst du später hinzufügen.'**
  String get onboardingStoresMore;

  /// No description provided for @onboardingChores.
  ///
  /// In de, this message translates to:
  /// **'Was fällt bei euch an?'**
  String get onboardingChores;

  /// No description provided for @onboardingChoresHint.
  ///
  /// In de, this message translates to:
  /// **'Antippen, was passt. Intervalle lassen sich später ändern.'**
  String get onboardingChoresHint;

  /// No description provided for @onboardingFinish.
  ///
  /// In de, this message translates to:
  /// **'Los geht’s'**
  String get onboardingFinish;

  /// No description provided for @kitchenRecipes.
  ///
  /// In de, this message translates to:
  /// **'Rezepte'**
  String get kitchenRecipes;

  /// No description provided for @kitchenPlan.
  ///
  /// In de, this message translates to:
  /// **'Wochenplan'**
  String get kitchenPlan;

  /// No description provided for @recipeAdd.
  ///
  /// In de, this message translates to:
  /// **'Rezept'**
  String get recipeAdd;

  /// No description provided for @recipeEdit.
  ///
  /// In de, this message translates to:
  /// **'Rezept bearbeiten'**
  String get recipeEdit;

  /// No description provided for @recipeAll.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get recipeAll;

  /// No description provided for @recipeFavorites.
  ///
  /// In de, this message translates to:
  /// **'Lieblinge'**
  String get recipeFavorites;

  /// No description provided for @recipeFavorite.
  ///
  /// In de, this message translates to:
  /// **'Liebling'**
  String get recipeFavorite;

  /// No description provided for @recipeNewCollection.
  ///
  /// In de, this message translates to:
  /// **'Sammlung'**
  String get recipeNewCollection;

  /// No description provided for @recipeSearch.
  ///
  /// In de, this message translates to:
  /// **'Rezept oder Zutat suchen'**
  String get recipeSearch;

  /// No description provided for @recipeEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Euer Rezeptbuch'**
  String get recipeEmptyTitle;

  /// No description provided for @recipeEmptyMessage.
  ///
  /// In de, this message translates to:
  /// **'Schreib eure Lieblingsrezepte auf — oder füge ein ganzes Rezept als Text ein. Familiengeschichten passen auch dazu.'**
  String get recipeEmptyMessage;

  /// No description provided for @recipeNoMatch.
  ///
  /// In de, this message translates to:
  /// **'Nichts gefunden'**
  String get recipeNoMatch;

  /// No description provided for @recipeServings.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Portion} other{{count} Portionen}}'**
  String recipeServings(int count);

  /// No description provided for @recipeServingsLabel.
  ///
  /// In de, this message translates to:
  /// **'Portionen'**
  String get recipeServingsLabel;

  /// No description provided for @recipeMinutes.
  ///
  /// In de, this message translates to:
  /// **'{count} min'**
  String recipeMinutes(int count);

  /// No description provided for @recipeTitle.
  ///
  /// In de, this message translates to:
  /// **'Name des Gerichts'**
  String get recipeTitle;

  /// No description provided for @recipeNeedsTitle.
  ///
  /// In de, this message translates to:
  /// **'Bitte gib dem Rezept einen Namen.'**
  String get recipeNeedsTitle;

  /// No description provided for @recipeIngredients.
  ///
  /// In de, this message translates to:
  /// **'Zutaten'**
  String get recipeIngredients;

  /// No description provided for @recipeIngredientsHint.
  ///
  /// In de, this message translates to:
  /// **'Eine pro Zeile, in der Reihenfolge der Verwendung:\n200 g Mehl\n2 Eier\nFür die Soße:'**
  String get recipeIngredientsHint;

  /// No description provided for @recipeSteps.
  ///
  /// In de, this message translates to:
  /// **'Zubereitung'**
  String get recipeSteps;

  /// No description provided for @recipeStepsHint.
  ///
  /// In de, this message translates to:
  /// **'Schritte durch eine Leerzeile trennen. Zeiten wie „20 Minuten“ werden im Kochmodus zum Timer.'**
  String get recipeStepsHint;

  /// No description provided for @recipeMoreDetails.
  ///
  /// In de, this message translates to:
  /// **'Mehr Details (Zeiten, Tipps, Geschichte …)'**
  String get recipeMoreDetails;

  /// No description provided for @recipePrep.
  ///
  /// In de, this message translates to:
  /// **'Vorbereiten'**
  String get recipePrep;

  /// No description provided for @recipeCook.
  ///
  /// In de, this message translates to:
  /// **'Kochen'**
  String get recipeCook;

  /// No description provided for @recipeRest.
  ///
  /// In de, this message translates to:
  /// **'Ruhen'**
  String get recipeRest;

  /// No description provided for @recipeEasy.
  ///
  /// In de, this message translates to:
  /// **'Leicht'**
  String get recipeEasy;

  /// No description provided for @recipeMedium.
  ///
  /// In de, this message translates to:
  /// **'Mittel'**
  String get recipeMedium;

  /// No description provided for @recipeHard.
  ///
  /// In de, this message translates to:
  /// **'Anspruchsvoll'**
  String get recipeHard;

  /// No description provided for @recipeTags.
  ///
  /// In de, this message translates to:
  /// **'Schlagworte'**
  String get recipeTags;

  /// No description provided for @recipeTagsHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. vegetarisch, Sommer, italienisch'**
  String get recipeTagsHint;

  /// No description provided for @recipeTips.
  ///
  /// In de, this message translates to:
  /// **'Tipps & Tricks'**
  String get recipeTips;

  /// No description provided for @recipeStory.
  ///
  /// In de, this message translates to:
  /// **'Geschichte zum Rezept'**
  String get recipeStory;

  /// No description provided for @recipeStoryHint.
  ///
  /// In de, this message translates to:
  /// **'Woran erinnert euch das Gericht? Von wem stammt es?'**
  String get recipeStoryHint;

  /// No description provided for @recipeSource.
  ///
  /// In de, this message translates to:
  /// **'Quelle'**
  String get recipeSource;

  /// No description provided for @recipeSourceLabel.
  ///
  /// In de, this message translates to:
  /// **'Quelle: {name}'**
  String recipeSourceLabel(String name);

  /// No description provided for @recipePasteTitle.
  ///
  /// In de, this message translates to:
  /// **'Ganzes Rezept einfügen'**
  String get recipePasteTitle;

  /// No description provided for @recipePasteHint.
  ///
  /// In de, this message translates to:
  /// **'Text einfügen — Zutaten und Zubereitung werden automatisch erkannt.'**
  String get recipePasteHint;

  /// No description provided for @recipePasteApply.
  ///
  /// In de, this message translates to:
  /// **'Übernehmen'**
  String get recipePasteApply;

  /// No description provided for @recipeGone.
  ///
  /// In de, this message translates to:
  /// **'Dieses Rezept gibt es nicht mehr.'**
  String get recipeGone;

  /// No description provided for @recipeDeleted.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ gelöscht'**
  String recipeDeleted(String name);

  /// No description provided for @recipePlan.
  ///
  /// In de, this message translates to:
  /// **'Im Wochenplan einplanen'**
  String get recipePlan;

  /// No description provided for @recipeToList.
  ///
  /// In de, this message translates to:
  /// **'Einkaufen'**
  String get recipeToList;

  /// No description provided for @recipeCookNow.
  ///
  /// In de, this message translates to:
  /// **'Kochen'**
  String get recipeCookNow;

  /// No description provided for @recipeToListTitle.
  ///
  /// In de, this message translates to:
  /// **'Was fehlt euch?'**
  String get recipeToListTitle;

  /// No description provided for @recipeToListHint.
  ///
  /// In de, this message translates to:
  /// **'Abhaken, was ihr schon da habt. Gleiche Artikel auf der Liste werden zusammengeführt.'**
  String get recipeToListHint;

  /// No description provided for @recipeToListConfirm.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Zutat auf die Liste} other{{count} Zutaten auf die Liste}}'**
  String recipeToListConfirm(int count);

  /// No description provided for @cookStep.
  ///
  /// In de, this message translates to:
  /// **'Schritt'**
  String get cookStep;

  /// No description provided for @cookStepOf.
  ///
  /// In de, this message translates to:
  /// **'{a} / {b}'**
  String cookStepOf(int a, int b);

  /// No description provided for @cookBack.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get cookBack;

  /// No description provided for @cookNext.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get cookNext;

  /// No description provided for @cookFinish.
  ///
  /// In de, this message translates to:
  /// **'Guten Appetit!'**
  String get cookFinish;

  /// No description provided for @planAdd.
  ///
  /// In de, this message translates to:
  /// **'Gericht einplanen'**
  String get planAdd;

  /// No description provided for @planAdded.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ eingeplant'**
  String planAdded(String name);

  /// No description provided for @planFreeText.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ eintragen'**
  String planFreeText(String name);

  /// No description provided for @planPickHint.
  ///
  /// In de, this message translates to:
  /// **'Rezept suchen oder z. B. „Pizza bestellen“'**
  String get planPickHint;

  /// No description provided for @planToday.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get planToday;

  /// No description provided for @planWeekToList.
  ///
  /// In de, this message translates to:
  /// **'Zutaten der Woche einkaufen'**
  String get planWeekToList;

  /// No description provided for @planWeekSource.
  ///
  /// In de, this message translates to:
  /// **'Wochenplan'**
  String get planWeekSource;

  /// No description provided for @planNothingToBuy.
  ///
  /// In de, this message translates to:
  /// **'In dieser Woche sind keine Rezepte eingeplant.'**
  String get planNothingToBuy;

  /// No description provided for @shopAddHint.
  ///
  /// In de, this message translates to:
  /// **'Was fehlt? z. B. „2 l Milch, Eier“'**
  String get shopAddHint;

  /// No description provided for @shopVoiceTooltip.
  ///
  /// In de, this message translates to:
  /// **'Per Sprache hinzufügen'**
  String get shopVoiceTooltip;

  /// No description provided for @shopAdded.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =0{Nichts hinzugefügt} =1{1 Artikel auf der Liste} other{{count} Artikel auf der Liste}}'**
  String shopAdded(int count);

  /// No description provided for @shopAddedNames.
  ///
  /// In de, this message translates to:
  /// **'Auf der Liste: {name}'**
  String shopAddedNames(String name);

  /// No description provided for @shopAllStores.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get shopAllStores;

  /// No description provided for @shopAmount.
  ///
  /// In de, this message translates to:
  /// **'Menge'**
  String get shopAmount;

  /// No description provided for @shopUnit.
  ///
  /// In de, this message translates to:
  /// **'Einheit'**
  String get shopUnit;

  /// No description provided for @shopNote.
  ///
  /// In de, this message translates to:
  /// **'Notiz'**
  String get shopNote;

  /// No description provided for @shopItemName.
  ///
  /// In de, this message translates to:
  /// **'Artikel'**
  String get shopItemName;

  /// No description provided for @shopAnyStore.
  ///
  /// In de, this message translates to:
  /// **'Egal wo'**
  String get shopAnyStore;

  /// No description provided for @shopWhere.
  ///
  /// In de, this message translates to:
  /// **'Wo kaufen?'**
  String get shopWhere;

  /// No description provided for @shopUsuallyAt.
  ///
  /// In de, this message translates to:
  /// **'Meist bei {name} gekauft'**
  String shopUsuallyAt(String name);

  /// No description provided for @shopDepartment.
  ///
  /// In de, this message translates to:
  /// **'Abteilung'**
  String get shopDepartment;

  /// No description provided for @shopDepartmentHint.
  ///
  /// In de, this message translates to:
  /// **'Wird für diesen Artikel gemerkt — auch auf den anderen Geräten.'**
  String get shopDepartmentHint;

  /// No description provided for @shopStaple.
  ///
  /// In de, this message translates to:
  /// **'Immer da haben'**
  String get shopStaple;

  /// No description provided for @shopStapleHint.
  ///
  /// In de, this message translates to:
  /// **'Erscheint als Vorschlag, wenn es länger nicht gekauft wurde.'**
  String get shopStapleHint;

  /// No description provided for @shopDeleted.
  ///
  /// In de, this message translates to:
  /// **'„{name}“ gelöscht'**
  String shopDeleted(String name);

  /// No description provided for @shopFor.
  ///
  /// In de, this message translates to:
  /// **'für {name}'**
  String shopFor(String name);

  /// No description provided for @shopManageStores.
  ///
  /// In de, this message translates to:
  /// **'Läden & Gänge'**
  String get shopManageStores;

  /// No description provided for @shopClearDone.
  ///
  /// In de, this message translates to:
  /// **'Erledigte entfernen'**
  String get shopClearDone;

  /// No description provided for @shopCleared.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =0{Nichts zu entfernen} =1{1 erledigter Artikel entfernt} other{{count} erledigte Artikel entfernt}}'**
  String shopCleared(int count);

  /// No description provided for @shopGoShopping.
  ///
  /// In de, this message translates to:
  /// **'Einkaufen'**
  String get shopGoShopping;

  /// No description provided for @shopGoShoppingAt.
  ///
  /// In de, this message translates to:
  /// **'Einkaufen bei {name}'**
  String shopGoShoppingAt(String name);

  /// No description provided for @shopWhichStore.
  ///
  /// In de, this message translates to:
  /// **'Wo kaufst du ein?'**
  String get shopWhichStore;

  /// No description provided for @shopEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Alles da!'**
  String get shopEmptyTitle;

  /// No description provided for @shopEmptyMessage.
  ///
  /// In de, this message translates to:
  /// **'Tippe oben, was fehlt — oder sag es einfach: „Milch, Eier und Spülmittel bei Rewe“.'**
  String get shopEmptyMessage;

  /// No description provided for @shopVoiceButton.
  ///
  /// In de, this message translates to:
  /// **'Sprechen'**
  String get shopVoiceButton;

  /// No description provided for @shopVoiceTitle.
  ///
  /// In de, this message translates to:
  /// **'Was fehlt?'**
  String get shopVoiceTitle;

  /// No description provided for @shopVoiceHint.
  ///
  /// In de, this message translates to:
  /// **'Zum Beispiel: „Zwei Liter Milch, Eier und Spülmittel bei Rewe“'**
  String get shopVoiceHint;

  /// No description provided for @shopOtherHint.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf ⋯ und wähle eine Abteilung — die App merkt es sich.'**
  String get shopOtherHint;

  /// No description provided for @shopDoneSection.
  ///
  /// In de, this message translates to:
  /// **'Erledigt ({count})'**
  String shopDoneSection(int count);

  /// No description provided for @shopRestock.
  ///
  /// In de, this message translates to:
  /// **'Bald wieder nötig:'**
  String get shopRestock;

  /// No description provided for @shopNotFoundAt.
  ///
  /// In de, this message translates to:
  /// **'Gab’s nicht bei {name}'**
  String shopNotFoundAt(String name);

  /// No description provided for @shopLastStore.
  ///
  /// In de, this message translates to:
  /// **'letztem Laden'**
  String get shopLastStore;

  /// No description provided for @storeModeTitle.
  ///
  /// In de, this message translates to:
  /// **'Bei {name}'**
  String storeModeTitle(String name);

  /// No description provided for @storeModeDone.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get storeModeDone;

  /// No description provided for @storeModeAllDone.
  ///
  /// In de, this message translates to:
  /// **'Alles im Wagen!'**
  String get storeModeAllDone;

  /// No description provided for @storeModeNotFound.
  ///
  /// In de, this message translates to:
  /// **'Gab’s nicht'**
  String get storeModeNotFound;

  /// No description provided for @storeModeCart.
  ///
  /// In de, this message translates to:
  /// **'Im Wagen ({count})'**
  String storeModeCart(int count);

  /// No description provided for @storeModeLeft.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Artikel ist noch offen.} other{{count} Artikel sind noch offen.}}'**
  String storeModeLeft(int count);

  /// No description provided for @storeModeMoveTo.
  ///
  /// In de, this message translates to:
  /// **'Für {name} vormerken'**
  String storeModeMoveTo(String name);

  /// No description provided for @storeModeKeep.
  ///
  /// In de, this message translates to:
  /// **'Auf der Liste lassen'**
  String get storeModeKeep;

  /// No description provided for @storesAdd.
  ///
  /// In de, this message translates to:
  /// **'Laden hinzufügen'**
  String get storesAdd;

  /// No description provided for @storesAddHint.
  ///
  /// In de, this message translates to:
  /// **'z. B. Lidl, Edeka, dm, Wochenmarkt'**
  String get storesAddHint;

  /// No description provided for @storesIntro.
  ///
  /// In de, this message translates to:
  /// **'Halte gedrückt und ziehe, um die Reihenfolge zu ändern. Tippe auf einen Laden für Name, Farbe und Gänge.'**
  String get storesIntro;

  /// No description provided for @storesOpen.
  ///
  /// In de, this message translates to:
  /// **'{count} offen'**
  String storesOpen(int count);

  /// No description provided for @storesDeleted.
  ///
  /// In de, this message translates to:
  /// **'{name} gelöscht'**
  String storesDeleted(String name);

  /// No description provided for @storesAisles.
  ///
  /// In de, this message translates to:
  /// **'Gang-Reihenfolge'**
  String get storesAisles;

  /// No description provided for @storesAislesHint.
  ///
  /// In de, this message translates to:
  /// **'Lernt beim Einkaufen von selbst mit. Hier kannst du sie auch selbst ziehen.'**
  String get storesAislesHint;

  /// No description provided for @storesAislesOf.
  ///
  /// In de, this message translates to:
  /// **'Gänge bei {name}'**
  String storesAislesOf(String name);

  /// No description provided for @storesDepartments.
  ///
  /// In de, this message translates to:
  /// **'Abteilungen'**
  String get storesDepartments;

  /// No description provided for @storesDepartmentsHint.
  ///
  /// In de, this message translates to:
  /// **'Reihenfolge der Ansicht „Alle“. Eigene Abteilungen mit +.'**
  String get storesDepartmentsHint;

  /// No description provided for @storesAddDepartment.
  ///
  /// In de, this message translates to:
  /// **'Abteilung hinzufügen'**
  String get storesAddDepartment;

  /// No description provided for @voiceListening.
  ///
  /// In de, this message translates to:
  /// **'Ich höre zu …'**
  String get voiceListening;

  /// No description provided for @voiceStarting.
  ///
  /// In de, this message translates to:
  /// **'Einen Moment …'**
  String get voiceStarting;

  /// No description provided for @voiceUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Spracherkennung ist auf diesem Gerät nicht verfügbar. Tippe es einfach:'**
  String get voiceUnavailable;

  /// No description provided for @voiceError.
  ///
  /// In de, this message translates to:
  /// **'Das hat nicht geklappt. Nochmal versuchen oder tippen:'**
  String get voiceError;

  /// No description provided for @voiceTypeInstead.
  ///
  /// In de, this message translates to:
  /// **'Milch, Eier, Brot …'**
  String get voiceTypeInstead;

  /// No description provided for @voiceRetry.
  ///
  /// In de, this message translates to:
  /// **'Nochmal'**
  String get voiceRetry;

  /// No description provided for @voiceDone.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get voiceDone;

  /// No description provided for @voiceNothing.
  ///
  /// In de, this message translates to:
  /// **'Ich habe keinen Artikel verstanden.'**
  String get voiceNothing;

  /// No description provided for @todayMorning.
  ///
  /// In de, this message translates to:
  /// **'Guten Morgen, {name}'**
  String todayMorning(String name);

  /// No description provided for @todayDay.
  ///
  /// In de, this message translates to:
  /// **'Hallo, {name}'**
  String todayDay(String name);

  /// No description provided for @todayEvening.
  ///
  /// In de, this message translates to:
  /// **'Guten Abend, {name}'**
  String todayEvening(String name);

  /// No description provided for @todayMeal.
  ///
  /// In de, this message translates to:
  /// **'Heute gibt’s'**
  String get todayMeal;

  /// No description provided for @todayChores.
  ///
  /// In de, this message translates to:
  /// **'Heute dran'**
  String get todayChores;

  /// No description provided for @todayAll.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get todayAll;

  /// No description provided for @todayNothingDue.
  ///
  /// In de, this message translates to:
  /// **'Nichts Dringendes — genießt den Tag.'**
  String get todayNothingDue;

  /// No description provided for @todayShoppingEmpty.
  ///
  /// In de, this message translates to:
  /// **'Einkaufsliste ist leer'**
  String get todayShoppingEmpty;

  /// No description provided for @todayShoppingOpen.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Artikel auf der Liste} other{{count} Artikel auf der Liste}}'**
  String todayShoppingOpen(int count);

  /// No description provided for @reminderChannel.
  ///
  /// In de, this message translates to:
  /// **'Haushalt'**
  String get reminderChannel;

  /// No description provided for @reminderChoresTitle.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{Heute dran: 1 Aufgabe} other{Heute dran: {count} Aufgaben}}'**
  String reminderChoresTitle(int count);

  /// No description provided for @reminderWasteTitle.
  ///
  /// In de, this message translates to:
  /// **'Morgen ist Abholung'**
  String get reminderWasteTitle;

  /// No description provided for @widgetOverdue.
  ///
  /// In de, this message translates to:
  /// **'überfällig'**
  String get widgetOverdue;

  /// No description provided for @widgetMealsTitle.
  ///
  /// In de, this message translates to:
  /// **'Essensplan'**
  String get widgetMealsTitle;

  /// No description provided for @widgetMealsEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch nichts geplant'**
  String get widgetMealsEmpty;

  /// No description provided for @widgetTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Morgen'**
  String get widgetTomorrow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
