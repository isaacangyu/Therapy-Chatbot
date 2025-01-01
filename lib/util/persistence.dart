import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'persistence.g.dart';

class Preferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get seedColor => integer()();
}

@DriftDatabase(tables: [Preferences])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      
      var defaultSeedColor = const Color.fromARGB(255, 100, 149, 237).value;
      await into(preferences).insert(PreferencesCompanion(
        name: const Value('default'),
        seedColor: Value(defaultSeedColor),
      ));
      await into(preferences).insert(PreferencesCompanion(
        name: const Value('user'),
        seedColor: Value(defaultSeedColor),
      ));
    },
  );

  Future<Preference> getUserPreferences() async {
    return await (select(preferences)..where((t) => t.name.equals('user'))).getSingle();
  }

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: 'therapy_chatbot_database');
  }
}
