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
  late final GeneratedColumn<int> seedColor = GeneratedColumn<int>(
      'seed_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, seedColor];
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
  final int seedColor;
  const PreferencesData({required this.id, required this.seedColor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['seed_color'] = Variable<int>(seedColor);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      seedColor: Value(seedColor),
    );
  }

  factory PreferencesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesData(
      id: serializer.fromJson<int>(json['id']),
      seedColor: serializer.fromJson<int>(json['seedColor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seedColor': serializer.toJson<int>(seedColor),
    };
  }

  PreferencesData copyWith({int? id, int? seedColor}) => PreferencesData(
        id: id ?? this.id,
        seedColor: seedColor ?? this.seedColor,
      );
  PreferencesData copyWithCompanion(PreferencesCompanion data) {
    return PreferencesData(
      id: data.id.present ? data.id.value : this.id,
      seedColor: data.seedColor.present ? data.seedColor.value : this.seedColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesData(')
          ..write('id: $id, ')
          ..write('seedColor: $seedColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, seedColor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferencesData &&
          other.id == this.id &&
          other.seedColor == this.seedColor);
}

class PreferencesCompanion extends UpdateCompanion<PreferencesData> {
  final Value<int> id;
  final Value<int> seedColor;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.seedColor = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    required int seedColor,
  }) : seedColor = Value(seedColor);
  static Insertable<PreferencesData> custom({
    Expression<int>? id,
    Expression<int>? seedColor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seedColor != null) 'seed_color': seedColor,
    });
  }

  PreferencesCompanion copyWith({Value<int>? id, Value<int>? seedColor}) {
    return PreferencesCompanion(
      id: id ?? this.id,
      seedColor: seedColor ?? this.seedColor,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('seedColor: $seedColor')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV5 extends GeneratedDatabase {
  DatabaseAtV5(QueryExecutor e) : super(e);
  late final Preferences preferences = Preferences(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferences];
  @override
  int get schemaVersion => 5;
}
