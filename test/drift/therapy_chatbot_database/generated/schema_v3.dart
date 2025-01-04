// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Preferences extends Table with TableInfo<Preferences, PreferencesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Preferences(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      seedColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seed_color'])!,
    );
  }

  @override
  Preferences createAlias(String alias) {
    return Preferences(attachedDatabase, alias);
  }
}

class PreferencesData extends DataClass implements Insertable<PreferencesData> {
  final int id;
  final String name;
  final int seedColor;
  const PreferencesData(
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

  factory PreferencesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesData(
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

  PreferencesData copyWith({int? id, String? name, int? seedColor}) =>
      PreferencesData(
        id: id ?? this.id,
        name: name ?? this.name,
        seedColor: seedColor ?? this.seedColor,
      );
  PreferencesData copyWithCompanion(PreferencesCompanion data) {
    return PreferencesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      seedColor: data.seedColor.present ? data.seedColor.value : this.seedColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesData(')
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
      (other is PreferencesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.seedColor == this.seedColor);
}

class PreferencesCompanion extends UpdateCompanion<PreferencesData> {
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
  static Insertable<PreferencesData> custom({
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

class Debug extends Table with TableInfo<Debug, DebugData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Debug(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
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
  Debug createAlias(String alias) {
    return Debug(attachedDatabase, alias);
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

class DatabaseAtV3 extends GeneratedDatabase {
  DatabaseAtV3(QueryExecutor e) : super(e);
  late final Preferences preferences = Preferences(this);
  late final Debug debug = Debug(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferences, debug];
  @override
  int get schemaVersion => 3;
}
