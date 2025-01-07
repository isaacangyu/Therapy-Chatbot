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

class Session extends Table with TableInfo<Session, SessionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Session(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token'])!,
      loggedIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}logged_in'])!,
    );
  }

  @override
  Session createAlias(String alias) {
    return Session(attachedDatabase, alias);
  }
}

class SessionData extends DataClass implements Insertable<SessionData> {
  final int id;
  final String token;
  final bool loggedIn;
  const SessionData(
      {required this.id, required this.token, required this.loggedIn});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['token'] = Variable<String>(token);
    map['logged_in'] = Variable<bool>(loggedIn);
    return map;
  }

  SessionCompanion toCompanion(bool nullToAbsent) {
    return SessionCompanion(
      id: Value(id),
      token: Value(token),
      loggedIn: Value(loggedIn),
    );
  }

  factory SessionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionData(
      id: serializer.fromJson<int>(json['id']),
      token: serializer.fromJson<String>(json['token']),
      loggedIn: serializer.fromJson<bool>(json['loggedIn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'token': serializer.toJson<String>(token),
      'loggedIn': serializer.toJson<bool>(loggedIn),
    };
  }

  SessionData copyWith({int? id, String? token, bool? loggedIn}) => SessionData(
        id: id ?? this.id,
        token: token ?? this.token,
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
  final Value<String> token;
  final Value<bool> loggedIn;
  const SessionCompanion({
    this.id = const Value.absent(),
    this.token = const Value.absent(),
    this.loggedIn = const Value.absent(),
  });
  SessionCompanion.insert({
    this.id = const Value.absent(),
    required String token,
    required bool loggedIn,
  })  : token = Value(token),
        loggedIn = Value(loggedIn);
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
      {Value<int>? id, Value<String>? token, Value<bool>? loggedIn}) {
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

class DatabaseAtV3 extends GeneratedDatabase {
  DatabaseAtV3(QueryExecutor e) : super(e);
  late final Preferences preferences = Preferences(this);
  late final Session session = Session(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [preferences, session];
  @override
  int get schemaVersion => 3;
}
