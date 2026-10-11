import 'dart:async';

import 'package:flutter/widgets.dart';

import '../data/app_database.dart';
import '../data/data_context.dart';
import '../data/repositories/chore_repository.dart';
import '../data/repositories/household_repository.dart';
import '../data/repositories/recipe_repository.dart';
import '../data/repositories/shopping_repository.dart';
import '../services/reminders.dart';
import '../sync/sync_service.dart';

/// Alle Dienste der App an einem Ort (ohne zusätzliches State-Paket).
class AppServices {
  AppServices(this.ctx)
    : household = HouseholdRepository(ctx),
      shopping = ShoppingRepository(ctx),
      chores = ChoreRepository(ctx),
      recipes = RecipeRepository(ctx),
      sync = SyncService(ctx),
      reminders = Reminders(ctx);

  final DataContext ctx;
  final HouseholdRepository household;
  final ShoppingRepository shopping;
  final ChoreRepository chores;
  final RecipeRepository recipes;
  final SyncService sync;
  final Reminders reminders;

  AppDatabase get db => ctx.db;

  Timer? _rescheduleTimer;
  StreamSubscription<void>? _sub;

  /// Erinnerungen nach Änderungen (auch vom anderen Gerät) neu planen.
  void watchForReminders() {
    _sub ??= ctx.db
        .tableUpdates()
        .listen((_) => scheduleReminders());
  }

  void scheduleReminders() {
    _rescheduleTimer?.cancel();
    _rescheduleTimer = Timer(const Duration(seconds: 3), () {
      reminders.reschedule().catchError((_) {});
    });
  }

  Future<void> dispose() async {
    _rescheduleTimer?.cancel();
    await _sub?.cancel();
    await sync.dispose();
    await ctx.dispose();
    await ctx.db.close();
  }
}

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.services, required super.child});

  final AppServices services;

  /// Dienste ändern sich nie — daher ohne Abhängigkeit (auch in
  /// `initState` nutzbar).
  static AppServices of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.services;

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      services != oldWidget.services;
}

extension AppScopeContext on BuildContext {
  AppServices get services => AppScope.of(this);
}
