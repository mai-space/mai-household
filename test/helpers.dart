import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mai_household/data/app_database.dart';
import 'package:mai_household/data/data_context.dart';
import 'package:mai_household/data/seed.dart';

/// Frische In-Memory-Datenbank mit eingebauten Einträgen und Person.
Future<DataContext> testContext({String name = 'Lena'}) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final db = AppDatabase(NativeDatabase.memory());
  final ctx = DataContext(db);
  await ctx.load();
  await seedBuiltins(ctx);
  final s = ctx.stamp();
  await db
      .into(db.members)
      .insert(
        MembersCompanion.insert(
          id: ctx.memberId,
          updatedAt: s.updatedAt,
          seq: s.seq,
          name: name,
          color: memberColors.first,
        ),
      );
  return ctx;
}
