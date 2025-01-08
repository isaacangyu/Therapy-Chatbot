// dart format width=80
import 'package:drift/internal/versioned_schema.dart' as i0;
import 'package:drift/drift.dart' as i1;
import 'package:drift/drift.dart'; // ignore_for_file: type=lint,unused_import

// GENERATED BY drift_dev, DO NOT MODIFY.
final class Schema2 extends i0.VersionedSchema {
  Schema2({required super.database}) : super(version: 2);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    preferences,
  ];
  late final Shape0 preferences = Shape0(
      source: i0.VersionedTable(
        entityName: 'preferences',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape0 extends i0.VersionedTable {
  Shape0({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<int> get seedColor =>
      columnsByName['seed_color']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<int> _column_0(String aliasedName) =>
    i1.GeneratedColumn<int>('id', aliasedName, false,
        hasAutoIncrement: true,
        type: i1.DriftSqlType.int,
        defaultConstraints:
            i1.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
i1.GeneratedColumn<String> _column_1(String aliasedName) =>
    i1.GeneratedColumn<String>('name', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<int> _column_2(String aliasedName) =>
    i1.GeneratedColumn<int>('seed_color', aliasedName, false,
        type: i1.DriftSqlType.int);

final class Schema3 extends i0.VersionedSchema {
  Schema3({required super.database}) : super(version: 3);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    preferences,
    session,
  ];
  late final Shape0 preferences = Shape0(
      source: i0.VersionedTable(
        entityName: 'preferences',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 session = Shape1(
      source: i0.VersionedTable(
        entityName: 'session',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape1 extends i0.VersionedTable {
  Shape1({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get token =>
      columnsByName['token']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<bool> get loggedIn =>
      columnsByName['logged_in']! as i1.GeneratedColumn<bool>;
}

i1.GeneratedColumn<String> _column_3(String aliasedName) =>
    i1.GeneratedColumn<String>('token', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<bool> _column_4(String aliasedName) =>
    i1.GeneratedColumn<bool>('logged_in', aliasedName, false,
        type: i1.DriftSqlType.bool,
        defaultConstraints: i1.GeneratedColumn.constraintIsAlways(
            'CHECK ("logged_in" IN (0, 1))'));

final class Schema4 extends i0.VersionedSchema {
  Schema4({required super.database}) : super(version: 4);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    preferences,
    session,
  ];
  late final Shape0 preferences = Shape0(
      source: i0.VersionedTable(
        entityName: 'preferences',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 session = Shape1(
      source: i0.VersionedTable(
        entityName: 'session',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_5,
          _column_4,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

i1.GeneratedColumn<String> _column_5(String aliasedName) =>
    i1.GeneratedColumn<String>('token', aliasedName, true,
        type: i1.DriftSqlType.string);
i0.MigrationStepWithVersion migrationSteps({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
  required Future<void> Function(i1.Migrator m, Schema4 schema) from3To4,
}) {
  return (currentVersion, database) async {
    switch (currentVersion) {
      case 1:
        final schema = Schema2(database: database);
        final migrator = i1.Migrator(database, schema);
        await from1To2(migrator, schema);
        return 2;
      case 2:
        final schema = Schema3(database: database);
        final migrator = i1.Migrator(database, schema);
        await from2To3(migrator, schema);
        return 3;
      case 3:
        final schema = Schema4(database: database);
        final migrator = i1.Migrator(database, schema);
        await from3To4(migrator, schema);
        return 4;
      default:
        throw ArgumentError.value('Unknown migration from $currentVersion');
    }
  };
}

i1.OnUpgrade stepByStep({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
  required Future<void> Function(i1.Migrator m, Schema4 schema) from3To4,
}) =>
    i0.VersionedSchema.stepByStepHelper(
        step: migrationSteps(
      from1To2: from1To2,
      from2To3: from2To3,
      from3To4: from3To4,
    ));
