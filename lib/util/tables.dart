import 'package:drift/drift.dart';

class Preferences extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();
  IntColumn get seedColor => integer()();
}

class Session extends Table with AutoIncrementingPrimaryKey {
  TextColumn get token => text().nullable()();
  BoolColumn get loggedIn => boolean()();
}

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}
