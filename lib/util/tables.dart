import 'package:drift/drift.dart';

class Preferences extends Table with AutoIncrementingPrimaryKey {
  IntColumn get seedColor => integer()();
}

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}
