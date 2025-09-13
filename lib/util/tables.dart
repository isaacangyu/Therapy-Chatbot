import 'package:drift/drift.dart';

class Preferences extends Table with AutoIncrementingPrimaryKey {
  IntColumn get seedColor => integer()();
  IntColumn get timerValue => integer()();
  RealColumn get speedValue => real()();
}

mixin AutoIncrementingPrimaryKey on Table {
  IntColumn get id => integer().autoIncrement()();
}
