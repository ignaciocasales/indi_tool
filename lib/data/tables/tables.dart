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

  IntColumn get testGroup =>
      integer().references(TestGroupTable, #id, onDelete: KeyAction.cascade)();
}

class IndiHttpRequestTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get url => text()();

  TextColumn get method => text()();

  TextColumn get body => text()();

  IntColumn get testScenario => integer()
      .references(TestScenarioTable, #id, onDelete: KeyAction.cascade)();
}

class IndiHttpParamTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get key => text()();

  TextColumn get value => text()();

  BoolColumn get enabled => boolean()();

  TextColumn get description => text()();

  IntColumn get indiHttpRequest => integer()
      .references(IndiHttpRequestTable, #id, onDelete: KeyAction.cascade)();
}

class IndiHttpHeaderTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get key => text()();

  TextColumn get value => text()();

  BoolColumn get enabled => boolean()();

  TextColumn get description => text()();

  IntColumn get indiHttpRequest => integer()
      .references(IndiHttpRequestTable, #id, onDelete: KeyAction.cascade)();
}
