import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'persistence.g.dart';

class Preferences extends Table {
  IntColumn get id => integer().autoIncrement()();
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

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: 'my_database');
  }
}
