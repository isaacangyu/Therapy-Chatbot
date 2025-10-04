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
  static const VerificationMeta _seedColorMeta =
      const VerificationMeta('seedColor');
  @override
  late final GeneratedColumn<int> seedColor = GeneratedColumn<int>(
      'seed_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timerValueMeta =
      const VerificationMeta('timerValue');
  @override
  late final GeneratedColumn<int> timerValue = GeneratedColumn<int>(
      'timer_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _speedValueMeta =
      const VerificationMeta('speedValue');
  @override
  late final GeneratedColumn<double> speedValue = GeneratedColumn<double>(
      'speed_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, seedColor, timerValue, speedValue];
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
    if (data.containsKey('seed_color')) {
      context.handle(_seedColorMeta,
          seedColor.isAcceptableOrUnknown(data['seed_color']!, _seedColorMeta));
    } else if (isInserting) {
      context.missing(_seedColorMeta);
    }
    if (data.containsKey('timer_value')) {
      context.handle(
          _timerValueMeta,
          timerValue.isAcceptableOrUnknown(
              data['timer_value']!, _timerValueMeta));
    } else if (isInserting) {
      context.missing(_timerValueMeta);
    }
    if (data.containsKey('speed_value')) {
      context.handle(
          _speedValueMeta,
          speedValue.isAcceptableOrUnknown(
              data['speed_value']!, _speedValueMeta));
    } else if (isInserting) {
      context.missing(_speedValueMeta);
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
      seedColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seed_color'])!,
      timerValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timer_value'])!,
      speedValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}speed_value'])!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final int id;
  final int seedColor;
  final int timerValue;
  final double speedValue;
  const Preference(
      {required this.id,
      required this.seedColor,
      required this.timerValue,
      required this.speedValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['seed_color'] = Variable<int>(seedColor);
    map['timer_value'] = Variable<int>(timerValue);
    map['speed_value'] = Variable<double>(speedValue);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      seedColor: Value(seedColor),
      timerValue: Value(timerValue),
      speedValue: Value(speedValue),
    );
  }

  factory Preference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      id: serializer.fromJson<int>(json['id']),
      seedColor: serializer.fromJson<int>(json['seedColor']),
      timerValue: serializer.fromJson<int>(json['timerValue']),
      speedValue: serializer.fromJson<double>(json['speedValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seedColor': serializer.toJson<int>(seedColor),
      'timerValue': serializer.toJson<int>(timerValue),
      'speedValue': serializer.toJson<double>(speedValue),
    };
  }

  Preference copyWith(
          {int? id, int? seedColor, int? timerValue, double? speedValue}) =>
      Preference(
        id: id ?? this.id,
        seedColor: seedColor ?? this.seedColor,
        timerValue: timerValue ?? this.timerValue,
        speedValue: speedValue ?? this.speedValue,
      );
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      id: data.id.present ? data.id.value : this.id,
      seedColor: data.seedColor.present ? data.seedColor.value : this.seedColor,
      timerValue:
          data.timerValue.present ? data.timerValue.value : this.timerValue,
      speedValue:
          data.speedValue.present ? data.speedValue.value : this.speedValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('id: $id, ')
          ..write('seedColor: $seedColor, ')
          ..write('timerValue: $timerValue, ')
          ..write('speedValue: $speedValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, seedColor, timerValue, speedValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.id == this.id &&
          other.seedColor == this.seedColor &&
          other.timerValue == this.timerValue &&
          other.speedValue == this.speedValue);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<int> id;
  final Value<int> seedColor;
  final Value<int> timerValue;
  final Value<double> speedValue;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.seedColor = const Value.absent(),
    this.timerValue = const Value.absent(),
    this.speedValue = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    required int seedColor,
    required int timerValue,
    required double speedValue,
  })  : seedColor = Value(seedColor),
        timerValue = Value(timerValue),
        speedValue = Value(speedValue);
  static Insertable<Preference> custom({
    Expression<int>? id,
    Expression<int>? seedColor,
    Expression<int>? timerValue,
    Expression<double>? speedValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seedColor != null) 'seed_color': seedColor,
      if (timerValue != null) 'timer_value': timerValue,
      if (speedValue != null) 'speed_value': speedValue,
    });
  }

  PreferencesCompanion copyWith(
      {Value<int>? id,
      Value<int>? seedColor,
      Value<int>? timerValue,
      Value<double>? speedValue}) {
    return PreferencesCompanion(
      id: id ?? this.id,
      seedColor: seedColor ?? this.seedColor,
      timerValue: timerValue ?? this.timerValue,
      speedValue: speedValue ?? this.speedValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seedColor.present) {
      map['seed_color'] = Variable<int>(seedColor.value);
    }
    if (timerValue.present) {
      map['timer_value'] = Variable<int>(timerValue.value);
    }
    if (speedValue.present) {
      map['speed_value'] = Variable<double>(speedValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('seedColor: $seedColor, ')
          ..write('timerValue: $timerValue, ')
          ..write('speedValue: $speedValue')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferences];
}

typedef $$PreferencesTableCreateCompanionBuilder = PreferencesCompanion
    Function({
  Value<int> id,
  required int seedColor,
  required int timerValue,
  required double speedValue,
});
typedef $$PreferencesTableUpdateCompanionBuilder = PreferencesCompanion
    Function({
  Value<int> id,
  Value<int> seedColor,
  Value<int> timerValue,
  Value<double> speedValue,
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

  ColumnFilters<int> get seedColor => $composableBuilder(
      column: $table.seedColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timerValue => $composableBuilder(
      column: $table.timerValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get speedValue => $composableBuilder(
      column: $table.speedValue, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<int> get seedColor => $composableBuilder(
      column: $table.seedColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timerValue => $composableBuilder(
      column: $table.timerValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get speedValue => $composableBuilder(
      column: $table.speedValue, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<int> get seedColor =>
      $composableBuilder(column: $table.seedColor, builder: (column) => column);

  GeneratedColumn<int> get timerValue => $composableBuilder(
      column: $table.timerValue, builder: (column) => column);

  GeneratedColumn<double> get speedValue => $composableBuilder(
      column: $table.speedValue, builder: (column) => column);
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
            Value<int> seedColor = const Value.absent(),
            Value<int> timerValue = const Value.absent(),
            Value<double> speedValue = const Value.absent(),
          }) =>
              PreferencesCompanion(
            id: id,
            seedColor: seedColor,
            timerValue: timerValue,
            speedValue: speedValue,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int seedColor,
            required int timerValue,
            required double speedValue,
          }) =>
              PreferencesCompanion.insert(
            id: id,
            seedColor: seedColor,
            timerValue: timerValue,
            speedValue: speedValue,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
}
