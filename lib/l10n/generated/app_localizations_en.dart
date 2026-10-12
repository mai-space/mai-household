// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupIntro =>
      'All lists, chores, recipes and settings, encrypted in one file — for a new phone or just in case. It cannot be read without the password.';

  @override
  String get backupCreate => 'Back up';

  @override
  String get backupRestore => 'Restore';

  @override
  String get backupCreated => 'Backup created';

  @override
  String get backupFailed => 'Sorry, that did not work.';

  @override
  String get backupPassphrase => 'Password';

  @override
  String get backupPassphraseCreateHint =>
      'Choose a password for the backup. It cannot be restored without it — keep it safe!';

  @override
  String get backupPassphraseRestoreHint => 'Backup password';

  @override
  String get backupPassphraseRepeat => 'Repeat password';

  @override
  String get backupPassphraseMismatch => 'Passwords do not match';

  @override
  String get backupPassphraseTooShort => 'At least 8 characters';

  @override
  String get backupPick => 'Choose backup';

  @override
  String get backupReplace => 'Replace';

  @override
  String get backupRestoreConfirmTitle => 'Replace all data?';

  @override
  String get backupRestoreConfirmText =>
      'Shopping list, chores, recipes and settings on this device will be replaced by the backup. If you share your household, the devices sync again afterwards — newer changes from the others are kept.';

  @override
  String backupRestored(String date) {
    return 'Backup from $date restored';
  }

  @override
  String get backupShareSubject => 'Household backup';

  @override
  String get backupTooNew =>
      'This backup is from a newer app version. Please update the app.';

  @override
  String get backupUnsupported => 'Backups are not available here.';

  @override
  String get backupWrongApp => 'This is not a Household backup.';

  @override
  String get backupContinue => 'Continue';

  @override
  String get onboardingRestore => 'I have a backup';

  @override
  String get depProduce => 'Fruit & vegetables';

  @override
  String get depBakery => 'Bakery';

  @override
  String get depDairy => 'Dairy & chilled';

  @override
  String get depMeat => 'Meat & sausages';

  @override
  String get depFish => 'Fish';

  @override
  String get depFrozen => 'Frozen';

  @override
  String get depPasta => 'Pasta, rice & grains';

  @override
  String get depCanned => 'Canned & ready meals';

  @override
  String get depBaking => 'Baking';

  @override
  String get depSpices => 'Spices, oil & sauces';

  @override
  String get depBreakfast => 'Breakfast, coffee & tea';

  @override
  String get depSweets => 'Sweets & snacks';

  @override
  String get depDrinks => 'Drinks';

  @override
  String get depDrugstore => 'Toiletries';

  @override
  String get depHousehold => 'Household & cleaning';

  @override
  String get depBaby => 'Baby';

  @override
  String get depPet => 'Pets';

  @override
  String get depOther => 'Other';

  @override
  String get areaGeneral => 'Whole home';

  @override
  String get areaKitchen => 'Kitchen';

  @override
  String get areaBath => 'Bathroom';

  @override
  String get areaLiving => 'Living room';

  @override
  String get areaBedroom => 'Bedroom';

  @override
  String get areaLaundry => 'Laundry';

  @override
  String get areaOutside => 'Outside';

  @override
  String get tplVacuum => 'Vacuum';

  @override
  String get tplMop => 'Mop the floor';

  @override
  String get tplDust => 'Dusting';

  @override
  String get tplTrash => 'Empty the bins';

  @override
  String get tplDishwasher => 'Unload dishwasher';

  @override
  String get tplFridge => 'Clean the fridge';

  @override
  String get tplStove => 'Clean stove & oven';

  @override
  String get tplBathroom => 'Clean the bathroom';

  @override
  String get tplTowels => 'Change towels';

  @override
  String get tplDrain => 'Clean the drain';

  @override
  String get tplBedding => 'Change bedding';

  @override
  String get tplLaundry => 'Do the laundry';

  @override
  String get tplPlants => 'Water the plants';

  @override
  String get tplGlass => 'Take out glass';

  @override
  String get tplWindows => 'Clean windows';

  @override
  String get wasteResidual => 'General waste';

  @override
  String get wasteOrganic => 'Organic';

  @override
  String get wastePaper => 'Paper';

  @override
  String get wastePackaging => 'Packaging';

  @override
  String get wasteGlass => 'Glass';

  @override
  String get wasteOther => 'Other';

  @override
  String get choreAdd => 'Chore';

  @override
  String get choreEdit => 'Edit chore';

  @override
  String get choreAll => 'All';

  @override
  String get choreMine => 'Mine';

  @override
  String get choreAnyone => 'Whoever has time';

  @override
  String get choreArea => 'Area';

  @override
  String choreCompleted(String name) {
    return '“$name” done — thanks!';
  }

  @override
  String choreDeleted(String name) {
    return '“$name” deleted';
  }

  @override
  String get choreDone => 'Done';

  @override
  String choreDoneBy(String name) {
    return '$name did it';
  }

  @override
  String get choreDoneByMe => 'I did it';

  @override
  String get choreDoneTodayAlready => 'Already done today';

  @override
  String choreDueIn(int count) {
    return 'in $count days';
  }

  @override
  String choreDueSince(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'due for $count days',
      one: 'due since yesterday',
    );
    return '$_temp0';
  }

  @override
  String get choreDueToday => 'due today';

  @override
  String get choreDueTomorrow => 'tomorrow';

  @override
  String get choreEffort => 'Effort';

  @override
  String choreEffortMinutes(int count) {
    return '~$count min';
  }

  @override
  String get choreEmptyTitle => 'Nothing to do';

  @override
  String get choreEmptyMessage =>
      'Add chores — e.g. vacuum every 7 days. The app shows when it’s due again.';

  @override
  String choreEveryDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'every $count days',
      one: 'daily',
    );
    return '$_temp0';
  }

  @override
  String get choreFloatingHint =>
      'Counted from the last time it was done — doing it later moves the next date.';

  @override
  String get choreHistory => 'Recently done';

  @override
  String get choreName => 'What needs doing?';

  @override
  String get choreNameHint => 'e.g. clean the bathroom';

  @override
  String get choreNoDate => 'No date';

  @override
  String get choreRemind => 'In the daily summary';

  @override
  String get choreRemindHint =>
      'One bundled reminder per day — no constant pings.';

  @override
  String get choreRepeat => 'Repeat';

  @override
  String get choreRepeatFloating => 'Regularly';

  @override
  String get choreRepeatWeekly => 'Weekdays';

  @override
  String get choreRepeatOnce => 'Once';

  @override
  String get choreRotating => 'Taking turns';

  @override
  String get choreRotatingHint =>
      'After each completion it’s the next person’s turn (paused people are skipped).';

  @override
  String get choreSectionDue => 'Due now';

  @override
  String get choreSectionSoon => 'This week';

  @override
  String get choreSectionLater => 'Later';

  @override
  String get choreSnooze => 'Not today';

  @override
  String get choreWho => 'Who?';

  @override
  String get fairnessTitle => 'Who did what';

  @override
  String get fairnessWeek => '7 days';

  @override
  String get fairnessMonth => '30 days';

  @override
  String get fairnessIntro =>
      'Effort in minutes — for balance, not competition.';

  @override
  String get fairnessEmpty => 'Nothing done in this period yet.';

  @override
  String fairnessMinutes(int count) {
    return '$count min';
  }

  @override
  String get fairnessRecent => 'Recently';

  @override
  String get wasteTitle => 'Bin collection';

  @override
  String get wasteAdd => 'Add dates';

  @override
  String get wasteImport => 'Import waste calendar (.ics)';

  @override
  String wasteImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dates added',
      one: '1 date added',
      zero: 'No new dates',
    );
    return '$_temp0';
  }

  @override
  String get wasteEmptyTitle => 'No collection dates yet';

  @override
  String get wasteEmptyMessage =>
      'Download your city’s waste calendar as .ics and import it — or enter the rhythm yourself. You’ll be reminded the evening before.';

  @override
  String get wasteFirstDate => 'Next collection';

  @override
  String get wasteRepeat => 'Rhythm';

  @override
  String get wasteOnce => 'Once';

  @override
  String get wasteWeekly => 'Weekly';

  @override
  String get wasteBiweekly => 'Every 2 weeks';

  @override
  String get wasteFourWeekly => 'Every 4 weeks';

  @override
  String get wasteToday => 'Collected today';

  @override
  String get wasteTomorrow => 'Put out for tomorrow morning';

  @override
  String get wasteNobody => 'Whoever has time';

  @override
  String wasteAssign(String name) {
    return '$name puts it out';
  }

  @override
  String get wasteDeleteFuture => 'Delete all future dates';

  @override
  String get appTitle => 'Haushalt';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonNext => 'Next';

  @override
  String get commonRename => 'Rename';

  @override
  String get commonSave => 'Save';

  @override
  String get commonUndo => 'Undo';

  @override
  String get tabToday => 'Today';

  @override
  String get tabShopping => 'Shopping';

  @override
  String get tabChores => 'Chores';

  @override
  String get tabKitchen => 'Kitchen';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonUnderstood => 'Got it';

  @override
  String get keyUnavailableTitle => 'Data not readable right now';

  @override
  String get keyUnavailableText =>
      'The key for your encrypted data is not available right now. Your data is safe — try again in a moment or restart your device.';

  @override
  String get unreadableTitle => 'Old data could not be read';

  @override
  String get unreadableText =>
      'Your previous data could no longer be decrypted on this device and was set aside. If you share your household with other devices, the shared lists come back with the next sync.';

  @override
  String get householdTitle => 'Household';

  @override
  String get householdPeople => 'People';

  @override
  String memberMe(String name) {
    return '$name (me)';
  }

  @override
  String get memberAdd => 'Add person';

  @override
  String get memberAddHint => 'Also without a phone, e.g. kids';

  @override
  String get memberPaused => 'Paused (e.g. holiday)';

  @override
  String get memberPausedHint => 'Skipped when taking turns';

  @override
  String get memberRemove => 'Remove from household';

  @override
  String get householdSharing => 'Sharing over Wi-Fi';

  @override
  String get householdSharingIntro =>
      'No account, no cloud: devices on the same Wi-Fi sync directly and encrypted while the app is open.';

  @override
  String get householdLeave => 'Leave household';

  @override
  String get householdLeaveHint => 'Data stays on this device, sharing stops';

  @override
  String get householdLeaveConfirm =>
      'This device will stop syncing with the others. Your entries stay here as your own copy.';

  @override
  String get householdReminders => 'Reminders';

  @override
  String get remindersEnabled => 'Reminders';

  @override
  String get remindersHint =>
      'One daily summary and bins the evening before — nothing else.';

  @override
  String get remindersDenied =>
      'Notifications are turned off in system settings.';

  @override
  String get remindersSummary => 'Daily summary';

  @override
  String get remindersWaste => 'Bin reminder (evening before)';

  @override
  String get householdAbout => 'About';

  @override
  String get householdPrivacy =>
      'All data stays on your devices. No account, no server, no ads. Sharing only happens directly between your devices on the same Wi-Fi, encrypted with a key from the QR code.';

  @override
  String get shareInviteTitle => 'Add a device';

  @override
  String get shareInviteSubtitle => 'Show QR code';

  @override
  String get shareInviteIntro =>
      'Open the app on the other phone, choose “Scan QR code” and point it here. Both devices need to be on the same Wi-Fi.';

  @override
  String get shareNoWifi =>
      'No Wi-Fi found. Connect both devices to the same Wi-Fi.';

  @override
  String get shareWaiting => 'Waiting for the other device …';

  @override
  String shareJoined(String name) {
    return '$name has joined!';
  }

  @override
  String get shareSameWifi => 'Same Wi-Fi, app open on both devices';

  @override
  String get shareSecurityNote =>
      'The code contains your household key. Only show it to people who belong to your household.';

  @override
  String get scanTitle => 'Scan QR code';

  @override
  String get scanSubtitle => 'Join a household or sync directly';

  @override
  String get scanHint => 'On the other device: Household → Add a device';

  @override
  String joinTitle(String name) {
    return 'Join $name’s household';
  }

  @override
  String get joinKeepQuestion =>
      'This device already has entries. Should they be added to the shared household?';

  @override
  String get joinKeepMine => 'Bring them along';

  @override
  String get joinDiscardMine => 'Discard';

  @override
  String get joinConnecting => 'Connecting …';

  @override
  String joinSuccess(String name) {
    return 'Connected with $name';
  }

  @override
  String get joinSavedNotReached =>
      'Joined. The other device couldn’t be reached right now — syncing starts once both are on the same Wi-Fi.';

  @override
  String get syncOff => 'Not shared yet';

  @override
  String get syncSearching => 'Looking for devices on Wi-Fi …';

  @override
  String syncNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices connected',
      one: '1 device connected',
    );
    return '$_temp0';
  }

  @override
  String get syncNever => 'Never synced';

  @override
  String syncLast(String time) {
    return 'Last synced: $time';
  }

  @override
  String get syncNow => 'Sync now';

  @override
  String syncDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes received',
      one: '1 change received',
      zero: 'Everything up to date',
    );
    return '$_temp0';
  }

  @override
  String get syncDevice => 'Device';

  @override
  String get syncLive => 'Live with other devices';

  @override
  String get onboardingWelcome => 'Welcome home';

  @override
  String get onboardingIntro =>
      'Shopping list, chores and your recipe book — in one place, no account, everything stays with you.';

  @override
  String get onboardingName => 'What’s your name?';

  @override
  String get onboardingStart => 'Set up a new household';

  @override
  String get onboardingJoin => 'Join an existing household';

  @override
  String get onboardingJoinHint =>
      'Someone in your household already uses the app? Scan the QR code on their device.';

  @override
  String get onboardingStores => 'Where do you shop?';

  @override
  String get onboardingStoresHint =>
      'Items can be assigned to a store; in the store you see them in aisle order.';

  @override
  String get onboardingStoresMore => 'You can add more stores later.';

  @override
  String get onboardingChores => 'What needs doing at your place?';

  @override
  String get onboardingChoresHint =>
      'Tap what fits. Intervals can be changed later.';

  @override
  String get onboardingFinish => 'Let’s go';

  @override
  String get kitchenRecipes => 'Recipes';

  @override
  String get kitchenPlan => 'Meal plan';

  @override
  String get recipeAdd => 'Recipe';

  @override
  String get recipeEdit => 'Edit recipe';

  @override
  String get recipeAll => 'All';

  @override
  String get recipeFavorites => 'Favourites';

  @override
  String get recipeFavorite => 'Favourite';

  @override
  String get recipeNewCollection => 'Collection';

  @override
  String get recipeSearch => 'Search recipe or ingredient';

  @override
  String get recipeEmptyTitle => 'Your recipe book';

  @override
  String get recipeEmptyMessage =>
      'Write down your favourite recipes — or paste a whole recipe as text. Family stories belong here too.';

  @override
  String get recipeNoMatch => 'Nothing found';

  @override
  String recipeServings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servings',
      one: '1 serving',
    );
    return '$_temp0';
  }

  @override
  String get recipeServingsLabel => 'Servings';

  @override
  String recipeMinutes(int count) {
    return '$count min';
  }

  @override
  String get recipeTitle => 'Dish name';

  @override
  String get recipeNeedsTitle => 'Please give the recipe a name.';

  @override
  String get recipeIngredients => 'Ingredients';

  @override
  String get recipeIngredientsHint =>
      'One per line, in order of use:\n200 g flour\n2 eggs\nFor the sauce:';

  @override
  String get recipeSteps => 'Method';

  @override
  String get recipeStepsHint =>
      'Separate steps with a blank line. Times like “20 minutes” become timers in cooking mode.';

  @override
  String get recipeMoreDetails => 'More details (times, tips, story …)';

  @override
  String get recipePrep => 'Prep';

  @override
  String get recipeCook => 'Cook';

  @override
  String get recipeRest => 'Rest';

  @override
  String get recipeEasy => 'Easy';

  @override
  String get recipeMedium => 'Medium';

  @override
  String get recipeHard => 'Challenging';

  @override
  String get recipeTags => 'Tags';

  @override
  String get recipeTagsHint => 'e.g. vegetarian, summer, Italian';

  @override
  String get recipeTips => 'Tips & tricks';

  @override
  String get recipeStory => 'The story behind it';

  @override
  String get recipeStoryHint =>
      'What does this dish remind you of? Who is it from?';

  @override
  String get recipeSource => 'Source';

  @override
  String recipeSourceLabel(String name) {
    return 'Source: $name';
  }

  @override
  String get recipePasteTitle => 'Paste a whole recipe';

  @override
  String get recipePasteHint =>
      'Paste text — ingredients and method are detected automatically.';

  @override
  String get recipePasteApply => 'Apply';

  @override
  String get recipeGone => 'This recipe no longer exists.';

  @override
  String recipeDeleted(String name) {
    return '“$name” deleted';
  }

  @override
  String get recipePlan => 'Add to meal plan';

  @override
  String get recipeToList => 'Shop';

  @override
  String get recipeCookNow => 'Cook';

  @override
  String get recipeToListTitle => 'What do you need?';

  @override
  String get recipeToListHint =>
      'Uncheck what you already have. Matching items on the list are merged.';

  @override
  String recipeToListConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count ingredients',
      one: 'Add 1 ingredient',
    );
    return '$_temp0';
  }

  @override
  String get cookStep => 'Step';

  @override
  String cookStepOf(int a, int b) {
    return '$a / $b';
  }

  @override
  String get cookBack => 'Back';

  @override
  String get cookNext => 'Next';

  @override
  String get cookFinish => 'Enjoy!';

  @override
  String get planAdd => 'Plan a meal';

  @override
  String planAdded(String name) {
    return '“$name” planned';
  }

  @override
  String planFreeText(String name) {
    return 'Add “$name”';
  }

  @override
  String get planPickHint => 'Search recipe or e.g. “order pizza”';

  @override
  String get planToday => 'Today';

  @override
  String get planWeekToList => 'Shop this week’s ingredients';

  @override
  String get planWeekSource => 'meal plan';

  @override
  String get planNothingToBuy => 'No recipes planned this week.';

  @override
  String get shopAddHint => 'What’s missing? e.g. “2 l milk, eggs”';

  @override
  String get shopVoiceTooltip => 'Add by voice';

  @override
  String shopAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items on the list',
      one: '1 item on the list',
      zero: 'Nothing added',
    );
    return '$_temp0';
  }

  @override
  String shopAddedNames(String name) {
    return 'On the list: $name';
  }

  @override
  String get shopAllStores => 'All';

  @override
  String get shopAmount => 'Amount';

  @override
  String get shopUnit => 'Unit';

  @override
  String get shopNote => 'Note';

  @override
  String get shopItemName => 'Item';

  @override
  String get shopAnyStore => 'Anywhere';

  @override
  String get shopWhere => 'Where to buy?';

  @override
  String shopUsuallyAt(String name) {
    return 'Usually bought at $name';
  }

  @override
  String get shopDepartment => 'Department';

  @override
  String get shopDepartmentHint =>
      'Remembered for this item — on the other devices too.';

  @override
  String get shopStaple => 'Always keep in stock';

  @override
  String get shopStapleHint =>
      'Suggested again when it hasn’t been bought for a while.';

  @override
  String shopDeleted(String name) {
    return '“$name” deleted';
  }

  @override
  String shopFor(String name) {
    return 'for $name';
  }

  @override
  String get shopManageStores => 'Stores & aisles';

  @override
  String get shopClearDone => 'Remove checked items';

  @override
  String shopCleared(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count checked items removed',
      one: '1 checked item removed',
      zero: 'Nothing to remove',
    );
    return '$_temp0';
  }

  @override
  String get shopGoShopping => 'Go shopping';

  @override
  String shopGoShoppingAt(String name) {
    return 'Shop at $name';
  }

  @override
  String get shopWhichStore => 'Where are you shopping?';

  @override
  String get shopEmptyTitle => 'All stocked up!';

  @override
  String get shopEmptyMessage =>
      'Type what’s missing above — or just say it: “milk, eggs and dish soap at Rewe”.';

  @override
  String get shopVoiceButton => 'Speak';

  @override
  String get shopVoiceTitle => 'What’s missing?';

  @override
  String get shopVoiceHint =>
      'For example: “Two litres of milk, eggs and dish soap at Rewe”';

  @override
  String get shopOtherHint =>
      'Tap ⋯ and pick a department — the app will remember.';

  @override
  String shopDoneSection(int count) {
    return 'Checked ($count)';
  }

  @override
  String get shopRestock => 'Needed again soon:';

  @override
  String shopNotFoundAt(String name) {
    return 'Not available at $name';
  }

  @override
  String get shopLastStore => 'last store';

  @override
  String storeModeTitle(String name) {
    return 'At $name';
  }

  @override
  String get storeModeDone => 'Done';

  @override
  String get storeModeAllDone => 'All in the cart!';

  @override
  String get storeModeNotFound => 'Not available';

  @override
  String storeModeCart(int count) {
    return 'In the cart ($count)';
  }

  @override
  String storeModeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items are still open.',
      one: '1 item is still open.',
    );
    return '$_temp0';
  }

  @override
  String storeModeMoveTo(String name) {
    return 'Save for $name';
  }

  @override
  String get storeModeKeep => 'Keep on the list';

  @override
  String get storesAdd => 'Add store';

  @override
  String get storesAddHint => 'e.g. Lidl, Edeka, farmers market';

  @override
  String get storesIntro =>
      'Long-press and drag to reorder. Tap a store for name, colour and aisles.';

  @override
  String storesOpen(int count) {
    return '$count open';
  }

  @override
  String storesDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get storesAisles => 'Aisle order';

  @override
  String get storesAislesHint =>
      'Learns automatically while you shop. You can also drag it yourself here.';

  @override
  String storesAislesOf(String name) {
    return 'Aisles at $name';
  }

  @override
  String get storesDepartments => 'Departments';

  @override
  String get storesDepartmentsHint =>
      'Order of the “All” view. Add your own with +.';

  @override
  String get storesAddDepartment => 'Add department';

  @override
  String get voiceListening => 'Listening …';

  @override
  String get voiceStarting => 'One moment …';

  @override
  String get voiceUnavailable =>
      'Speech recognition isn’t available on this device. Just type it:';

  @override
  String get voiceError => 'That didn’t work. Try again or type:';

  @override
  String get voiceTypeInstead => 'Milk, eggs, bread …';

  @override
  String get voiceRetry => 'Try again';

  @override
  String get voiceDone => 'Done';

  @override
  String get voiceNothing => 'I didn’t catch any items.';

  @override
  String get voiceNothingHeard =>
      'Didn’t hear anything. Tap the microphone and speak.';

  @override
  String todayMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String todayDay(String name) {
    return 'Hi, $name';
  }

  @override
  String todayEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get todayMeal => 'On the menu today';

  @override
  String get todayChores => 'Due today';

  @override
  String get todayAll => 'All';

  @override
  String get todayNothingDue => 'Nothing urgent — enjoy your day.';

  @override
  String get todayShoppingEmpty => 'Shopping list is empty';

  @override
  String todayShoppingOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items on the list',
      one: '1 item on the list',
    );
    return '$_temp0';
  }

  @override
  String get reminderChannel => 'Household';

  @override
  String reminderChoresTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Due today: $count chores',
      one: 'Due today: 1 chore',
    );
    return '$_temp0';
  }

  @override
  String get reminderWasteTitle => 'Bin collection tomorrow';

  @override
  String get widgetOverdue => 'overdue';

  @override
  String get widgetMealsTitle => 'Meal plan';

  @override
  String get widgetMealsEmpty => 'Nothing planned yet';

  @override
  String get widgetTomorrow => 'Tomorrow';
}
