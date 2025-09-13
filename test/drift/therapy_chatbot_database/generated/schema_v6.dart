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
  late final GeneratedColumn<int> timerValue = GeneratedColumn<int>(
      'timer_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesData(
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
  Preferences createAlias(String alias) {
    return Preferences(attachedDatabase, alias);
  }
}

class PreferencesData extends DataClass implements Insertable<PreferencesData> {
  final int id;
  final int seedColor;
  final int timerValue;
  final double speedValue;
  const PreferencesData(
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

  factory PreferencesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesData(
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

  PreferencesData copyWith(
          {int? id, int? seedColor, int? timerValue, double? speedValue}) =>
      PreferencesData(
        id: id ?? this.id,
        seedColor: seedColor ?? this.seedColor,
        timerValue: timerValue ?? this.timerValue,
        speedValue: speedValue ?? this.speedValue,
      );
  PreferencesData copyWithCompanion(PreferencesCompanion data) {
    return PreferencesData(
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
    return (StringBuffer('PreferencesData(')
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
      (other is PreferencesData &&
          other.id == this.id &&
          other.seedColor == this.seedColor &&
          other.timerValue == this.timerValue &&
          other.speedValue == this.speedValue);
}

class PreferencesCompanion extends UpdateCompanion<PreferencesData> {
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
  static Insertable<PreferencesData> custom({
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

class DatabaseAtV6 extends GeneratedDatabase {
  DatabaseAtV6(QueryExecutor e) : super(e);
  late final Preferences preferences = Preferences(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferences];
  @override
  int get schemaVersion => 6;
}
