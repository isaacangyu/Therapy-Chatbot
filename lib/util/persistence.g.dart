// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence.dart';

// ignore_for_file: type=lint
class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _seedColorMeta =
      const VerificationMeta('seedColor');
  @override
  late final GeneratedColumn<int> seedColor = GeneratedColumn<int>(
      'seed_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, seedColor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(Insertable<Preference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('seed_color')) {
      context.handle(_seedColorMeta,
          seedColor.isAcceptableOrUnknown(data['seed_color']!, _seedColorMeta));
    } else if (isInserting) {
      context.missing(_seedColorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      seedColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seed_color'])!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final int id;
  final String name;
  final int seedColor;
  const Preference(
      {required this.id, required this.name, required this.seedColor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['seed_color'] = Variable<int>(seedColor);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      name: Value(name),
      seedColor: Value(seedColor),
    );
  }

  factory Preference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      seedColor: serializer.fromJson<int>(json['seedColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'seedColor': serializer.toJson<int>(seedColor),
    };
  }

  Preference copyWith({int? id, String? name, int? seedColor}) => Preference(
        id: id ?? this.id,
        name: name ?? this.name,
        seedColor: seedColor ?? this.seedColor,
      );
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      seedColor: data.seedColor.present ? data.seedColor.value : this.seedColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('seedColor: $seedColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, seedColor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.id == this.id &&
          other.name == this.name &&
          other.seedColor == this.seedColor);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> seedColor;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.seedColor = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int seedColor,
  })  : name = Value(name),
        seedColor = Value(seedColor);
  static Insertable<Preference> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? seedColor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (seedColor != null) 'seed_color': seedColor,
    });
  }

  PreferencesCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? seedColor}) {
    return PreferencesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (seedColor.present) {
      map['seed_color'] = Variable<int>(seedColor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('seedColor: $seedColor')
          ..write(')'))
        .toString();
  }
}

class $DebugTable extends Debug with TableInfo<$DebugTable, DebugData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebugTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _hotRestartPageMeta =
      const VerificationMeta('hotRestartPage');
  @override
  late final GeneratedColumn<String> hotRestartPage = GeneratedColumn<String>(
      'hot_restart_page', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, hotRestartPage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debug';
  @override
  VerificationContext validateIntegrity(Insertable<DebugData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hot_restart_page')) {
      context.handle(
          _hotRestartPageMeta,
          hotRestartPage.isAcceptableOrUnknown(
              data['hot_restart_page']!, _hotRestartPageMeta));
    } else if (isInserting) {
      context.missing(_hotRestartPageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebugData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebugData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hotRestartPage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}hot_restart_page'])!,
    );
  }

  @override
  $DebugTable createAlias(String alias) {
    return $DebugTable(attachedDatabase, alias);
  }
}

