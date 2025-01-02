import 'package:drift/drift.dart';

class Preferences extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();
  IntColumn get seedColor => integer()();
}

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}
