import 'package:drift/drift.dart';

class WorkspaceTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();
}

class TestGroupTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  IntColumn get workspace =>
      integer().references(WorkspaceTable, #id, onDelete: KeyAction.cascade)();
}

class TestScenarioTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get description => text()();

  IntColumn get numberOfRequests => integer()();

  IntColumn get threadPoolSize => integer()();

  TextColumn get url => text()();

  TextColumn get method => text()();

  TextColumn get body => text()();

  BlobColumn get httpParams => blob()();

  BlobColumn get httpHeaders => blob()();

  IntColumn get testGroup =>
      integer().references(TestGroupTable, #id, onDelete: KeyAction.cascade)();
}
