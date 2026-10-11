// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get depProduce => 'Obst & Gemüse';

  @override
  String get depBakery => 'Brot & Backwaren';

  @override
  String get depDairy => 'Kühlregal';

  @override
  String get depMeat => 'Fleisch & Wurst';

  @override
  String get depFish => 'Fisch';

  @override
  String get depFrozen => 'Tiefkühl';

  @override
  String get depPasta => 'Nudeln, Reis & Getreide';

  @override
  String get depCanned => 'Konserven & Fertiges';

  @override
  String get depBaking => 'Backen';

  @override
  String get depSpices => 'Gewürze, Öl & Saucen';

  @override
  String get depBreakfast => 'Frühstück, Kaffee & Tee';

  @override
  String get depSweets => 'Süßes & Snacks';

  @override
  String get depDrinks => 'Getränke';

  @override
  String get depDrugstore => 'Drogerie & Hygiene';

  @override
  String get depHousehold => 'Haushalt & Putzmittel';

  @override
  String get depBaby => 'Baby';

  @override
  String get depPet => 'Tier';

  @override
  String get depOther => 'Sonstiges';

  @override
  String get areaGeneral => 'Ganze Wohnung';

  @override
  String get areaKitchen => 'Küche';

  @override
  String get areaBath => 'Bad';

  @override
  String get areaLiving => 'Wohnzimmer';

  @override
  String get areaBedroom => 'Schlafzimmer';

  @override
  String get areaLaundry => 'Wäsche';

  @override
  String get areaOutside => 'Draußen';

  @override
  String get tplVacuum => 'Staubsaugen';

  @override
  String get tplMop => 'Boden wischen';

  @override
  String get tplDust => 'Staub wischen';

  @override
  String get tplTrash => 'Mülleimer leeren';

  @override
  String get tplDishwasher => 'Spülmaschine ausräumen';

  @override
  String get tplFridge => 'Kühlschrank auswischen';

  @override
  String get tplStove => 'Herd & Ofen reinigen';

  @override
  String get tplBathroom => 'Bad putzen';

  @override
  String get tplTowels => 'Handtücher wechseln';

  @override
  String get tplDrain => 'Abfluss reinigen';

  @override
  String get tplBedding => 'Bettwäsche wechseln';

  @override
  String get tplLaundry => 'Wäsche waschen';

  @override
  String get tplPlants => 'Pflanzen gießen';

  @override
  String get tplGlass => 'Altglas wegbringen';

  @override
  String get tplWindows => 'Fenster putzen';

  @override
  String get wasteResidual => 'Restmüll';

  @override
  String get wasteOrganic => 'Bio';

  @override
  String get wastePaper => 'Papier';

  @override
  String get wastePackaging => 'Gelber Sack';

  @override
  String get wasteGlass => 'Glas';

  @override
  String get wasteOther => 'Sonstiges';

  @override
  String get choreAdd => 'Aufgabe';

  @override
  String get choreEdit => 'Aufgabe bearbeiten';

  @override
  String get choreAll => 'Alle';

  @override
  String get choreMine => 'Meine';

  @override
  String get choreAnyone => 'Wer Zeit hat';

  @override
  String get choreArea => 'Bereich';

  @override
  String choreCompleted(String name) {
    return '„$name“ erledigt — danke!';
  }

  @override
  String choreDeleted(String name) {
    return '„$name“ gelöscht';
  }

  @override
  String get choreDone => 'Erledigt';

  @override
  String choreDoneBy(String name) {
    return '$name hat’s gemacht';
  }

  @override
  String get choreDoneByMe => 'Hab ich gemacht';

  @override
  String get choreDoneTodayAlready => 'Heute schon erledigt';

  @override
  String choreDueIn(int count) {
    return 'in $count Tagen';
  }

  @override
  String choreDueSince(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'seit $count Tagen dran',
      one: 'seit gestern dran',
    );
    return '$_temp0';
  }

  @override
  String get choreDueToday => 'heute dran';

  @override
  String get choreDueTomorrow => 'morgen';

  @override
  String get choreEffort => 'Aufwand';

  @override
  String choreEffortMinutes(int count) {
    return '~$count min';
  }

  @override
  String get choreEmptyTitle => 'Nichts zu tun';

  @override
  String get choreEmptyMessage =>
      'Lege Aufgaben an — z. B. Staubsaugen alle 7 Tage. Die App zeigt dann, wann es wieder dran ist.';

  @override
  String choreEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alle $count Tage',
      one: 'täglich',
    );
    return '$_temp0';
  }

  @override
  String get choreFloatingHint =>
      'Gezählt ab der letzten Erledigung — wer später putzt, verschiebt den nächsten Termin.';

  @override
  String get choreHistory => 'Zuletzt erledigt';

  @override
  String get choreName => 'Was ist zu tun?';

  @override
  String get choreNameHint => 'z. B. Bad putzen';

  @override
  String get choreNoDate => 'Ohne Datum';

  @override
  String get choreRemind => 'In der Tageszusammenfassung';

  @override
  String get choreRemindHint =>
      'Eine gebündelte Erinnerung pro Tag — kein Dauer-Ping.';

  @override
  String get choreRepeat => 'Wiederholung';

  @override
  String get choreRepeatFloating => 'Regelmäßig';

  @override
  String get choreRepeatWeekly => 'Wochentage';

  @override
  String get choreRepeatOnce => 'Einmalig';

  @override
  String get choreRotating => 'Reihum';

  @override
  String get choreRotatingHint =>
      'Nach jedem Erledigen ist die nächste Person dran (pausierte werden übersprungen).';

  @override
  String get choreSectionDue => 'Jetzt dran';

  @override
  String get choreSectionSoon => 'Diese Woche';

  @override
  String get choreSectionLater => 'Später';

  @override
  String get choreSnooze => 'Heute nicht';

  @override
  String get choreWho => 'Wer?';

  @override
  String get fairnessTitle => 'Wer hat was gemacht';

  @override
  String get fairnessWeek => '7 Tage';

  @override
  String get fairnessMonth => '30 Tage';

  @override
  String get fairnessIntro =>
      'Aufwand in Minuten — zum Ausgleichen, nicht zum Vergleichen.';

  @override
  String get fairnessEmpty => 'Noch nichts erledigt in diesem Zeitraum.';

  @override
  String fairnessMinutes(int count) {
    return '$count min';
  }

  @override
  String get fairnessRecent => 'Zuletzt';

  @override
  String get wasteTitle => 'Müllabfuhr';

  @override
  String get wasteAdd => 'Termine hinzufügen';

  @override
  String get wasteImport => 'Abfallkalender importieren (.ics)';

  @override
  String wasteImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Termine hinzugefügt',
      one: '1 Termin hinzugefügt',
      zero: 'Keine neuen Termine',
    );
    return '$_temp0';
  }

  @override
  String get wasteEmptyTitle => 'Noch keine Abfuhrtermine';

  @override
  String get wasteEmptyMessage =>
      'Lade den Abfallkalender deiner Stadt als .ics herunter und importiere ihn — oder trage den Rhythmus selbst ein. Erinnerung kommt am Vorabend.';

  @override
  String get wasteFirstDate => 'Nächste Abholung';

  @override
  String get wasteRepeat => 'Rhythmus';

  @override
  String get wasteOnce => 'Einmalig';

  @override
  String get wasteWeekly => 'Wöchentlich';

  @override
  String get wasteBiweekly => 'Alle 2 Wochen';

  @override
  String get wasteFourWeekly => 'Alle 4 Wochen';

  @override
  String get wasteToday => 'Heute wird abgeholt';

  @override
  String get wasteTomorrow => 'Morgen früh rausstellen';

  @override
  String get wasteNobody => 'Wer Zeit hat';

  @override
  String wasteAssign(String name) {
    return '$name stellt raus';
  }

  @override
  String get wasteDeleteFuture => 'Alle künftigen Termine löschen';

  @override
  String get appTitle => 'Haushalt';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonRename => 'Umbenennen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonUndo => 'Rückgängig';

  @override
  String get tabToday => 'Heute';

  @override
  String get tabShopping => 'Einkauf';

  @override
  String get tabChores => 'Aufgaben';

  @override
  String get tabKitchen => 'Küche';

  @override
  String get householdTitle => 'Haushalt';

  @override
  String get householdPeople => 'Personen';

  @override
  String memberMe(String name) {
    return '$name (ich)';
  }

  @override
  String get memberAdd => 'Person hinzufügen';

  @override
  String get memberAddHint => 'Auch ohne eigenes Handy, z. B. Kinder';

  @override
  String get memberPaused => 'Pausiert (z. B. Urlaub)';

  @override
  String get memberPausedHint => 'Wird bei „Reihum“ übersprungen';

  @override
  String get memberRemove => 'Aus dem Haushalt entfernen';

  @override
  String get householdSharing => 'Teilen im WLAN';

  @override
  String get householdSharingIntro =>
      'Ohne Konto und ohne Cloud: Geräte im selben WLAN gleichen sich direkt und verschlüsselt ab, solange die App offen ist.';

  @override
  String get householdLeave => 'Haushalt verlassen';

  @override
  String get householdLeaveHint =>
      'Daten bleiben auf diesem Gerät, Teilen endet';

  @override
  String get householdLeaveConfirm =>
      'Dieses Gerät gleicht danach nicht mehr mit den anderen ab. Die Einträge bleiben hier als eigene Kopie erhalten.';

  @override
  String get householdReminders => 'Erinnerungen';

  @override
  String get remindersEnabled => 'Erinnerungen';

  @override
  String get remindersHint =>
      'Eine Tageszusammenfassung und Müll am Vorabend — sonst nichts.';

  @override
  String get remindersDenied =>
      'Benachrichtigungen sind in den Systemeinstellungen ausgeschaltet.';

  @override
  String get remindersSummary => 'Tageszusammenfassung';

  @override
  String get remindersWaste => 'Müll-Erinnerung (Vorabend)';

  @override
  String get householdAbout => 'Über die App';

  @override
  String get householdPrivacy =>
      'Alle Daten bleiben auf euren Geräten. Kein Konto, kein Server, keine Werbung. Geteilt wird nur direkt zwischen euren Geräten im selben WLAN, verschlüsselt mit einem Schlüssel aus dem QR-Code.';

  @override
  String get shareInviteTitle => 'Gerät hinzufügen';

  @override
  String get shareInviteSubtitle => 'QR-Code zeigen';

  @override
  String get shareInviteIntro =>
      'Öffne die App auf dem anderen Handy, wähle „QR-Code scannen“ und halte es hierauf. Beide Geräte müssen im selben WLAN sein.';

  @override
  String get shareNoWifi =>
      'Kein WLAN gefunden. Verbinde beide Geräte mit demselben WLAN.';

  @override
  String get shareWaiting => 'Warte auf das andere Gerät …';

  @override
  String shareJoined(String name) {
    return '$name ist dabei!';
  }

  @override
  String get shareSameWifi => 'Gleiches WLAN, App auf beiden Geräten offen';

  @override
  String get shareSecurityNote =>
      'Der Code enthält den Schlüssel eures Haushalts. Zeige ihn nur Menschen, die dazugehören.';

  @override
  String get scanTitle => 'QR-Code scannen';

  @override
  String get scanSubtitle => 'Einem Haushalt beitreten oder direkt abgleichen';

  @override
  String get scanHint => 'Auf dem anderen Gerät: Haushalt → Gerät hinzufügen';

  @override
  String joinTitle(String name) {
    return 'Haushalt von $name beitreten';
  }

  @override
  String get joinKeepQuestion =>
      'Auf diesem Gerät gibt es schon Einträge. Sollen sie in den gemeinsamen Haushalt übernommen werden?';

  @override
  String get joinKeepMine => 'Übernehmen';

  @override
  String get joinDiscardMine => 'Verwerfen';

  @override
  String get joinConnecting => 'Verbinde …';

  @override
  String joinSuccess(String name) {
    return 'Verbunden mit $name';
  }

  @override
  String get joinSavedNotReached =>
      'Beigetreten. Das andere Gerät war gerade nicht erreichbar — abgeglichen wird, sobald beide im selben WLAN sind.';

  @override
  String get syncOff => 'Noch nicht geteilt';

  @override
  String get syncSearching => 'Suche Geräte im WLAN …';

  @override
  String syncNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Geräte verbunden',
      one: '1 Gerät verbunden',
    );
    return '$_temp0';
  }

  @override
  String get syncNever => 'Noch nie abgeglichen';

  @override
  String syncLast(String time) {
    return 'Zuletzt abgeglichen: $time';
  }

  @override
  String get syncNow => 'Jetzt abgleichen';

  @override
  String syncDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Änderungen übernommen',
      one: '1 Änderung übernommen',
      zero: 'Alles aktuell',
    );
    return '$_temp0';
  }

  @override
  String get syncDevice => 'Gerät';

  @override
  String get syncLive => 'Live mit anderen Geräten';

  @override
  String get onboardingWelcome => 'Willkommen zu Hause';

  @override
  String get onboardingIntro =>
      'Einkaufsliste, Haushaltsaufgaben und euer Rezeptbuch — an einem Ort, ohne Konto, alles bleibt bei euch.';

  @override
  String get onboardingName => 'Wie heißt du?';

  @override
  String get onboardingStart => 'Neuen Haushalt einrichten';

  @override
  String get onboardingJoin => 'Bestehendem Haushalt beitreten';

  @override
  String get onboardingJoinHint =>
      'Jemand aus deinem Haushalt nutzt die App schon? Dann scanne den QR-Code von dessen Gerät.';

  @override
  String get onboardingStores => 'Wo kauft ihr ein?';

  @override
  String get onboardingStoresHint =>
      'Artikel lassen sich einem Laden zuordnen; im Laden siehst du sie in Gang-Reihenfolge.';

  @override
  String get onboardingStoresMore =>
      'Weitere Läden kannst du später hinzufügen.';

  @override
  String get onboardingChores => 'Was fällt bei euch an?';

  @override
  String get onboardingChoresHint =>
      'Antippen, was passt. Intervalle lassen sich später ändern.';

  @override
  String get onboardingFinish => 'Los geht’s';

  @override
  String get kitchenRecipes => 'Rezepte';

  @override
  String get kitchenPlan => 'Wochenplan';

  @override
  String get recipeAdd => 'Rezept';

  @override
  String get recipeEdit => 'Rezept bearbeiten';

  @override
  String get recipeAll => 'Alle';

  @override
  String get recipeFavorites => 'Lieblinge';

  @override
  String get recipeFavorite => 'Liebling';

  @override
  String get recipeNewCollection => 'Sammlung';

  @override
  String get recipeSearch => 'Rezept oder Zutat suchen';

  @override
  String get recipeEmptyTitle => 'Euer Rezeptbuch';

  @override
  String get recipeEmptyMessage =>
      'Schreib eure Lieblingsrezepte auf — oder füge ein ganzes Rezept als Text ein. Familiengeschichten passen auch dazu.';

  @override
  String get recipeNoMatch => 'Nichts gefunden';

  @override
  String recipeServings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Portionen',
      one: '1 Portion',
    );
    return '$_temp0';
  }

  @override
  String get recipeServingsLabel => 'Portionen';

  @override
  String recipeMinutes(int count) {
    return '$count min';
  }

  @override
  String get recipeTitle => 'Name des Gerichts';

  @override
  String get recipeNeedsTitle => 'Bitte gib dem Rezept einen Namen.';

  @override
  String get recipeIngredients => 'Zutaten';

  @override
  String get recipeIngredientsHint =>
      'Eine pro Zeile, in der Reihenfolge der Verwendung:\n200 g Mehl\n2 Eier\nFür die Soße:';

  @override
  String get recipeSteps => 'Zubereitung';

  @override
  String get recipeStepsHint =>
      'Schritte durch eine Leerzeile trennen. Zeiten wie „20 Minuten“ werden im Kochmodus zum Timer.';

  @override
  String get recipeMoreDetails => 'Mehr Details (Zeiten, Tipps, Geschichte …)';

  @override
  String get recipePrep => 'Vorbereiten';

  @override
  String get recipeCook => 'Kochen';

  @override
  String get recipeRest => 'Ruhen';

  @override
  String get recipeEasy => 'Leicht';

  @override
  String get recipeMedium => 'Mittel';

  @override
  String get recipeHard => 'Anspruchsvoll';

  @override
  String get recipeTags => 'Schlagworte';

  @override
  String get recipeTagsHint => 'z. B. vegetarisch, Sommer, italienisch';

  @override
  String get recipeTips => 'Tipps & Tricks';

  @override
  String get recipeStory => 'Geschichte zum Rezept';

  @override
  String get recipeStoryHint =>
      'Woran erinnert euch das Gericht? Von wem stammt es?';

  @override
  String get recipeSource => 'Quelle';

  @override
  String recipeSourceLabel(String name) {
    return 'Quelle: $name';
  }

  @override
  String get recipePasteTitle => 'Ganzes Rezept einfügen';

  @override
  String get recipePasteHint =>
      'Text einfügen — Zutaten und Zubereitung werden automatisch erkannt.';

  @override
  String get recipePasteApply => 'Übernehmen';

  @override
  String get recipeGone => 'Dieses Rezept gibt es nicht mehr.';

  @override
  String recipeDeleted(String name) {
    return '„$name“ gelöscht';
  }

  @override
  String get recipePlan => 'Im Wochenplan einplanen';

  @override
  String get recipeToList => 'Einkaufen';

  @override
  String get recipeCookNow => 'Kochen';

  @override
  String get recipeToListTitle => 'Was fehlt euch?';

  @override
  String get recipeToListHint =>
      'Abhaken, was ihr schon da habt. Gleiche Artikel auf der Liste werden zusammengeführt.';

  @override
  String recipeToListConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zutaten auf die Liste',
      one: '1 Zutat auf die Liste',
    );
    return '$_temp0';
  }

  @override
  String get cookStep => 'Schritt';

  @override
  String cookStepOf(int a, int b) {
    return '$a / $b';
  }

  @override
  String get cookBack => 'Zurück';

  @override
  String get cookNext => 'Weiter';

  @override
  String get cookFinish => 'Guten Appetit!';

  @override
  String get planAdd => 'Gericht einplanen';

  @override
  String planAdded(String name) {
    return '„$name“ eingeplant';
  }

  @override
  String planFreeText(String name) {
    return '„$name“ eintragen';
  }

  @override
  String get planPickHint => 'Rezept suchen oder z. B. „Pizza bestellen“';

  @override
  String get planToday => 'Heute';

  @override
  String get planWeekToList => 'Zutaten der Woche einkaufen';

  @override
  String get planWeekSource => 'Wochenplan';

  @override
  String get planNothingToBuy =>
      'In dieser Woche sind keine Rezepte eingeplant.';

  @override
  String get shopAddHint => 'Was fehlt? z. B. „2 l Milch, Eier“';

  @override
  String get shopVoiceTooltip => 'Per Sprache hinzufügen';

  @override
  String shopAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel auf der Liste',
      one: '1 Artikel auf der Liste',
      zero: 'Nichts hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String shopAddedNames(String name) {
    return 'Auf der Liste: $name';
  }

  @override
  String get shopAllStores => 'Alle';

  @override
  String get shopAmount => 'Menge';

  @override
  String get shopUnit => 'Einheit';

  @override
  String get shopNote => 'Notiz';

  @override
  String get shopItemName => 'Artikel';

  @override
  String get shopAnyStore => 'Egal wo';

  @override
  String get shopWhere => 'Wo kaufen?';

  @override
  String shopUsuallyAt(String name) {
    return 'Meist bei $name gekauft';
  }

  @override
  String get shopDepartment => 'Abteilung';

  @override
  String get shopDepartmentHint =>
      'Wird für diesen Artikel gemerkt — auch auf den anderen Geräten.';

  @override
  String get shopStaple => 'Immer da haben';

  @override
  String get shopStapleHint =>
      'Erscheint als Vorschlag, wenn es länger nicht gekauft wurde.';

  @override
  String shopDeleted(String name) {
    return '„$name“ gelöscht';
  }

  @override
  String shopFor(String name) {
    return 'für $name';
  }

  @override
  String get shopManageStores => 'Läden & Gänge';

  @override
  String get shopClearDone => 'Erledigte entfernen';

  @override
  String shopCleared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erledigte Artikel entfernt',
      one: '1 erledigter Artikel entfernt',
      zero: 'Nichts zu entfernen',
    );
    return '$_temp0';
  }

  @override
  String get shopGoShopping => 'Einkaufen';

  @override
  String shopGoShoppingAt(String name) {
    return 'Einkaufen bei $name';
  }

  @override
  String get shopWhichStore => 'Wo kaufst du ein?';

  @override
  String get shopEmptyTitle => 'Alles da!';

  @override
  String get shopEmptyMessage =>
      'Tippe oben, was fehlt — oder sag es einfach: „Milch, Eier und Spülmittel bei Rewe“.';

  @override
  String get shopVoiceButton => 'Sprechen';

  @override
  String get shopVoiceTitle => 'Was fehlt?';

  @override
  String get shopVoiceHint =>
      'Zum Beispiel: „Zwei Liter Milch, Eier und Spülmittel bei Rewe“';

  @override
  String get shopOtherHint =>
      'Tippe auf ⋯ und wähle eine Abteilung — die App merkt es sich.';

  @override
  String shopDoneSection(int count) {
    return 'Erledigt ($count)';
  }

  @override
  String get shopRestock => 'Bald wieder nötig:';

  @override
  String shopNotFoundAt(String name) {
    return 'Gab’s nicht bei $name';
  }

  @override
  String get shopLastStore => 'letztem Laden';

  @override
  String storeModeTitle(String name) {
    return 'Bei $name';
  }

  @override
  String get storeModeDone => 'Fertig';

  @override
  String get storeModeAllDone => 'Alles im Wagen!';

  @override
  String get storeModeNotFound => 'Gab’s nicht';

  @override
  String storeModeCart(int count) {
    return 'Im Wagen ($count)';
  }

  @override
  String storeModeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel sind noch offen.',
      one: '1 Artikel ist noch offen.',
    );
    return '$_temp0';
  }

  @override
  String storeModeMoveTo(String name) {
    return 'Für $name vormerken';
  }

  @override
  String get storeModeKeep => 'Auf der Liste lassen';

  @override
  String get storesAdd => 'Laden hinzufügen';

  @override
  String get storesAddHint => 'z. B. Lidl, Edeka, dm, Wochenmarkt';

  @override
  String get storesIntro =>
      'Halte gedrückt und ziehe, um die Reihenfolge zu ändern. Tippe auf einen Laden für Name, Farbe und Gänge.';

  @override
  String storesOpen(int count) {
    return '$count offen';
  }

  @override
  String storesDeleted(String name) {
    return '$name gelöscht';
  }

  @override
  String get storesAisles => 'Gang-Reihenfolge';

  @override
  String get storesAislesHint =>
      'Lernt beim Einkaufen von selbst mit. Hier kannst du sie auch selbst ziehen.';

  @override
  String storesAislesOf(String name) {
    return 'Gänge bei $name';
  }

  @override
  String get storesDepartments => 'Abteilungen';

  @override
  String get storesDepartmentsHint =>
      'Reihenfolge der Ansicht „Alle“. Eigene Abteilungen mit +.';

  @override
  String get storesAddDepartment => 'Abteilung hinzufügen';

  @override
  String get voiceListening => 'Ich höre zu …';

  @override
  String get voiceStarting => 'Einen Moment …';

  @override
  String get voiceUnavailable =>
      'Spracherkennung ist auf diesem Gerät nicht verfügbar. Tippe es einfach:';

  @override
  String get voiceError =>
      'Das hat nicht geklappt. Nochmal versuchen oder tippen:';

  @override
  String get voiceTypeInstead => 'Milch, Eier, Brot …';

  @override
  String get voiceRetry => 'Nochmal';

  @override
  String get voiceDone => 'Fertig';

  @override
  String get voiceNothing => 'Ich habe keinen Artikel verstanden.';

  @override
  String todayMorning(String name) {
    return 'Guten Morgen, $name';
  }

  @override
  String todayDay(String name) {
    return 'Hallo, $name';
  }

  @override
  String todayEvening(String name) {
    return 'Guten Abend, $name';
  }

  @override
  String get todayMeal => 'Heute gibt’s';

  @override
  String get todayChores => 'Heute dran';

  @override
  String get todayAll => 'Alle';

  @override
  String get todayNothingDue => 'Nichts Dringendes — genießt den Tag.';

  @override
  String get todayShoppingEmpty => 'Einkaufsliste ist leer';

  @override
  String todayShoppingOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel auf der Liste',
      one: '1 Artikel auf der Liste',
    );
    return '$_temp0';
  }

  @override
  String get reminderChannel => 'Haushalt';

  @override
  String reminderChoresTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Heute dran: $count Aufgaben',
      one: 'Heute dran: 1 Aufgabe',
    );
    return '$_temp0';
  }

  @override
  String get reminderWasteTitle => 'Morgen ist Abholung';
}
