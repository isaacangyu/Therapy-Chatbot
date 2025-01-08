import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '/util/tables.dart';
import '/util/persistence.steps.dart';
import '/util/connection/connection.dart' as impl;
import '/util/global.dart';

part 'persistence.g.dart';

@DriftDatabase(tables: [Preferences, Session])
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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      await customStatement('PRAGMA foreign_keys = OFF');

      await m.runMigrationSteps(
        from: from,
        to: to,
        steps: migrationSteps(
          from1To2: (m, schema) async {
            // Nothing.
          },
          from2To3: (m, schema) async {
            await m.createTable(schema.session);
            await into(session).insert(const SessionCompanion(
              token: Value(''),
              loggedIn: Value(false),
            ));
          },
          from3To4: (m, schema) async {
            await m.alterTable(
              TableMigration(session, columnTransformer: {
                session.token: session.token.cast<String>(),
              })
            );
            var sessionData = await (select(session)..where((t) => t.id.equals(1))).getSingleOrNull();
            if (sessionData != null && sessionData.token == '') {
              await (update(session)..where((t) => t.id.equals(1))).write(SessionCompanion(
                token: const Value(null),
                loggedIn: Value(sessionData.loggedIn),
              ));
            }
            debugPrint('Ran database migration: 3 -> 4');
          },
        )
      );

      // Assert that the schema is valid after migrations.
      if (kDebugMode) {
        final wrongForeignKeys = await customSelect('PRAGMA foreign_key_check').get();
        assert(wrongForeignKeys.isEmpty, '${wrongForeignKeys.map((e) => e.data)}');
      }
    },
    onCreate: (m) async {
      await m.createAll();
      
      await into(preferences).insert(Global.defaultBasePreferences);
      await into(preferences).insert(Global.defaultUserPreferences);
      await into(session).insert(const SessionCompanion(
        token: Value(null),
        loggedIn: Value(false),
      ));
    },
    beforeOpen: (details) async {
      if (!kDebugMode) {
        return;
      }
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
  
  Future<SessionData> getSession() async {
    return await (select(session)..where((t) => t.id.equals(1))).getSingle();
  }
}