class DebugData extends DataClass implements Insertable<DebugData> {
  final int id;
  final String hotRestartPage;
  const DebugData({required this.id, required this.hotRestartPage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hot_restart_page'] = Variable<String>(hotRestartPage);
    return map;
  }

  DebugCompanion toCompanion(bool nullToAbsent) {
    return DebugCompanion(
      id: Value(id),
      hotRestartPage: Value(hotRestartPage),
    );
  }

  factory DebugData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebugData(
      id: serializer.fromJson<int>(json['id']),
      hotRestartPage: serializer.fromJson<String>(json['hotRestartPage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hotRestartPage': serializer.toJson<String>(hotRestartPage),
    };
  }

  DebugData copyWith({int? id, String? hotRestartPage}) => DebugData(
        id: id ?? this.id,
        hotRestartPage: hotRestartPage ?? this.hotRestartPage,
      );
  DebugData copyWithCompanion(DebugCompanion data) {
    return DebugData(
      id: data.id.present ? data.id.value : this.id,
      hotRestartPage: data.hotRestartPage.present
          ? data.hotRestartPage.value
          : this.hotRestartPage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebugData(')
          ..write('id: $id, ')
          ..write('hotRestartPage: $hotRestartPage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hotRestartPage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebugData &&
          other.id == this.id &&
          other.hotRestartPage == this.hotRestartPage);
}

class DebugCompanion extends UpdateCompanion<DebugData> {
  final Value<int> id;
  final Value<String> hotRestartPage;
  const DebugCompanion({
    this.id = const Value.absent(),
    this.hotRestartPage = const Value.absent(),
  });
  DebugCompanion.insert({
    this.id = const Value.absent(),
    required String hotRestartPage,
  }) : hotRestartPage = Value(hotRestartPage);
  static Insertable<DebugData> custom({
    Expression<int>? id,
    Expression<String>? hotRestartPage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hotRestartPage != null) 'hot_restart_page': hotRestartPage,
    });
  }

  DebugCompanion copyWith({Value<int>? id, Value<String>? hotRestartPage}) {
    return DebugCompanion(
      id: id ?? this.id,
      hotRestartPage: hotRestartPage ?? this.hotRestartPage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hotRestartPage.present) {
      map['hot_restart_page'] = Variable<String>(hotRestartPage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebugCompanion(')
          ..write('id: $id, ')
          ..write('hotRestartPage: $hotRestartPage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $DebugTable debug = $DebugTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferences, debug];
}

typedef $$PreferencesTableCreateCompanionBuilder = PreferencesCompanion
    Function({
  Value<int> id,
  required String name,
  required int seedColor,
});
typedef $$PreferencesTableUpdateCompanionBuilder = PreferencesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> seedColor,
});

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get seedColor => $composableBuilder(
      column: $table.seedColor, builder: (column) => ColumnFilters(column));
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get seedColor => $composableBuilder(
      column: $table.seedColor, builder: (column) => ColumnOrderings(column));
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get seedColor =>
      $composableBuilder(column: $table.seedColor, builder: (column) => column);
}

class $$PreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PreferencesTable,
    Preference,
    $$PreferencesTableFilterComposer,
    $$PreferencesTableOrderingComposer,
    $$PreferencesTableAnnotationComposer,
    $$PreferencesTableCreateCompanionBuilder,
    $$PreferencesTableUpdateCompanionBuilder,
    (Preference, BaseReferences<_$AppDatabase, $PreferencesTable, Preference>),
    Preference,
    PrefetchHooks Function()> {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> seedColor = const Value.absent(),
          }) =>
              PreferencesCompanion(
            id: id,
            name: name,
            seedColor: seedColor,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int seedColor,
          }) =>
              PreferencesCompanion.insert(
            id: id,
            name: name,
            seedColor: seedColor,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PreferencesTable,
    Preference,
    $$PreferencesTableFilterComposer,
    $$PreferencesTableOrderingComposer,
    $$PreferencesTableAnnotationComposer,
    $$PreferencesTableCreateCompanionBuilder,
    $$PreferencesTableUpdateCompanionBuilder,
    (Preference, BaseReferences<_$AppDatabase, $PreferencesTable, Preference>),
    Preference,
    PrefetchHooks Function()>;
typedef $$DebugTableCreateCompanionBuilder = DebugCompanion Function({
  Value<int> id,
  required String hotRestartPage,
});
typedef $$DebugTableUpdateCompanionBuilder = DebugCompanion Function({
  Value<int> id,
  Value<String> hotRestartPage,
});

class $$DebugTableFilterComposer extends Composer<_$AppDatabase, $DebugTable> {
  $$DebugTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hotRestartPage => $composableBuilder(
      column: $table.hotRestartPage,
      builder: (column) => ColumnFilters(column));
}

class $$DebugTableOrderingComposer
    extends Composer<_$AppDatabase, $DebugTable> {
  $$DebugTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hotRestartPage => $composableBuilder(
      column: $table.hotRestartPage,
      builder: (column) => ColumnOrderings(column));
}

class $$DebugTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebugTable> {
  $$DebugTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hotRestartPage => $composableBuilder(
      column: $table.hotRestartPage, builder: (column) => column);
}

class $$DebugTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebugTable,
    DebugData,
    $$DebugTableFilterComposer,
    $$DebugTableOrderingComposer,
    $$DebugTableAnnotationComposer,
    $$DebugTableCreateCompanionBuilder,
    $$DebugTableUpdateCompanionBuilder,
    (DebugData, BaseReferences<_$AppDatabase, $DebugTable, DebugData>),
    DebugData,
    PrefetchHooks Function()> {
  $$DebugTableTableManager(_$AppDatabase db, $DebugTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebugTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebugTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebugTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> hotRestartPage = const Value.absent(),
          }) =>
              DebugCompanion(
            id: id,
            hotRestartPage: hotRestartPage,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String hotRestartPage,
          }) =>
              DebugCompanion.insert(
            id: id,
            hotRestartPage: hotRestartPage,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DebugTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebugTable,
    DebugData,
    $$DebugTableFilterComposer,
    $$DebugTableOrderingComposer,
    $$DebugTableAnnotationComposer,
    $$DebugTableCreateCompanionBuilder,
    $$DebugTableUpdateCompanionBuilder,
    (DebugData, BaseReferences<_$AppDatabase, $DebugTable, DebugData>),
    DebugData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$DebugTableTableManager get debug =>
      $$DebugTableTableManager(_db, _db.debug);
}
