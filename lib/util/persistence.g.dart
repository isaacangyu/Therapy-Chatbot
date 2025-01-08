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

class $SessionTable extends Session with TableInfo<$SessionTable, SessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _loggedInMeta =
      const VerificationMeta('loggedIn');
  @override
  late final GeneratedColumn<bool> loggedIn = GeneratedColumn<bool>(
      'logged_in', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("logged_in" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, token, loggedIn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session';
  @override
  VerificationContext validateIntegrity(Insertable<SessionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    }
    if (data.containsKey('logged_in')) {
      context.handle(_loggedInMeta,
          loggedIn.isAcceptableOrUnknown(data['logged_in']!, _loggedInMeta));
    } else if (isInserting) {
      context.missing(_loggedInMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token']),
      loggedIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}logged_in'])!,
    );
  }

  @override
  $SessionTable createAlias(String alias) {
    return $SessionTable(attachedDatabase, alias);
  }
}

class SessionData extends DataClass implements Insertable<SessionData> {
  final int id;
  final String? token;
  final bool loggedIn;
  const SessionData({required this.id, this.token, required this.loggedIn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    map['logged_in'] = Variable<bool>(loggedIn);
    return map;
  }

  SessionCompanion toCompanion(bool nullToAbsent) {
    return SessionCompanion(
      id: Value(id),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      loggedIn: Value(loggedIn),
    );
  }

  factory SessionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionData(
      id: serializer.fromJson<int>(json['id']),
      token: serializer.fromJson<String?>(json['token']),
      loggedIn: serializer.fromJson<bool>(json['loggedIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'token': serializer.toJson<String?>(token),
      'loggedIn': serializer.toJson<bool>(loggedIn),
    };
  }

  SessionData copyWith(
          {int? id,
          Value<String?> token = const Value.absent(),
          bool? loggedIn}) =>
      SessionData(
        id: id ?? this.id,
        token: token.present ? token.value : this.token,
        loggedIn: loggedIn ?? this.loggedIn,
      );
  SessionData copyWithCompanion(SessionCompanion data) {
    return SessionData(
      id: data.id.present ? data.id.value : this.id,
      token: data.token.present ? data.token.value : this.token,
      loggedIn: data.loggedIn.present ? data.loggedIn.value : this.loggedIn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionData(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('loggedIn: $loggedIn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, token, loggedIn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionData &&
          other.id == this.id &&
          other.token == this.token &&
          other.loggedIn == this.loggedIn);
}

class SessionCompanion extends UpdateCompanion<SessionData> {
  final Value<int> id;
  final Value<String?> token;
  final Value<bool> loggedIn;
  const SessionCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    this.loggedIn = const Value.absent(),
  });
  SessionCompanion.insert({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    required bool loggedIn,
  }) : loggedIn = Value(loggedIn);
  static Insertable<SessionData> custom({
    Expression<int>? id,
    Expression<String>? token,
    Expression<bool>? loggedIn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (token != null) 'token': token,
      if (loggedIn != null) 'logged_in': loggedIn,
    });
  }

  SessionCompanion copyWith(
      {Value<int>? id, Value<String?>? token, Value<bool>? loggedIn}) {
    return SessionCompanion(
      id: id ?? this.id,
      token: token ?? this.token,
      loggedIn: loggedIn ?? this.loggedIn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (loggedIn.present) {
      map['logged_in'] = Variable<bool>(loggedIn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionCompanion(')
          ..write('id: $id, ')
          ..write('token: $token, ')
          ..write('loggedIn: $loggedIn')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $SessionTable session = $SessionTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferences, session];
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
typedef $$SessionTableCreateCompanionBuilder = SessionCompanion Function({
  Value<int> id,
  Value<String?> token,
  required bool loggedIn,
});
typedef $$SessionTableUpdateCompanionBuilder = SessionCompanion Function({
  Value<int> id,
  Value<String?> token,
  Value<bool> loggedIn,
});

class $$SessionTableFilterComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get loggedIn => $composableBuilder(
      column: $table.loggedIn, builder: (column) => ColumnFilters(column));
}

class $$SessionTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get loggedIn => $composableBuilder(
      column: $table.loggedIn, builder: (column) => ColumnOrderings(column));
}

class $$SessionTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionTable> {
  $$SessionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<bool> get loggedIn =>
      $composableBuilder(column: $table.loggedIn, builder: (column) => column);
}

class $$SessionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionTable,
    SessionData,
    $$SessionTableFilterComposer,
    $$SessionTableOrderingComposer,
    $$SessionTableAnnotationComposer,
    $$SessionTableCreateCompanionBuilder,
    $$SessionTableUpdateCompanionBuilder,
    (SessionData, BaseReferences<_$AppDatabase, $SessionTable, SessionData>),
    SessionData,
    PrefetchHooks Function()> {
  $$SessionTableTableManager(_$AppDatabase db, $SessionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<bool> loggedIn = const Value.absent(),
          }) =>
              SessionCompanion(
            id: id,
            token: token,
            loggedIn: loggedIn,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> token = const Value.absent(),
            required bool loggedIn,
          }) =>
              SessionCompanion.insert(
            id: id,
            token: token,
            loggedIn: loggedIn,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionTable,
    SessionData,
    $$SessionTableFilterComposer,
    $$SessionTableOrderingComposer,
    $$SessionTableAnnotationComposer,
    $$SessionTableCreateCompanionBuilder,
    $$SessionTableUpdateCompanionBuilder,
    (SessionData, BaseReferences<_$AppDatabase, $SessionTable, SessionData>),
    SessionData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$SessionTableTableManager get session =>
      $$SessionTableTableManager(_db, _db.session);
}
