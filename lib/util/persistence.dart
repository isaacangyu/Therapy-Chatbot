import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:therapy_chatbot/util/tables.dart';
import 'connection/connection.dart' as impl;

part 'persistence.g.dart';

@DriftDatabase(tables: [Preferences])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? e])
    : super(
      e ??
        driftDatabase(
          name: 'therapy_chatbot_database',
          native: const DriftNativeOptions(
            databaseDirectory: getApplicationSupportDirectory,
          ),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
            onResult: (result) {
              if (result.missingFeatures.isNotEmpty) {
                debugPrint(
                  'Using ${result.chosenImplementation} due to unsupported '
                  'browser features: ${result.missingFeatures}',
                );
              }
            },
          ),
        ),
    );

  AppDatabase.forTesting(DatabaseConnection super.connection);
  
  @override
  int get schemaVersion => 2;

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
    beforeOpen: (details) async {
      // Enabling foreign key contraints ensures 
      // that child tables only reference values that 
      // exist in parent tables.
      await customStatement('PRAGMA foreign_keys = ON');
      await impl.validateDatabaseSchema(this);
    }
  );

  Future<Preference> getUserPreferences() async {
    return await (select(preferences)..where((t) => t.name.equals('user'))).getSingle();
  }
}
